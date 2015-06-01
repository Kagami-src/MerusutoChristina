require 'json'

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

Collection[:unit].each do |raw|
  gacha = []
  { "骑士契约书（钻石）" => 1,
    "勇者契约书（金币2W）" => 2,
    "游侠契约书（金币2K）" => 3 }.each do |key, index|
    gacha << index if raw["obtain"] && raw["obtain"].include?(key)
  end
  raw["gacha"] = gacha if gacha.any?
end

write_collection :unit
