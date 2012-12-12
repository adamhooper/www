class Blog::Post < ActiveRecord::Base
  self.table_name = 'blog_posts'

  has_many :comments, :foreign_key => 'blog_post_id'
  has_and_belongs_to_many :tags, :class_name => 'Tag', :join_table => 'blog_posts_tags', :foreign_key => 'blog_post_id'

  scope :with_tag, lambda { |*args| args.first && { :include => 'tags', :conditions => { 'tags.name' => args.first } } || {} }

  validates_presence_of :title, :body, :format
  validates_uniqueness_of :title, :body

  def tag_names
    tags.map(&:name).sort.join(', ')
  end

  def tag_names=(new_tags)
    if String === new_tags
      new_tags = new_tags.split(',').collect(&:strip)
    end
    self.tags = new_tags.collect{|name| Tag::find_or_initialize_by_name(name)}
  end

  def to_param
    "#{id}-#{title.parameterize}"
  end
end
