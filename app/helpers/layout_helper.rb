module LayoutHelper
  def layout
    layout_wrapper do
      layout_12 do
        yield
      end
    end
  end

  def layout_wrapper
    tag.div(class: "layout") do
      yield
    end
  end

  def layout_12
    tag.div(class: "layout__12") do
      yield
    end
  end
end
