class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :name_activity
      t.integer :range
      t.decimal :latitude
      t.decimal :longitude
      t.datetime :start_date
      t.datetime :finish_date
      t.integer :duration
      t.references :course, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
