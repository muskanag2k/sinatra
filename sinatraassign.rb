require 'sinatra'
require 'json'

class Api_Keys
  def initialize
    @generated_keys = Hash.new
    @served_keys = Hash.new
    Thread.new {check_point}
  end

  def get_all_available_keys
    @generated_keys.keys()
  end

  def get_all_served_keys
    @served_keys.keys()
  end

  def check_point
    loop do
     sleep 5
      @generated_keys.each do |key, value|
        curr_time = Time.now
        if (curr_time - value).abs > 300
          delete_key(key)
        end
      end

      @served_keys.each do |key, value|
        curr_time = Time.now
        if (curr_time - value).abs > 60
          unblock_key(key)
        end
      end
    end
  end

  def generate_keys
    key = rand(100)
    if @generated_keys.has_key?(key) == false
      @generated_keys[key] = Time.now
      key
    end
  end

  def get_key
    if @generated_keys
      key = @generated_keys.first[0]
      @generated_keys.delete(key)
      @served_keys[key] = Time.now
      "#{key} is available."
    else
      "no key is available."
    end
  end

  def unblock_key (key)
    key = key.to_i
    if @served_keys.has_key?(key)
      @served_keys.delete(key)
      @generated_keys[key] = Time.now
      key
    else
      nil
    end
  end

  def delete_key (key)
    key = key.to_i
    if @generated_keys.has_key?(key)
      @generated_keys.delete(key)
      key
    else
      nil
    end
  end

  def keep_alive (key)
    key = key.to_i
    if @generated_keys.has_key?(key)
      @generated_keys[key] = Time.now
      key
    end
  end
end

keys_obj = Api_Keys.new

post '/generate_keys' do
  key = keys_obj.generate_keys
  JSON key: key
end

get '/get_key' do
  keys_obj.get_key
end

post '/unblock_key/:key' do
  key = keys_obj.unblock_key(params[:key])
  JSON key: key
end

post '/delete_key/:key' do
  key = keys_obj.delete_key(params[:key])
  JSON key: key
end

post '/keep_alive/:key' do
  key = keys_obj.keep_alive(params[:key])
  JSON key: key
  puts "#{key} is refreshed...."
end

get '/get_all_available_keys' do
  keys = keys_obj.get_all_available_keys
  JSON keys: keys
end

get '/get_all_served_keys' do
  keys = keys_obj.get_all_served_keys
  JSON keys: keys
end
