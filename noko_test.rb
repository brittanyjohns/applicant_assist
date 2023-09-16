require "nokogiri"

def get_file_as_string(filename)
  data = ""
  f = File.open(filename, "r")
  f.each_line do |line|
    data += line
  end
  return data
end

filename = "examples/with_attachment.eml"

doc = get_file_as_string(filename)
parsed_data = Nokogiri::HTML(doc)
# puts parsed_data.title

parsed_data.search('\n').each do |link|
  puts link.content
end