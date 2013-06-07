class AddCommentSpamStatus < ActiveRecord::Migration
  def up
    change_table :blog_comments do |t|
      t.string :spam_status, :null => false, :default => 'unverified'
    end

    change_table :eng_comments do |t|
      t.string :spam_status, :null => false, :default => 'unverified'
    end
  end

  def down
    remove_column(:blog_comments, :spam_status)
    remove_column(:eng_comments, :spam_status)
  end
end
