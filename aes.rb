require 'openssl'
require 'base64'

def encrypt(plaintext, key, iv)
  cipher = OpenSSL::Cipher.new('AES-256-CBC')
  cipher.encrypt
  cipher.key = key
  cipher.iv = iv

  encrypted = cipher.update(plaintext) + cipher.final
  encrypted.unpack1('H*')
end

plaintext = 'spend outside coin quarter drink provide water stove spare device novel sweet'
key = OpenSSL::Random.random_bytes(32)
puts "Key: #{key.unpack1('H*')}"
iv = OpenSSL::Cipher.new('AES-256-CBC').random_iv

encrypted = encrypt(plaintext, key, iv)
encoded = Base64.strict_encode64(encrypted)
puts "Encrypted: #{encoded}"
