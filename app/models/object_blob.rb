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
    formatter = Rouge::Formatters::HTML.new
    formatter.format(lexer.new.lex(content))
  end

  private

  def most_likely_lexer
    Rouge::Lexer.guesses(filename: @path, source: content).first
  end
end
