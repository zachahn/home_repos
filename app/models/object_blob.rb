class ObjectBlob
  def initialize(project:, committish:, path:)
    @project = project
    @committish = committish
    @path = path
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

  def commit
    @commit ||= DigCommitFromReference.new(repo).call(@committish)
  end

  def object
    @object ||= DigObjectFromCommit.new(repo, commit).call(@path)
  end

  def repo
    @repo ||= @project.repo
  end

  def most_likely_lexer
    Rouge::Lexer.guesses(filename: @path, source: content).first
  end
end
