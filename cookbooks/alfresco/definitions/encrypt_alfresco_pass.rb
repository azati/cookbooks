define :encrypt_alfresco_pass do
  require 'openssl'
  require 'iconv'
  i = Iconv.iconv('UTF-16LE', 'UTF-8', params[:name]).to_s
  node[:alfresco][:encrypted_password] = OpenSSL::Digest::MD4.hexdigest(i).strip
end