module Blog::CommentsHelper
  def comment_author_url(url)
    if url =~ %r{^\w+://}
      url
    else
      "http://#{url}"
    end
  end
end
