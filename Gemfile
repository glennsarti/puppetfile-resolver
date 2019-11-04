source ENV['GEM_SOURCE'] || 'https://rubygems.org'

# Specify your gem's dependencies in pdk.gemspec
gemspec

group :development do
  gem 'rake', '>= 10.4', :require => false
  gem 'rspec', '>= 3.2', :require => false

  if RUBY_VERSION =~ /^2\.1\./
    gem "rubocop", "<= 0.57.2", :require => false, :platforms => [:ruby, :x64_mingw]
  else
    gem "rubocop", ">= 0.60.0", :require => false, :platforms => [:ruby, :x64_mingw]
  end
end

# Evaluate Gemfile.local and ~/.gemfile if they exist
extra_gemfiles = [
  "#{__FILE__}.local",
  File.join(Dir.home, '.gemfile'),
]

extra_gemfiles.each do |gemfile|
  if File.file?(gemfile) && File.readable?(gemfile)
    eval(File.read(gemfile), binding)
  end
end
# vim: syntax=ruby
