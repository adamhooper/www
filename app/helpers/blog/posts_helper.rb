module Blog::PostsHelper
  # Shows one or many <div class="blog-month-divider">Month, Year</div> for
  # months between the last-shown date and the passed one, in reverse
  # chronological order.
  #
  # This method returns a memory "state" which must be passed back to
  # subsequent calls.
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
        ret << %(<div class="blog-month-divider">#{s1} back to #{s2}</div><p>(nothing)</p>)
      end
      s = (now << (num_months + 1)).strftime("%h, %Y")
      ret << %(<div class="blog-month-divider">#{s}</div>)
    end

    @month_dividers_num_months = num_months

    ret.join("\n")
  end

  # Renders the given post with HTML.
  def render_post(post)
    case post.format
    when 'html' then
      render :inline => post.body
    else
      'FIXME: Invalid post format'
    end
  end

  def render_comment(comment)
    Hpricot.parse(comment.body, :xhtml_strict => true).to_html
  end
end
