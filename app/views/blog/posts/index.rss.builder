xml.instruct! :xml, :version => '1.0'
xml.rss :version => '2.0' do
  xml.channel do
    xml.title "Adam Hooper's Blog"
    xml.desription "A log of Adam Hooper's musings"
    xml.link formatted_blog_posts_url(:rss)

    for post in @posts
      xml.item do
        xml.title post.title
        xml.description render_post(post)
        xml.pubDate post.created_at.to_s(:rfc822)
        xml.link formatted_blog_post_url(post, :rss)
        xml.guid formatted_blog_post_url(post, :rss)
      end
    end
  end
end
