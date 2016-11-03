class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.string :nrc
      t.references :user, index: true, foreign_key: true
      t.string :period

      t.timestamps null: false
    end
  end
end
