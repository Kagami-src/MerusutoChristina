if __FILE__ == $0
  system "whenever -f #{__FILE__} #{ARGV.join(" ")}"
else
  every :hour do
    root_path = File.expand_path("../..", __FILE__)
    set :job_template, "bash -l -c 'cd #{root_path} && :job >> tmp/automation.log 2>&1'"
    command "date"
    command "ruby bin/website_sync.rb"
    command "ruby bin/update_patch.rb"
    command "ruby bin/website_deploy.rb"
  end
end
