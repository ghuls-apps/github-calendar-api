Gem::Specification.new do |s|
  s.name = 'github-calendar'
  s.version = '1.0.0'
  s.require_ruby_version = '>= 2.2.3'
  s.authors = ['Eli Foster']
  s.description = 'A library that allows for quick HTML parsing of GitHub ' \
                  'user profile contribution calendars. This project is ' \
                  'part of the GitHub User Language Statistics project.'
  s.email = 'elifosterwy@gmail.com'
  s.files = [
    'lib/github/calendar.rb',
    'CHANGELOG.md'
  ]
  s.homepage = 'https://github.com/ghuls-apps/github-calendar-api'
  s.summary = 'Getting GitHub user profile calendar data through HTML parsing.'
  s.add_runtime_dependency('nokogiri', '>= 1.6.6.2')
  s.add_runtime_dependency('string-utility', '>= 2.5.0')
end
