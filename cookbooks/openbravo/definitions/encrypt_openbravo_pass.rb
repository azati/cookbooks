define :encrypt_openbravo_pass do
  require "base64"
  require "sha1"
  s = SHA1.new
  node[:openbravo][:encrypted_password] = Base64.encode64(s.update(params[:name]).digest).strip
end