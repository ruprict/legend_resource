class LegendsController < ApplicationController
  def show
    url, filename = get_url_and_filename
    if (!File.exists?(filename))
    
      mapserver = ArcServer::MapServer.new(url)
      logger.info(url)
      img = mapserver.get_legend_image
      img.write(filename)
    end
    send_file(filename,:type=>"image/png")
  end

  def destroy
    url, filename = get_url_and_filename
    if (File.exists?(filename))
      File.delete(filename)
      render :nothing=>true, :status=>:ok
    else
      render :nothing=>true, :status=>:no_content
    end
  end
  
  private
  def get_url_and_filename
    if params[:server].match(/\//).nil?
      server = params[:server]
      folder=nil
    else
      
      server, folder = params[:server].split("/")
      folder = folder + "/"
    end
    url = "http://#{server}/ArcGIS/services/#{folder}#{params[:mapservice]}/MapServer"
    
    filename="public/images/#{server}_#{params[:mapservice]}.png"
    [url,filename]
  end

end
