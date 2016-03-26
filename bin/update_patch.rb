require 'leancloud-ruby-client'
require 'date'

AV.init application_id: "ixeo5jke9wy1vvvl3lr06uqy528y1qtsmmgsiknxdbt2xalg",
        api_key: "hwud6pxjjr8s46s9vuix0o8mk0b5l8isvofomjwb5prqyyjg",
        quiet: true

Collection = {}
def read_collection key
  Collection[key] = JSON.parse(open("D:/github/MerusutoChristina/website/source/data/#{key}.json").read)
end
def write_collection key
  result = JSON.generate Collection[key]
  result[0] = "[\n"
  result[-1] = "\n]"
  result.gsub!("},", "},\n")
  open("website/source/data/#{key}.json", "w").puts result
end

read_collection "units"
read_collection "monsters"

AV::Query.new("Suggestion")
  .eq("state", 1)
  .get.each do |suggestion|
  model = suggestion["model"]
  collection = nil
  case model["klass"]
  when "Unit"
    collection = Collection["units"]
  when "Monster"
    collection = Collection["monsters"]
  else
    puts "Unknown type #{suggestion}"
    next
  end
  match = collection.select do |item|
    item["id"] == model["id"]
  end

  unless match.size == 1
    puts "Error: #{suggestion}"
    next
  end

  match = match.first

  suggestion["data"].each do |data|
    puts "#{match["name"]}, #{data["name"]} #{data["from"]} => #{data["to"]}"

    value = data["to"]
    value = if value =~ /^\d+$/
        value.to_i
      elsif value =~ /^\d*\.\d+$/
        value.to_f
      else
        value
      end

    match[data["name"]] = value
  end

  unless suggestion["contributor"].nil? || suggestion["contributor"]["nickname"].empty?
    match["contributors"] ||= []
    match["contributors"].push suggestion["contributor"]["nickname"]
    match["contributors"].uniq!
  end

  suggestion["state"] = 3
  suggestion.save
end

AV::Query.new("Suggestion")
  .eq("state", 2)
  .get.each do |suggestion|
  suggestion["state"] = 4
  suggestion.save
end

write_collection "units"
write_collection "monsters"