module Blog::PostsHelper
  # Shows perhaps a <div class="blog-month-empty">Month, Year</div> and
  # possibly a <div class="blog-month-divider"> for months between the
  # last-shown date and the passed one, in reverse chronological order.
  def month_dividers(date)
    @month_dividers_now ||= DateTime.now # In case we're running at midnight
    @month_dividers_num_months ||= 0 # Skip showing the current month

    now = @month_dividers_now
    num_months = @month_dividers_num_months

    ret = []

    first_skipped_month = (now << num_months).at_beginning_of_month

    while (now << num_months).at_beginning_of_month > date.to_date
      last_skipped_month = (now << num_months).at_beginning_of_month
      num_months += 1
    end

    if num_months != @month_dividers_num_months
      if first_skipped_month != last_skipped_month
        s1 = first_skipped_month.strftime("%h, %Y")
        s2 = last_skipped_month.strftime("%h, %Y")
        ret << %(<p class="blog-month-divider-empty">#{s1} back to #{s2}: <span>(nothing)</span></p>)
      end
      s = (now << (num_months)).strftime("%h, %Y")
      ret << %(<p class="blog-month-divider">#{s}</p>)
    end

    @month_dividers_num_months = num_months

    ret.join("\n").html_safe
  end

  # Renders the given post with HTML.
  def render_post(post)
    case post.format
    when 'html' then
      render(:inline => post.body)
    when 'redcloth' then
      textilize(post.body)
    else
      'FIXME: Invalid post format'
    end
  end

  # Renders a blog post "preview", which includes a "read more" link
  # if it's different from the entire post
  def render_post_preview(post)
    excerpt_blocks = 4
    post_html = sanitize(render_post(post))
    url = url_for(post)

    post_doc = Nokogiri::HTML(post_html) { |config| config.noent.noblanks.noerror.nowarning.recover }
    post_xml = post_doc.xpath('/html/body').first
    # Remove blank text nodes
    post_xml.xpath('./text()').each do |node|
      node.remove() if node.content =~ /^\s*$/
    end

    read_more = post_xml.xpath('./*[@class = "read-more"]').first
    if read_more
      read_more.next.remove while read_more.next
      read_more.remove
    else
      nodes_to_remove = post_xml.children[excerpt_blocks..-1]
      if nodes_to_remove && !nodes_to_remove.empty?
        excerpt_img = nodes_to_remove.xpath('.//img').first
        nodes_to_remove.each(&:remove)
        excerpt_img = nil unless post_xml.xpath('.//img').empty?

        if excerpt_img
          post_xml.children.first.before('<div class="excerpt-img"></div>')
          post_xml.children.first.add_child(excerpt_img)
        end
      end
    end

    read_more_p = content_tag(:p, link_to('Read full story', url), :class => 'read-more')

    post_xml.add_child(read_more_p)

    post_xml.to_s.html_safe
  end

  def render_comment(comment)
    s = simple_format(comment.body, {}, :sanitize => false)
    sanitize(s, :tags => %w(p i b em strong br), :attributes => [])
  end
end
