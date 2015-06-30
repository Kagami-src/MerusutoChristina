require 'mini_magick'
require 'chunky_png'

`mkdir -p tmp/png/storyactress-splited/`
`mkdir -p tmp/png/storyactress-splited\\ 2/`

def opaque? file
  image = ChunkyPNG::Image.from_file(file)
  image.height.times do |y|
    image.width.times do |x|
      return true unless ChunkyPNG::Color.a(image[x, y]) == 0
    end
  end
  return false
end

files = Dir["tmp/png/storyactress/*.png"]

files.each do |file|
  filename = File.basename(file)
  print "\rSplit: #{filename}    "

  (0..1).each do |x|
    (0..5).each do |y|
      image = MiniMagick::Image.open(file)
      image.crop("150x150+#{x*153+702}+#{y*153}")
      image.write("tmp/png/storyactress-splited/#{File.basename(file, ".*")}-#{x}#{y}.png")
    end
  end

  (0..3).each do |x|
    image = MiniMagick::Image.open(file)
    image.crop("150x150+#{x*153}+790")
    image.write("tmp/png/storyactress-splited/#{File.basename(file, ".*")}-3#{x}.png")
  end

  image = MiniMagick::Image.open(file)
  image.crop("700x790+0+0")
  image.write("tmp/png/storyactress-splited\\ 2/#{File.basename(file, ".*")}.png")
end

Dir["tmp/png/storyactress-splited/*.png"].each do |file|
  `rm -f #{file}` unless opaque?(file)
end
