module IuUserAuth
  extend ActiveSupport::Concern

  # Enable ADS group lookup
  include LDAPGroupsLookup::Behavior
  alias_attribute :ldap_lookup_key, :uid

  class_methods do
    def find_for_iu_cas(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create! do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = user.try(:ldap_mail)
        user.email = [auth.uid, '@', Galacto.config.dig(:ldap, :default_email_domain)].join if user.email.blank?
      end
    end
  end

  def groups
    @groups ||= build_groups
  end

  # Roles to add depending on user's LDAP groups and Galacto configuration
  # cache wrapper for ldap_roles_lookup
  def ldap_roles
    Rails.cache.fetch("ldap_roles-v1-#{cache_key_with_version}",
                      expires_in: 1.hour, race_condition_ttl: 1.hour) do
      ldap_roles_lookup
    end
  end

  # Roles to add depending on user's LDAP groups and Galacto configuration
  def ldap_roles_lookup(mappings: Galacto.config.dig(:ldap, :group_roles) || {})
    mappings.select { |role, groups| member_of_ldap_group?(groups) }.keys
  end

  def authorized_ldap_member?(force_update = nil)
    if force_update == :force ||
       authorized_membership_updated_at.nil? ||
       authorized_membership_updated_at < Time.now - 1.day
      groups = Galacto.config[:authorized_ldap_groups] || []
      self.authorized_membership = member_of_ldap_group?(groups)
      self.authorized_membership_updated_at = Time.now
      save
    end
    authorized_membership
  end

  # Modified method from hydra-role-management Hydra::RoleManagement::UserRoles
  def admin?
    groups.include? 'admin'
  end

  def institution_patron?
    persisted? && !guest? && provider == "cas"
  end

  def authorized_patron?
    institution_patron? && (Galacto.config[:authorized_ldap_groups].blank? ||
                       authorized_ldap_member?)
  end

  def anonymous?
    !persisted?
  end

  private

  def build_groups
    g = roles.map(&:name)
    g += ldap_roles
    g += ['registered'] if authorized_patron? || g.include?('admin')
    g
  end
end
