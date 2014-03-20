module CarouselHelper

  def render_slides
      render :partial => "shared/carousel_item"
  end

  def carousel_item_class file
    if file.match(/^01/)
      "item active"
    else
      "item"
    end
  end

  def carousel_slides
    Dir.glob(File.join(Rails.root.to_s, "app/assets/images/slides/*.jpg"))
  end

  def number_of_slides
    Dir.glob(File.join(Rails.root.to_s, "app/assets/images/slides/*.jpg")).count - 1
  end

  def slide_link file
    if file.match(/[ARC|RG]/)
      catalog_path file_name_to_path(file)
    else
      "http://library.rockhall.com/"+file_name_to_path(file)
    end
  end

  private

  def file_name_to_path file
    File.basename(file, ".jpg").split("_").drop(1).join("/")
  end

end
