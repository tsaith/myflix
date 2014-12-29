module ApplicationHelper


  def options_for_video_reviews(selected = 5)
    options_for_select((1..5).map{ |number| [pluralize(number, "Star"), number] }.reverse, selected)
  end


  def flash_class(level)
    case level
      when 'notice' then "alert alert-info"
      when 'success' then "alert alert-success"
      when 'error' then "alert alert-danger"
      when 'alert' then "alert alert-warning"
    end
  end

end
