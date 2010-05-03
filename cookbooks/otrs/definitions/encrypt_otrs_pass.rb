define :encrypt_otrs_pass do
  chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
  salt = ""
  1.upto(10) { |i| salt << chars[rand(chars.size-1)] }
  node[:otrs][:encrypted_password] = params[:name].crypt(salt).strip
end
