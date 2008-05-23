# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080523020227) do

  create_table "blog_posts", :force => true do |t|
    t.string   "title",                          :null => false
    t.text     "body",                           :null => false
    t.string   "format",     :default => "html", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blog_posts_tags", :id => false, :force => true do |t|
    t.integer "blog_post_id"
    t.integer "tag_id"
  end

  add_index "blog_posts_tags", ["blog_post_id", "tag_id"], :name => "index_blog_posts_tags_on_blog_post_id_and_tag_id", :unique => true
  add_index "blog_posts_tags", ["tag_id"], :name => "index_blog_posts_tags_on_tag_id"
  add_index "blog_posts_tags", ["blog_post_id"], :name => "index_blog_posts_tags_on_blog_post_id"

  create_table "tags", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
