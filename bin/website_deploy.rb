require "fileutils"
require_relative "color"

def say command, comment
  puts command.green + "\t" + comment
end

def run command, ignore = false
  say "RUN", command
  ret = system command
  unless ret || ignore
    puts "ERROR".red
    exit -1
  end
end

FileUtils.cd "website"

if File.exists? "source" and !ARGV.include?("-nb")
  run "middleman build"
  run "cd build && git add ."
end

run "cd build && git pull origin gh-pages"

say "VERIFY", "build/data/*.json"
require "json"
require "open-uri"
jsons = Dir["build/data/*.json"]
jsons.each do |json|
  begin
    JSON.parse open(json).read
  rescue Exception => e
    puts "ERROR".red + "\t#{e.message}"
    exit -1
  end
end

say "DIGEST", "build/data/*.json"
require "digest"
jsons = Dir["build/data/*.json"]
jsons.each do |json|
  sha = Digest::SHA2.file(json).hexdigest
  File.open "#{json}.version", "w" do |f| f.puts sha end
end

run "cd build && git add data"
run "cd build && git status"
run "cd build && git commit -m 'Deployment auto commit #{Time.now}'"
run "cd build && git push origin gh-pages"
run "cd build && git push gitcafe gh-pages"
run "cd build && git push coding gh-pages"
