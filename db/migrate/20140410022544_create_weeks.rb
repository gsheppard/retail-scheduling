class CreateWeeks < ActiveRecord::Migration
  def change
    create_table :weeks do |t|
      t.references :user
      t.datetime :week_start, null: false

      t.timestamps
    end
  end
end
