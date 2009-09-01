# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20081111045538) do

  create_table "blog_comments", :force => true do |t|
    t.integer  "blog_post_id",                   :null => false
    t.string   "author_name",    :default => "", :null => false
    t.string   "author_ip",      :default => "", :null => false
    t.string   "author_website", :default => "", :null => false
    t.string   "author_email",   :default => "", :null => false
    t.text     "body",           :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
  add_index "blog_posts_tags", ["blog_post_id"], :name => "index_blog_posts_tags_on_blog_post_id"
  add_index "blog_posts_tags", ["tag_id"], :name => "index_blog_posts_tags_on_tag_id"

  create_table "eng_articles", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "eng_comments", :force => true do |t|
    t.integer  "eng_article_id"
    t.string   "author_name"
    t.string   "author_ip"
    t.string   "author_website"
    t.string   "author_email"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "simple_captcha_data", :force => true do |t|
    t.string   "key",        :limit => 40
    t.string   "value",      :limit => 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
