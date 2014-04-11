class ChangeSchedules < ActiveRecord::Migration
  def up
    remove_column :schedules, :user_id
    add_column :schedules, :week_id, :integer, null: false
  end

  def down
    add_column :schedules, :user_id, :integer, null: false
    remove_column :schedules, :week_id
  end
end
