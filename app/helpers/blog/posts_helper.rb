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

    while (now << num_months).at_beginning_of_month > date.to_date
      s = (now << (num_months + 1)).strftime("%h, %Y")
      ret << %(<div class="blog-month-divider">#{s}</div>)
      num_months += 1
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
