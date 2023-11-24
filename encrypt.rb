require 'openssl'
require 'base64'
require 'dotenv/load'

original_key = ENV['KEY']
desired_length = 32
file_path = './tester.jpg'

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

def inject_code(file_path, ciphertext)
  if File.exist?(file_path)
    puts "File '#{file_path}' found and being read."
  else
    puts "File '#{file_path}' not found."
    return
  end

  magic_number = 'FFD8FF'
  magic_number_bin = [magic_number].pack('H*')

  File.open(file_path, 'r+b') do |file|
    binary_data = file.read
    index = binary_data.index(magic_number_bin)

    if index.nil?
      puts 'Magic number not found in the file.'
    else
      puts "Magic number found at index #{index} in the file."

      file.seek(index + magic_number_bin.bytesize)
      # test add @@ at the end of the ciphertext
      file.write(ciphertext)

      puts('Code injected successfully.')
    end
  end
end

print 'New message: '
plaintext = gets.chomp
ciphertext = encrypt(plaintext, key, iv)
# Encryption
inject_code(file_path, ciphertext)
