desc 'Add role to user'
namespace :galacto do
  task :add_role_to_user, [:role, :user] => [:environment] do |t, args|
    raise Rake::TaskArgumentError.new('Usage: `rake galacto:add_role_to_user[role,username]`') if
      args[:role].blank? || args[:user].blank?

    User.transaction do
      u = User.find_by!(Hydra.config.user_key_field => args[:user])
      r = Role.find_or_create_by(name: args[:role])
      u.roles << r unless u.roles.include?(r)
      puts "User #{u.user_key} roles are now #{u.roles.collect(&:name)}"
    end
  end
end