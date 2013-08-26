class CreatePortfolioPieces < ActiveRecord::Migration
  def change
    create_table :portfolio_pieces do |t|
      t.string :title, null: false
      t.date :published_at, null: false
      t.string :url, null: false
      t.string :subtitle, null: false
      t.text :image_html, null: false
      t.text :hack_blurb, null: false
      t.text :hacker_blurb, null: false
      t.string :permalink, null: false

      t.index :permalink # for lookup
      t.index :published_at # for listing
    end
  end
end
