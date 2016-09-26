class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.references :course, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
