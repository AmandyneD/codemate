class AddFieldsToTechnologies < ActiveRecord::Migration[8.0]
  def change
    add_column :technologies, :slug, :string unless column_exists?(:technologies, :slug)
    add_column :technologies, :approved, :boolean, default: true, null: false unless column_exists?(:technologies, :approved)

    add_index :technologies, :slug, unique: true unless index_exists?(:technologies, :slug)
    add_index :technologies, :category unless index_exists?(:technologies, :category)
  end
end
