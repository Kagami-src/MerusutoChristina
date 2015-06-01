require 'open-uri'
require 'fileutils'
require 'mini_magick'
require_relative 'color'

BASEURLJP = "http://dbcj6kgtik9tl.cloudfront.net/toto_image_s3/jp_v2"
BASEURLCN = "http://static.miracle.happyelements.cn/toto_image_2/unity"

def download baseurl, range
  range.each do |index|
    begin
      url = baseurl.sub("#INDEX#", index.to_s)
      filename = File.basename(url)
      print "\rDownload: #{filename}   "
      image = open(url)
      File.open("unity3d.unity3d", "w") do |file|
        file.puts image.read
      end

      print "\rExtract: #{filename}    "
      `disunity extract unity3d.unity3d 2>&1`
    rescue OpenURI::HTTPError => e
      puts "\rError: #{filename}, #{e}"
    end
  end
end

def convert path
  FileUtils.mkdir_p "tga"
  FileUtils.mkdir_p "png/#{path}"
  FileUtils.mv Dir["unity3d/**/*.tga"], "tga"

  Dir["tga/*.tga"].each do |file|
    begin
      filename = File.basename(file)
      print "\rConvert: #{filename}    "
      image = MiniMagick::Image.open(file)
      image.format("png")
      image.write("png/#{path}/#{File.basename(file, ".*")}.png")
    rescue
      puts "\rError: #{filename}, #{e}"
    end
  end
end

def cleanup
  FileUtils.rm_rf "unity3d.unity3d"
  FileUtils.rm_rf "unity3d"
  FileUtils.rm_rf "tga"
end

def setup
  FileUtils.mkdir_p "tmp"
  FileUtils.cd "tmp"
  FileUtils.rm_rf "tga"
  cleanup
end

def merge key
  puts "\n"
  Dir["png/#{key}s/**/*.png"].each do |file|
    if File.exists? "../website/source"
      path = file.sub("png", "../website/source/data")
    else
      path = file.sub("png", "../website/build/data")
    end
    next if File.exists? path
    puts "Copy #{path}"
    FileUtils.cp file, path
  end
end

def resources key1, key2, range
  case key1
  when :jp
    baseurl = BASEURLJP
    ext = ".Android.unity3d"
  when :cn
    baseurl = BASEURLCN
    ext = ".Android.1.unity3d"
  end

  case key2
  when :unit
    download "#{baseurl}/unit/unit_btn_#INDEX##{ext}", range
    convert "units/thumbnail"
    cleanup

    download "#{baseurl}/unit/unit_large_#INDEX##{ext}", range
    convert "units/original"
    cleanup

    download "#{baseurl}/unit/unit_square_#INDEX##{ext}", range
    convert "units/icon"
    cleanup

    merge :unit
  when :monster
    download "#{baseurl}/monster/monster_btn_#INDEX##{ext}", range
    convert "monsters/thumbnail"
    cleanup

    download "#{baseurl}/monster/monster_large_ns_#INDEX##{ext}", range
    convert "monsters/original"
    cleanup

    download "#{baseurl}/monster/monster_square_#INDEX##{ext}", range
    convert "monsters/icon"
    cleanup

    merge :monster
  when :sound
    download "#{baseurl}/sound/B-#INDEX##{ext}", range
    FileUtils.mkdir_p "mp3"
    FileUtils.mv Dir["unity3d/**/*.mp3"], "mp3"
    cleanup
  when :background
    FileUtils.mkdir_p "tga"
    (1..3).each do |n|
      range.each do |index|
        download "#{baseurl}/background/background#INDEX#_#{n}#{ext}", [index]
        Dir["unity3d/**/*.tga"].each do |file|
          FileUtils.mv file, "tga/#{index}_#{n}#{File.basename(file)}"
        end
      end
    end
    FileUtils.rm_rf Dir["unity3d/**/*.tga"]
    convert "background"
    cleanup
  when :storybackground
    (1..10).each do |n|
      download "#{baseurl}/storybackground/storybackground#INDEX#_#{n}#{ext}", range
    end
    convert "storybackground"
    cleanup
  when :storyactress
    download "#{baseurl}/storyactress/storyactress#INDEX##{ext}", range
    convert "storyactress"
    cleanup
  end

end

# http://static.miracle.happyelements.cn/toto_image/unity/sound/B-37.Android.unity3d
# http://static.miracle.happyelements.cn/toto_image/unity/background/background6_3.Android.unity3d
# http://static.miracle.happyelements.cn/toto_image/unity/storybackground/storybackground51_4.Android.unity3d
# http://static.miracle.happyelements.cn/toto_image_2/unity/storyactress/storyactress20341.Android.1.unity3d

if __FILE__ == $0
  setup
  # resources :cn, :background, (100000..100010)
  # resources :cn, :storybackground, (100000..100030)
  # resources :jp, :background, (1..40)
  # resources :jp, :monster, (1..380)
  # resources :jp, :unit, (0..590)
  # resources :cn, :unit, (109999..110050)
  # resources :jp, :storyactress, (0..585)
  # resources :jp, :storyactress, (10000..10585)
  # resources :jp, :storyactress, (20000..20585)
  # resources :jp, :unit, (582..582)

  # resources :jp, :unit, (610..625)
  # resources :cn, :unit, (110050..110060)
  # resources :jp, :monster, (400..420)
  # resources :cn, :monster, (100020..100030)
  # resources :jp, :storyactress, (585..600)
  # resources :jp, :storyactress, (10117..10140)
  # resources :jp, :storyactress, (20355..20370)

  key = (ARGV.first || :unit).to_sym
  from = (ARGV[1] || 0).to_i
  to = (ARGV[2] || 0).to_i
  server = from > 100000 ? :cn : :jp
  resources server, key, (from..to)
end