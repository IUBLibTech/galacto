class Ability
  include Hydra::Ability
  
  include Hyrax::Ability
  self.ability_logic += [:everyone_can_create_curation_concerns]

  # Define any customized permissions here.
  def custom_permissions
    # Limits deleting objects to a the admin user
    #
    # if current_user.admin?
    #   can [:destroy], ActiveFedora::Base
    # end

    # Limits creating new objects to a specific group
    #
    # if user_groups.include? 'special_group'
    #   can [:create], ActiveFedora::Base
    # end

    if current_user.admin?
      can :manage, :sidekiq_dashboard
    end
  end

  # Override Hyrax::Ability v5.1.0 to use correct model in solr has_model_ssim
  # @return [Boolean] true if the user has at least one admin set they can deposit into.
  def admin_set_with_deposit?
    ids = Hyrax::PermissionTemplateAccess.for_user(ability: self,
                                            access: ['deposit', 'manage'])
                                  .joins(:permission_template)
                                  .select(:source_id)
                                  .distinct
                                  .pluck(:source_id)

    # Old
    # Hyrax.custom_queries.find_ids_by_model(model: Hyrax::AdministrativeSet, ids: ids).any?

    # New
    Hyrax.query_service.find_many_by_ids(ids: ids).any? do |resource|
      resource.is_a? Hyrax.config.admin_set_class
    end
  end
end
