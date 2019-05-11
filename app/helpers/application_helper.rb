module ApplicationHelper

	def full_title(page_title = '')
		base_title = "Box2Share"
		if page_title.empty?
			base_title
		else
			page_title + " | " + base_title
		end
	end

  def default_locale?(language)
    I18n.default_locale == language
  end

end
