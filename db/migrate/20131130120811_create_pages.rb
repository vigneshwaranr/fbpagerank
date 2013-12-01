class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :name
      t.string :url
      t.string :fb_page
      t.integer :likes
      t.string :category
      t.string :description

      t.timestamps
    end
  end
end
