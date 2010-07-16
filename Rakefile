task :gem do
  sh "gem build jaunte.gemspec"
end

task :clean do
  sh "rm -rf #{ENV['HOME']}/.jaunte"
  sh "rm -rf jaunte-*.gem"
end

task :reinstall => [:clean, :gem] do
  sh "gem uninstall jaunte" rescue nil
  sh "gem install jaunte-*.gem"
end