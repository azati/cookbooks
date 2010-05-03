define :encrypt_joomla_pass do
  require 'digest/md5'
  chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
  salt = ""
  1.upto(32) { |i| salt << chars[rand(chars.size-1)] }
  md5 = Digest::MD5.hexdigest(params[:name] + salt)
  node[:joomla][:encrypted_password] = (md5 + ":" + salt).strip
end