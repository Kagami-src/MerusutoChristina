source 'http://ruby.taobao.org'

gem 'mini_magick'
gem 'leancloud-ruby-client'

def source url
end

def append file
  send :eval, File.open(File.expand_path(file, File.dirname(__FILE__))).read
end

append "website/Gemfile"
