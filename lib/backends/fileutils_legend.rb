class File
  def self.write(data,filename)
    data.write(filename)
  end
  
  def self.send(legend_image_filename)
    File.read(legend_image_filename)
  end
  
  
end
