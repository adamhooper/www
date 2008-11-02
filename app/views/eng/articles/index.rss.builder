xml.instruct! :xml, :version => '1.0'
xml.rss :version => '2.0' do
  xml.channel do
    xml.title "Adam Hooper's Engineering Tips"
    xml.desription "Articles by Adam Hooper about Software Engineering"
    xml.link blog_posts_url

    for article in @articles
      xml.item do
        xml.title article.title
        xml.description textilize(article.body)
        xml.pubDate article.created_at.to_s(:rfc822)
        xml.link eng_article_url(article)
        xml.guid eng_article_url(article)
      end
    end
  end
end
