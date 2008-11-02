class CreateEngArticles < ActiveRecord::Migration
  def self.up
    create_table :eng_articles do |t|
      t.string :title
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :eng_articles
  end
end
