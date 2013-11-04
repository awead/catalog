module Rockhall::ControllerBehaviors

  # Renders the ead xml file.  This is the same file that we use for indexing the ead as well.
  def ead_xml
    file = File.join(Rails.root, Rails.configuration.rockhall_config[:ead_path], (params[:id].gsub!(/-/,".") + "-ead.xml"))
    if File.exists?(file)
      render :file => file 
    else
      flash[:notice] = "XML file for #{params[:id]} was not found or is unavailable"
      redirect_to root_path
    end
  end

  def redirect_to_front_page
    unless !params[:q].blank? or !params[:f].blank? or !params[:search_field].blank?
      redirect_to root_path
    end
  end

end