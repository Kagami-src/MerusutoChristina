require 'fileutils'

FileUtils.cd 'website'

apk = 'source/data/merusuto.apk'
puts "COPY: #{apk}"
FileUtils.cp '../android/app/app-release.apk', apk

puts "Write version: #{$1} to #{apk}"
version = "#{apk}.version"
version_code = if (`aapt dump badging #{apk}` rescue "") =~ /versionCode='(\d+)'/
  $1
else
  puts "Version Code: "
  gets.chomp
end
File.open(version, "w") { |f| f.puts version_code }

puts "Git add, commit & push"
`git add #{apk}`
`git add #{version}`
`git commit -m "Deployment auto update apk #{version_code}"`
