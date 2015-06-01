require 'leancloud-ruby-client'
require_relative 'color'

AV.init application_id: "ixeo5jke9wy1vvvl3lr06uqy528y1qtsmmgsiknxdbt2xalg",
        api_key: "hwud6pxjjr8s46s9vuix0o8mk0b5l8isvofomjwb5prqyyjg",
        quiet: true

DIFF = <<-EOS
EOS

DIFF.each_line do |line|
  if line =~ /(\d+) ([^:]+): (\S+) ([\.\d]+) -> ([\.\d]+)/
    suggestion = AV::Object.new("Suggestion")
    suggestion["model"] = {klass: "Unit", id: $1.to_i, name: $2}
    suggestion["data"] = [{name: $3, from: $4.to_f, to: $5.to_f}]
    suggestion.save
  else
    puts line.red
  end
end
