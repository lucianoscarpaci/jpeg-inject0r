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

def encrypt(plaintext, key, iv)
  cipher = OpenSSL::Cipher.new('AES-256-CBC')
  cipher.encrypt
  cipher.key = key
  cipher.iv = iv
  encrypted = cipher.update(plaintext) + cipher.final
  encrypted.unpack1('H*')
  encoded = Base64.strict_encode64(encrypted)
end

def decrypt(ciphertext, key, iv)
  cipher = OpenSSL::Cipher.new('AES-256-CBC')
  cipher.decrypt
  cipher.key = key
  cipher.iv = iv
  decoded = Base64.strict_decode64(ciphertext)
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
