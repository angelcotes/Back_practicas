class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :rol
      t.references :user, index: true, foreign_key: true
      t.references :group, index: true, foreign_key: true
      t.datetime :time_start
      t.integer :duration
      t.string :status, default: 'habilitado'
      t.datetime :time_pause
      t.datetime :time_finished

      t.timestamps null: false
    end
  end
end
