class AddUniqueConstraintToPermissionTemplateAccesses < ActiveRecord::Migration[7.2]
  def change
    add_index :permission_template_accesses,
              [:permission_template_id, :agent_id, :agent_type, :access],
              unique: true,
              name: 'uk_permission_template_accesses'
  end
end
