class GrackConstraint
  def matches?(request)
    project_name = request.env["REQUEST_PATH"][1..-1].split("/").first

    project_name =~ /\.git\z/
  end
end
