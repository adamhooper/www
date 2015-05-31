#!/usr/bin/env ruby

require_relative '../config/environment'

puts '''<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0"
  xmlns:content="http://purl.org/rss/1.0/modules/content/"
  xmlns:dsq="http://www.disqus.com/"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:wp="http://wordpress.org/export/1.0/"
>
  <channel>'''


for post in Blog::Post.all
  puts """  <item>
    <title>#{h(post.title)}</title>
    <link>#{h(post.permalink)}</link>
    <wp:post_date_gmt>#{h(post.created_at.utc.to_s.gsub(/ UTC$/, ''))}</wp:post_date_gmt>"""
  for comment in post.comments
    puts """    <wp:comment>
      <wp:comment_id>#{comment.id}</wp:comment_id>
      <wp:comment_author>#{h(comment.author_name)}</wp:comment_author>
      <wp:comment_author_email>#{h(comment.author_email)}</wp:comment_author_email>
      <wp:comment_author_url>#{h(comment.author_website)}</wp:comment_author_url>
      <wp:comment_author_IP>#{h(comment.author_ip)}</wp:comment_author_IP>
      <wp:comment_date_gmt>#{h(comment.created_at.utc.to_s.gsub(/ UTC$/, ''))}</wp:comment_date_gmt>
      <wp:comment_content>#{h(comment.body)}</wp:comment_content>
    </wp:comment>"""
  end

  puts '''  </item>'''
end

puts '''</channel>
</rss>'''
