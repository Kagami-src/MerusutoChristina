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

FileUtils.mkdir_p "website"
FileUtils.cd "website"

if File.exists? "build"
  run "cd build && git pull origin gh-pages"
else
  run "git clone -b gh-pages git@github.com:bbtfr/MerusutoChristina.git build"
  run "cd build && git remote add gitcafe git@gitcafe.com:merusuto/merusuto.git"
  run "cd build && git remote add coding git@git.coding.net:bbtfr/merusuto.git"
end

if File.exists? "source"
  run "cp build/data/*.json source/data/"

  say "RUN", "cp build/data/**/*.png source/data/"
  %w(units monsters).each do |key1|
    %w(icon original thumbnail).each do |key2|
      system "cp -n build/data/#{key1}/#{key2}/*.png source/data/#{key1}/#{key2}/"
    end
  end
  run "git status"
end
