class ObjectBlob
  def initialize(project:, committish:, path:)
    @project = project
    @committish = committish
    @path = path
    @index_interface =
      ObjectIndexInterface.new(
        project: @project,
        committish: @committish,
        path: @path
      )
  end

  delegate :basename, to: :@index_interface
  delegate :path_params, to: :@index_interface
  delegate :object, to: :@index_interface

  def icon
    "file"
  end

  def content
    object.content
  end

  def lexer
    most_likely_lexer || Rouge::Lexers::PlainText
  end

  def html_content
    if lexer == Rouge::Lexers::Markdown
      content_markdown
    else
      content_syntax_highlight
    end
  end

  private

  def content_markdown
    doc = CommonMarker.render_doc(content)
    renderer = CommonMarkerRouge.new

    %(<div class="longform">).html_safe +
      renderer.render(doc).html_safe +
      "</div>".html_safe
  end

  def content_syntax_highlight
    html_formatter = Rouge::Formatters::HTML.new
    formatter = Rouge::Formatters::HTMLTable.new(html_formatter)

    %(<pre class="highlight">).html_safe +
      formatter.format(lexer.new.lex(content)).html_safe +
      "</pre>".html_safe
  end

  def most_likely_lexer
    Rouge::Lexer.guesses(filename: @path, source: content).first
  end
end
