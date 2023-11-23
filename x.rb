def find_magic_number(file_path)
  magic_number = "FFD8FF" # Hex representation of the magic number
  magic_number_bin = [magic_number].pack('H*') # Convert hex to binary

  File.open(file_path, 'rb') do |file|
    binary_data = file.read
    index = binary_data.index(magic_number_bin)

    if index.nil?
      puts 'Magic number not found in the file.'
    else
      puts "Magic number found at index #{index} in the file."
    end
  end
end

file_path = './tester.jpg'
find_magic_number(file_path)