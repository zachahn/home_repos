class CommonMarkerRouge < CommonMarker::HtmlRenderer
  def code_block(node)
    language = node.fence_info
    code = node.string_content

    lexer = Rouge::Lexer.find_fancy(language, code) || Rouge::Lexers::PlainText

    formatter =
      Rouge::Formatters::HTMLLegacy.new(css_class: "highlight")

    output = formatter.format(lexer.lex(code))

    block do
      out(output)
    end
  end
end
