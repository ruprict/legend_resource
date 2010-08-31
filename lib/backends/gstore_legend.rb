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
    
  def self.exists?( object_name)
     
      bucket_name, service_name = object_name.split(/_/,2)
      # So, Google Storage wants domain verification on buckets with dots in them
      bucket_name.gsub!(".","_")
      @@client.get_object(bucket_name, service_name).match(/does not exist/).nil?

  end
  
  def self.delete(object_name)
    bucket_name, service_name = object_name.split(/_/,2)
    # So, Google Storage wants domain verification on buckets with dots in them
    bucket_name.gsub!(".","_")
    @@client.delete_object(bucket_name,service_name)
  end
  
  def self.write(data, object_name)
    bucket_name, service_name = object_name.split(/_/,2)
    # So, Google Storage wants domain verification on buckets with dots in them
    bucket_name.gsub!(".","_")
    bucket_exists = @@client.get_bucket(bucket_name).match(/does not exist/).nil?
    if (!bucket_exists)
      puts @@client.create_bucket(bucket_name)
    end
    data.format='PNG'
   
    @@client.put_object(bucket_name, service_name, :data=>data.to_blob,:headers=>{:content_length=>data.to_blob.length,:content_type=>"image/png"})
  end
  
  def self.send(object_name)
    bucket_name, service_name = object_name.split(/_/,2)
    # So, Google Storage wants domain verification on buckets with dots in them
    bucket_name.gsub!(".","_")

    @@client.get_object(bucket_name, service_name)
  end
  
end
