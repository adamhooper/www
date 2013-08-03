class Blog::BaseController < ApplicationController
  layout 'blog'

  # Sets @all_tag_names, so the views can use it
  def load_all_tag_names
    @all_tag_names = Tag.order(:name).pluck(:name).to_a
  end
end
