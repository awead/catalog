module Rockhall::ControllerBehaviors

  # Renders the ead xml file.  This is the same file that we use for indexing the ead as well.
  def ead_xml
    file = File.join(Rails.root, Rails.configuration.rockhall_config[:ead_path], (params[:id] + ".xml"))
    if File.exists?(file)
      render :file => file 
    else
      flash[:notice] = "XML file for #{params[:id]} was not found or is unavailable"
      redirect_to root_path
    end
  end

end