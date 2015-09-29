require 'open-uri'
require 'json'
require_relative 'image_spider'

CRC = JSON.parse(open("http://toto.hekk.org/asset_info/android/40.json").read)["crc"]

def precheck path, range
  range.reject! do |name, crc|
    index = name[/\d+/]
    File.exists? "#{PATH}/#{path}/#{index}.png"
  end || range
end

def select_range key
  CRC.select do |name, crc|
    name =~ key
  end
end

def download range
  range.each do |name, crc|
    begin
      url = "http://images.toto-japan.hekk.org/toto_image_s3/jp_v4#{name.sub(".Android", "_#{crc}.Android")}.unity3d"
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

setup

range = select_range /unit_square/
checked_range = precheck "units/icon", range
download checked_range
convert "units/icon"
cleanup

range = select_range /unit_btn/
checked_range = precheck "units/thumbnail", range
download checked_range
convert "units/thumbnail"
cleanup

range = select_range /unit_large_[^ns]/
checked_range = precheck "units/original", range
download checked_range
convert "units/original"
cleanup

range = select_range /unit_large_ns/
checked_range = precheck "units/foreground", range
download checked_range
convert "units/foreground"
cleanup

merge "units"

range = select_range /monster_square/
checked_range = precheck "monsters/icon", range
download checked_range
convert "monsters/icon"
cleanup

range = select_range /monster_btn/
checked_range = precheck "monsters/thumbnail", range
download checked_range
convert "monsters/thumbnail"
cleanup

range = select_range /monster_large_ns/
checked_range = precheck "monsters/original", range
download checked_range
convert "monsters/original"
cleanup

merge "monsters"

# range = select_range /storyactress/
# checked_range = precheck "storyactress", range
# download checked_range
# convert "storyactress"
# cleanup

# merge "storyactress"
