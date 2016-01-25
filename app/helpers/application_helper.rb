module ApplicationHelper

    # Returns the page's full title
    def full_title(page_title = '')
        base_title = "w8mngr"
        if page_title.empty?
            base_title + " | The Lifestyle Tracker"
        else
            page_title + " | " + base_title
        end
    end
end
