require_relative 'image_spider'

(Dir["tmp/unity/common/**/*.unity3d"] +
  Dir["tmp/unity/common_icon/**/*.unity3d"] +
  Dir["tmp/unity/task/**/*.unity3d"] +
  Dir["tmp/unity/swf/**/*.unity3d"]).each do |file|
  puts "Extract: #{file}"
  `disunity extract #{file} 2>&1`
end

puts "Copy: tmp/unity/**/*.tga to tmp/tga/**/*.tga"
Dir["tmp/unity/**/*.tga"].each do |file|
  dist = file.sub("unity", "tga").sub(/\.Android\/CAB-[^\/]+\/Texture2D\//, "/")
  FileUtils.mkdir_p File.dirname(dist)
  FileUtils.cp file, dist
end

Dir["tmp/tga/**/*.tga"].each do |file|
  begin
    dist = file.gsub("tga", "png")
    basename = "/" + File.basename(dist, ".png")
    dist = dist.sub(basename * 2, basename)
    puts "Convert: #{file} to #{dist}"

    FileUtils.mkdir_p File.dirname(dist)
    image = MiniMagick::Image.open(file)
    image.format("png")
    image.write(dist)
  rescue Errno::ENOENT => e
    puts e
  end
end
