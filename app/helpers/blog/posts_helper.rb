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
        ret << %(<div class="blog-month-divider-empty">#{s1} back to #{s2}: <span>(nothing)</span></div>)
      end
      s = (now << (num_months)).strftime("%h, %Y")
      ret << %(<div class="blog-month-divider">#{s}</div>)
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

  def render_comment(comment)
    if comment.body =~ /\<([pib]|em|strong|br)[^>]*\/?\>/
      Hpricot.parse(comment.body, :xhtml_strict => true).to_html
    else
      simple_format(h(comment.body))
    end.html_safe
  end
end
