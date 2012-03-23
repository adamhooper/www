module ApplicationHelper
  def title_for_head
    content_for(:title) || 'Adam Hooper'
  end

  def title_for_h1
    title_for_head
  end

  def href_for_h1
    href = content_for(:title_href_path) || root_path
  end
end
