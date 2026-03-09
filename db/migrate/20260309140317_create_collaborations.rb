class CreateCollaborations < ActiveRecord::Migration[8.1]
  def change
    create_table :collaborations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.string :role
      t.string :status
      t.boolean :owner

      t.timestamps
    end
  end
end
