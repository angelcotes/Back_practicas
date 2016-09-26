class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :type_document
      t.string :address
      t.references :member, index: true, foreign_key: true
      t.references :group, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
