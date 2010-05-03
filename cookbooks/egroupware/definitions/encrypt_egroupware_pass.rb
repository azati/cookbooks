define :encrypt_egroupware_pass do
  require 'digest/md5'
  node[:egroupware][:encrypted_password] = Digest::MD5.hexdigest(params[:name]).strip
end