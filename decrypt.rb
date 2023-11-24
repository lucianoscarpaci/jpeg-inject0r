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

def decrypt(ciphertext, key, iv)
  cipher = OpenSSL::Cipher.new('AES-256-CBC')
  cipher.decrypt
  cipher.key = key
  cipher.iv = iv
  decoded = Base64.strict_decode64(ciphertext)
  decrypted = cipher.update(decoded) + cipher.final
end

def find_the_secret(file_path, key, iv)
  if File.exist?(file_path)
    puts "File '#{file_path}' found and being read."
  else
    puts "File '#{file_path}' not found."
    return
  end

  magic_number = 'FFD8FF' # Hex representation of the magic number
  magic_number_bin = [magic_number].pack('H*') # Convert hex to binary

  File.open(file_path, 'r+b') do |file|
    binary_data = file.read
    index = binary_data.index(magic_number_bin)

    if index.nil?
      puts 'Magic number not found in the file.'
    else
      puts "Magic number found at index #{index} in the file."

      file.seek(index + magic_number_bin.bytesize)
      code = file.read
      # old match pattern
      # add more = signs to match the pattern
      match = binary_data[index..].match(/[A-Za-z0-9+\/]+(?==)/)
      # invalid match pattern
      #match = binary_data[index..].match(/[A-Za-z0-9+\/]{4}*(?:[A-Za-z0-9+\/]{2}==|[A-Za-z0-9+\/]{3}=)?/) 
      if match.nil?
        puts 'Pattern not found after the magic number.'
      else
        matched_string = match[0]
        puts 'Pattern found after the magic number.'
        ciphertext = matched_string
        ciphertext += '='
        puts "Ciphertext: #{ciphertext}"
        decrypted_text = decrypt(ciphertext, key, iv)
        puts "Decrypted Text: #{decrypted_text}"
      end
    end
  end
end

find_the_secret(file_path, key, iv)
