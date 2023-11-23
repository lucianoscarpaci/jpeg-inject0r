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

file_path = './tester.jpg'
code = 'spend outside coin quarter drink provide water stove spare device novel sweet'
inject_code(file_path, code)
