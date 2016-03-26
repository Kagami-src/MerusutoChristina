require 'leancloud-ruby-client'
require_relative 'color'

AV.init application_id: "ixeo5jke9wy1vvvl3lr06uqy528y1qtsmmgsiknxdbt2xalg",
        api_key: "hwud6pxjjr8s46s9vuix0o8mk0b5l8isvofomjwb5prqyyjg",
        quiet: true

DIFF = <<-EOS
654 [双耀の射手] リファー: fire 暂缺 -> 0.92
654 [双耀の射手] リファー: aqua 暂缺 -> 0.92
654 [双耀の射手] リファー: wind 暂缺 -> 0.92
654 [双耀の射手] リファー: light 暂缺 -> 1.0
654 [双耀の射手] リファー: dark 暂缺 -> 1.3
655 [神教を説く者] アブサン: fire 暂缺 -> 0.77
655 [神教を説く者] アブサン: aqua 暂缺 -> 1.3
655 [神教を説く者] アブサン: wind 暂缺 -> 1.0
655 [神教を説く者] アブサン: light 暂缺 -> 1.0
655 [神教を説く者] アブサン: dark 暂缺 -> 1.0
662 [賭遊戯の女帝] フラヴィア: hits 暂缺 -> 3
EOS

def format value
  if value =~ /^\d+\.\d+$/
    value.to_f
  elsif value =~ /^\d+$/
    value.to_i
  else
    nil
  end
end

DIFF.each_line do |line|
  if line =~ /(\d+) ([^:]+): (\S+) (\S*) -> ([\.\d]+)/
    suggestion = AV::Object.new("Suggestion")
    suggestion["model"] = {klass: "Unit", id: $1.to_i, name: $2}
    suggestion["data"] = [{name: $3, from: format($4), to: format($5)}]
    suggestion.save
  else
    print line.red
  end
end
