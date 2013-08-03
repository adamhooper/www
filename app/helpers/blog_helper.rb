module BlogHelper
  def tag_list
    render('blog/tag_names', :tag_names => @all_tag_names)
  end
end
