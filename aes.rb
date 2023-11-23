require 'openssl'
require 'base64'
require 'dotenv/load'

def encrypt(plaintext, key, iv)
  cipher = OpenSSL::Cipher.new('AES-256-CBC')
  cipher.encrypt
  cipher.key = key
  cipher.iv = iv

  encrypted = cipher.update(plaintext) + cipher.final
  encrypted.unpack1('H*')
end


def duplicate_and_cut(original_key, desired_length)
  duplicated_key = original_key.chars.cycle.take(desired_length).join
  duplicated_key.slice(0, desired_length)
end

original_key = ENV['KEY']
desired_length = 32 # Length of the target key

target_key = duplicate_and_cut(original_key, desired_length)
puts target_key

plaintext = 'spend outside coin quarter drink provide water stove spare device novel sweet'

key = target_key
#puts "Key: #{key.unpack1('H*')}"
iv = OpenSSL::Cipher.new('AES-256-CBC').random_iv

encrypted = encrypt(plaintext, key, iv)
encoded = Base64.strict_encode64(encrypted)
puts "Encrypted: #{encoded}"
