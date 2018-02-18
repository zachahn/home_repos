module SvgIconHelper
  def feather_tag(name)
    image_tag("feather/#{name}.svg", class: "inline-icon")
  end
end
