class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.datetime :due_date
      t.datetime :completed_at
      t.string :priority, default: "low"

      t.timestamps
    end
  end
end
