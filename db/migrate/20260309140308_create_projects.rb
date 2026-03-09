class CreateProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :projects do |t|
      t.string :title
      t.string :short_description
      t.text :description
      t.string :category
      t.string :estimated_duration
      t.integer :max_collaborators
      t.string :status

      t.timestamps
    end
  end
end
