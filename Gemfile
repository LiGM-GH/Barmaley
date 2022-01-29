source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rubyXL', '~> 3.4', '>= 3.4.20'
gem 'rake'
gem 'commander'
