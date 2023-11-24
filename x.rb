def inject_code(file_path, code)
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
      file.write(code)

      puts('Code injected successfully.')
    end
  end
end

def find_the_secret(file_path)
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

      match = binary_data[index..].match(/[A-Za-z0-9+\/]+(?===)/)
      if match.nil?
        puts 'Pattern not found after the magic number.'
      else
        matched_string = match[0]
        puts "Pattern found after the magic number."
        ciphertext = matched_string
        ciphertext += '=='
        puts "Ciphertext: #{ciphertext}"
      end
    end
  end
end

file_path = './tester.jpg'
code = 'ZTg0Y2RhNGIzYmU3NDQ2NmU3YzQ3MWU5OGE1YWMwYjZiOTczMmRhMDEyMjZlNGU0M2RjNzNhN2YwNGU5MTIzNDkyYWIwOTIzZjI4YjhjYjljZTE0NWM1ZmQyOTcyYjJiODQ0YmFjNDdlNWMxMDAzZjg0YmMxNGUzYTRkMjk2ZTIwZWE4MzljZDI5MDI2Nzc4ZDI3Y2U3YjZiMDhhMDA5Mg=='
# inject_code(file_path, code)
find_the_secret(file_path)
