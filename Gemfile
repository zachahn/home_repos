source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "rails", "~> 5.2.0"
gem "pg", "~> 0.18"
gem "puma", "~> 3.7"
gem "sass-rails", "~> 5.0"
gem "sprockets-es6"
gem "uglifier", ">= 1.3.0"
gem "turbolinks", "~> 5"
gem "jquery-rails"
gem "jbuilder", "~> 2.5"
gem "bootsnap", require: false
gem "bcrypt", "~> 3.1.7"
gem "pry-rails"
gem "rugged"
gem "proc_party"
gem "bourbon"
gem "neat", github: "thoughtbot/neat" # 2.1 contains a deprecation error
gem "rouge"
gem "scenic"
gem "grack", github: "zachahn/grack", branch: "customizeable_auth"
gem "commonmarker"
gem "delayed_job_active_record"
gem "dotenv-rails"

group :development, :test do
  gem "pry-byebug"
  gem "capybara", "~> 2.13"
  gem "selenium-webdriver"
  gem "factory_bot_rails"
end

group :development do
  gem "rubocop", require: false
  gem "the_bath_of_zahn", "~> 0.0.5"
  gem "who_am_i", github: "zachahn/who_am_i"
end
