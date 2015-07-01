require 'open-uri'
require 'json'
require './bin/image_spider'

def download key
  json = JSON.parse open("http://toto.hekk.org/asset_info/android/40.json").read
  json["crc"].each do |name, crc|
    next unless name =~ key
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

# download /unit_square/
# convert "units/icon"
# cleanup

# download /unit_btn/
# convert "units/thumbnail"
# cleanup

# download /unit_large_[^ns]/
download /unit_large_658/
convert "units/original"
# cleanup

# download /unit_large_ns/
# convert "units/foreground"
# cleanup

# merge "units"

# download /monster_square/
# convert "monsters/icon"
# cleanup

# download /monster_btn/
# convert "monsters/thumbnail"
# cleanup

# download /monster_large_ns/
# convert "monsters/original"
# cleanup

# merge "monsters"

# download /storyactress/
# convert "storyactress"
# cleanup

# merge "storyactress"
