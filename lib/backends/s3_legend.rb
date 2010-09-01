require 'aws/s3'
require 'yaml'
require 'tempfile'

class S3Legend
  CONFIG = YAML.load_file('amazon_s3.yml') unless defined? CONFIG
   AWS::S3::Base.establish_connection!(
      :access_key_id => CONFIG['access_key'],
      :secret_access_key => CONFIG['secret']
    )
   @@bucket = CONFIG['bucket'] 
  def self.exists?( object_name)
      puts "Bucket=#{@@bucket}"
     
      AWS::S3::S3Object.exists?(object_name,  @@bucket )

  end
  
  def self.delete(object_name)
    
    AWS::S3::S3Object.delete(object_name,@@bucket)
  end
  
  def self.write(data, object_name)
   
    data.format='PNG'
    AWS::S3::S3Object.store( object_name, data.to_blob, @@bucket , :content_type=>"image/png")
  end
  
  def self.send(object_name)
  	t = Tempfile.new("tmp_path")
  	t.binmode
  	t.write AWS::S3::S3Object.find(object_name, @@bucket).value
    t.rewind
    
    puts "path=#{t.path}"
    t.path
  end
  
end
