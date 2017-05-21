Gem::Specification.new do |s|
  s.name = 'github-calendar'
  s.version = '1.3.0'
  s.required_ruby_version = '>= 2.3.0'
  s.authors = ['Eli Foster']
  s.description = 'A library that allows for quick HTML parsing of GitHub user profile contribution calendars. ' \
                  'This project is part of the GitHub User Language Statistics project.'
  s.email = 'elifosterwy@gmail.com'
  s.files = [
    'lib/github/calendar.rb',
    'lib/github/exceptions.rb',
    'CHANGELOG.md'
  ]
  s.homepage = 'https://github.com/ghuls-apps/github-calendar-api'
  s.summary = 'Getting GitHub user profile calendar data through HTML parsing.'
  s.license = 'MIT'
  s.add_runtime_dependency('nokogiri', '~> 1.7')
  s.add_runtime_dependency('string-utility', '~> 3.0')
  s.add_runtime_dependency('curb', '~> 0.9')
end
