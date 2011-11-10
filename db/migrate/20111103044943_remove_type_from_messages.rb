class RemoveTypeFromMessages < ActiveRecord::Migration
  def up
    remove_column :messages, :type
  end

  def down
    add_column :messages, :type, :integer
  end
end
