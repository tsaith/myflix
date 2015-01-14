module ApplicationHelper


  def options_for_video_reviews(selected = 5)
    options_for_select((1..5).map{ |number| [pluralize(number, "Star"), number] }.reverse, selected)
  end


end
