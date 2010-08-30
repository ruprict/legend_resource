require 'gstore'
require 'kconv'
require 'tempfile'
require 'yaml'

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
      puts "Checking for #{bucket_name}-#{service_name}"
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
    puts "bucket exists=#{bucket_exists}"
    if (!bucket_exists)
      puts @@client.create_bucket(bucket_name)
    end
    data.format='PNG'
    tempfile = Tempfile.new("rupprytmp") do |tmp|
      tmp.binmode
      tmp.write data.to_blob.to_s
      tmp.close
    end
    puts "tempfile.size=#{tempfile.size}"
    @@client.put_object(bucket_name, service_name, :data=>data.to_blob)
  end
  
  def self.send(object_name)
    bucket_name, service_name = object_name.split(/_/,2)
    # So, Google Storage wants domain verification on buckets with dots in them
    bucket_name.gsub!(".","_")
    @@client.get_object(bucket_name, service_name)
  end
  
end
