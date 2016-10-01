class MarkdownText

  # A basic markdown renderer without links or HTML.
  def self.render_basic text
    html_renderer = Redcarpet::Render::HTML.new(
        filter_html: true,
        no_images: true,
        no_links: true,
        no_styles: true
        )
      markdown = Redcarpet::Markdown.new(html_renderer)
      return markdown.render(text)
  end

end