require_relative 'image_spider'

PATHS = %w(spider)

setup

PATHS.each do |path|
  Dir["unity/#{path}/**/*.unity3d"].each do |file|
    next if File.exists? file.sub(".unity3d", "")
    puts "Extract: #{file}"
    `disunity extract #{file} 2>&1`
  end
end

PATHS.each do |path|
  puts "Copy: unity/#{path}/**/*.tga to tga/#{path}/**/*.tga"
  Dir["unity/#{path}/**/*.tga"].each do |file|
    dist = file.sub("unity", "tga").sub(/\.Android\.\d+\/CAB-[^\/]+\/Texture2D\//, "/")
    dist = dist.sub("_#{$1}", "") if dist =~ /(\d+)\/(\d+)/ and $1 == $2
    FileUtils.mkdir_p File.dirname(dist)
    FileUtils.cp file, dist
  end
end

Dir["tga/**/*.tga"].each do |file|
  begin
    dist = file.gsub("tga", "png")
    basename = "/" + File.basename(dist, ".png")
    dist = dist.sub(basename * 2, basename)
    next if File.exists? dist
    puts "Convert: #{file} to #{dist}"

    FileUtils.mkdir_p File.dirname(dist)
    image = MiniMagick::Image.open(file)
    image.format("png")
    image.write(dist)
  rescue Errno::ENOENT => e
    puts e
  end
end
