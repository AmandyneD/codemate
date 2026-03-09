class AddProfileFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :display_name, :string
    add_column :users, :bio, :text
    add_column :users, :avatar_url, :string
    add_column :users, :github_url, :string
    add_column :users, :stack_summary, :string
  end
end
