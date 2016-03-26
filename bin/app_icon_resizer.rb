require 'mini_magick'

# file = "tmp/1024.png"
file = "tmp/1024-r.png"

# %w(512 180 120 152 76).each do |w|
%w(192 96 72 48).each do |w|
  image = MiniMagick::Image.open(file)
  image.resize("#{w}x#{w}")
  image.write("tmp/#{w}.png")
end
