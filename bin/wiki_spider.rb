require 'nokogiri'
require 'open-uri'
require 'json'
require_relative 'wiki_page_parser'
require_relative 'color'

Result = []
Collection = {}
def read_collection key
  Collection[key] = JSON.parse(open("website/source/data/#{key}s.json").read)
end
def write_collection key
  open("website/source/data/#{key}s.json", "w").puts format_json Collection[key]
end
def format_json json
  result = JSON.generate json
  result[0] = "[\n"
  result[-1] = "\n]"
  result.gsub!("},", "},\n")
end

read_collection :unit
read_collection :monster

def parse_wiki_list_page key
  case key
  when :unit
    url = 'http://xn--cckza4aydug8bd3l.gamerch.com/%E6%96%B0%E7%9D%80%E3%83%A6%E3%83%8B%E3%83%83%E3%83%88%E4%B8%80%E8%A6%A7'
  when :monster
    url = 'http://xn--cckza4aydug8bd3l.gamerch.com/%E6%96%B0%E7%9D%80%E3%83%A2%E3%83%B3%E3%82%B9%E3%82%BF%E3%83%BC%E4%B8%80%E8%A6%A7'
  end

  puts "Parse list page: #{url}"
  doc = Nokogiri::HTML(open(url))
  doc.css("#js_async_main_column_text > table tr > td:nth-child(2) a").map do |doc|
    url = "http://xn--cckza4aydug8bd3l.gamerch.com#{URI::encode doc.attr("href")}"
    json = parse_wiki_detail_page url, "暂缺", true
    match = json_match_data key, json
    next if match.size > 0

    json['name_jp'] = json['name']
    json['title_jp'] = json['title'] if key == :unit
    Result << json
  end
end

def json_match_data key, raw
  Collection[key].select do |row|
    raw['title'] == row['title_jp'] && raw['name'] == row['name_jp']
  end
end

def update_wiki_data key, range
  Collection[key][range].each do |raw|
    begin
      # next unless raw.values.include?('暂缺')
      next unless raw['name_jp']
      url = wiki_match_url raw
      json = parse_wiki_detail_page url, "暂缺", true
      changed = false
      json.each do |key, value|
        next if raw[key] == value || %w(id name title country obtain remark).include?(key)
        next if value == "暂缺"
        puts "#{raw['id']} #{raw['title']} #{raw['name']}: #{key} #{raw[key]} -> #{value}".green
        changed = true
        raw[key] = value
      end
      Result << raw if changed
    rescue Interrupt => e
      exit
    rescue Exception => e
      puts e.message.red
    end
  end
end

def wiki_match_url raw
  title = raw['title_jp'].sub('[', '「').sub(']', '」') + raw['name_jp'] rescue raw['name_jp']
  "http://xn--cckza4aydug8bd3l.gamerch.com/#{URI::encode title}"
end

if __FILE__ == $0
  key = (ARGV.first || :unit).to_sym

  if key == :update
    key = (ARGV[1] || :unit).to_sym
    from = (ARGV[2] || 0).to_i
    to = (ARGV[3] || -1).to_i
    update_wiki_data key, (from..to)
  else
    parse_wiki_list_page key
  end

  puts format_json Result if Result
end
