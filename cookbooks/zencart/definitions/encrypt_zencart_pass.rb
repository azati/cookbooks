define :encrypt_zencart_pass do
  require 'digest/md5'
  chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
  tmp = ""
  1.upto(10) { |i| tmp << chars[rand(chars.size-1)] }
  salt = Digest::MD5.hexdigest(tmp)[0,2]
  node[:zencart][:encrypted_password] = (Digest::MD5.hexdigest(salt + params[:name]) + ":" + salt).strip
end