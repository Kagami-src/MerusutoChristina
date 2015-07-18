require 'open-uri'
require_relative 'color'
require 'thread'

# I = (0..660).to_a
# I = (110000..110100).to_a
I = [110061]
J = [20,21,22,30,40,50]
# J = [nil] + (0..100).to_a

URLs = []
Result = []
THREADS = 50

I.each do |i|
  J.each do |j|
    url = "http://static.miracle.happyelements.cn/toto_image_4/unity/"
    url += "unit/unit_square_#{i}.Android"
    url += ".#{j}" if j
    url += ".unity3d"
    URLs << url
  end
end

threads = []
THREADS.times do
  thread = Thread.new do
    loop do
      url = URLs.pop
      break unless url

      begin
        filename = File.basename(url)
        next if File.exists? "tmp/unity/spider/#{filename}"
        image = open(url)
        File.open("tmp/unity/spider/#{filename}", "w") do |file|
          file.puts image.read
        end
      rescue OpenURI::HTTPError
        next
      else
        puts url
      end
    end
  end
  threads.push thread
end

threads.each do |thread|
  thread.join
end
