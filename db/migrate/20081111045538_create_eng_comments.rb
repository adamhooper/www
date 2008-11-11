class CreateEngComments < ActiveRecord::Migration
  def self.up
    create_table :eng_comments do |t|
      t.integer :eng_article_id
      t.string :author_name
      t.string :author_ip
      t.string :author_website
      t.string :author_email
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :eng_comments
  end
end
