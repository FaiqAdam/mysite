class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :reportnumber
      t.string :reference
      t.string :species
      t.string :variety
      t.integer :weight
      t.string :dimension
      t.string :shapecut
      t.string :colour
      t.string :item
      t.string :transparency
      t.string :requesof
      t.text :comments

      t.timestamps
    end
  end
end
