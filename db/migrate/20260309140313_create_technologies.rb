class CreateTechnologies < ActiveRecord::Migration[8.1]
  def change
    create_table :technologies do |t|
      t.string :name
      t.string :category

      t.timestamps
    end
  end
end
