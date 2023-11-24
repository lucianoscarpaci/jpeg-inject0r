require 'openssl'
require 'base64'
require 'dotenv/load'

original_key = ENV['KEY']
desired_length = 32

def duplicate_and_cut(original_key, desired_length)
  duplicated_key = original_key.chars.cycle.take(desired_length).join
  duplicated_key.slice(0, desired_length)
end

key = duplicate_and_cut(original_key, desired_length)
iv = OpenSSL::Cipher.new('AES-256-CBC').random_iv

def pad_encoded(encoded)
  if encoded[-1] == '='
    encoded += '=' unless encoded[-2] == '='
  else
    encoded += '=='
  end
  encoded
end

def unpad_decoded(decoded)
  decoded = decoded.chomp('=')
  decoded = decoded.chomp('=') unless decoded[-1] == '='
  decoded
end

def encrypt(plaintext, key, iv)
  cipher = OpenSSL::Cipher.new('AES-256-CBC')
  cipher.encrypt
  cipher.key = key
  cipher.iv = iv
  encrypted = cipher.update(plaintext) + cipher.final
  encrypted.unpack1('H*')
  encoded = Base64.strict_encode64(encrypted)
  encoded = pad_encoded(encoded)
end

def decrypt(ciphertext, key, iv)
 cipher = OpenSSL::Cipher.new('AES-256-CBC')
 cipher.decrypt
 cipher.key = key
 cipher.iv = iv
 decoded = Base64.strict_decode64(unpad_decoded(ciphertext))
 decrypted = cipher.update(decoded) + cipher.final
end

print 'New message: '
plaintext = gets.chomp

# Encryption
ciphertext = encrypt(plaintext, key, iv)
puts "Ciphertext: #{ciphertext}"

# Decryption
decrypted_text = decrypt(ciphertext, key, iv)
puts "Decrypted Text: #{decrypted_text}"
