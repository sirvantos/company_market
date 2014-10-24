module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def get_bootstrap_class_for flash_type
    {success: 'alert-success', error: 'alert-error', alert: 'alert-block', notice: 'alert-info'}[flash_type] || flash_type.to_s
  end
end
