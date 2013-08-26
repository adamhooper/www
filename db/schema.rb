# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20130809204542) do

  create_table "blog_comments", force: true do |t|
    t.integer  "blog_post_id",                          null: false
    t.string   "author_name",    default: "",           null: false
    t.string   "author_ip",      default: "",           null: false
    t.string   "author_website", default: "",           null: false
    t.string   "author_email",   default: "",           null: false
    t.text     "body",                                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "spam_status",    default: "unverified", null: false
  end

  create_table "blog_posts", force: true do |t|
    t.string   "title",                       null: false
    t.text     "body",                        null: false
    t.string   "format",     default: "html", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blog_posts_tags", id: false, force: true do |t|
    t.integer "blog_post_id"
    t.integer "tag_id"
  end

  add_index "blog_posts_tags", ["blog_post_id", "tag_id"], name: "blog_posts_tags_index_blog_posts_tags_on_blog_post_id_and_tag_id"
  add_index "blog_posts_tags", ["blog_post_id"], name: "blog_posts_tags_index_blog_posts_tags_on_blog_post_id"
  add_index "blog_posts_tags", ["tag_id"], name: "blog_posts_tags_index_blog_posts_tags_on_tag_id"

  create_table "eng_articles", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "eng_comments", force: true do |t|
    t.integer  "eng_article_id"
    t.string   "author_name"
    t.string   "author_ip"
    t.string   "author_website"
    t.string   "author_email"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "spam_status",    default: "unverified", null: false
  end

  create_table "portfolio_pieces", force: true do |t|
    t.string "title",        null: false
    t.date   "published_at", null: false
    t.string "url",          null: false
    t.string "subtitle",     null: false
    t.text   "image_html",   null: false
    t.text   "hack_blurb",   null: false
    t.text   "hacker_blurb", null: false
    t.string "permalink",    null: false
  end

  add_index "portfolio_pieces", ["permalink"], name: "index_portfolio_pieces_on_permalink"
  add_index "portfolio_pieces", ["published_at"], name: "index_portfolio_pieces_on_published_at"

  create_table "tags", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
