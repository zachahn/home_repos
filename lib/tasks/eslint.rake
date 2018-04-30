desc "Run eslint"
task :eslint do
  sh(
    "./node_modules/.bin/eslint",
    "--ext",
    "es6,js",
    "app/assets/javascripts"
  )
end
