require 'gstore'
require 'kconv'
require 'yaml'
require 'tempfile'

class GStoreLegend
   CONFIG = YAML.load_file('gstore.yml') unless defined? CONFIG
   @@client = GStore::Client.new(
      :access_key => CONFIG['access_key'],
      :secret_key => CONFIG['secret']
    )
    @@bucket = CONFIG['bucket']
  def self.exists?( object_name)
      # So, Google Storage wants domain verification on buckets with dots in them
      object_name.gsub!(".","_")
      @@client.get_object(@@bucket, object_name).match(/does not exist/).nil?
  end
  
  def self.delete(object_name)
    object_name.gsub!(".","_")
    @@client.delete_object(@@bucket,object_name)
  end
  
  def self.write(data, object_name)
    # So, Google Storage wants domain verification on buckets with dots in them
    @@bucket.gsub!(".","_")
    data.format="PNG"
    @@client.put_object(@@bucket, object_name, :data=>data.to_blob,:headers=>{:content_length=>data.to_blob.length,:content_type=>"image/png"})
  end
  
  def self.send(object_name)
    # So, Google Storage wants domain verification on buckets with dots in them
    @@bucket.gsub!(".","_")
    t = Tempfile.new("tmp_path")
  	t.binmode
  	t.write @@client.get_object(@@bucket, object_name)
    t.rewind
    t.close
    t.path
  end
  
end
