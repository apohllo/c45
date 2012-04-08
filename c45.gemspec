$:.unshift "lib"
require 'c45/version'

Gem::Specification.new do |s|
  s.name = "c45"
  s.version = C45::VERSION.to_s
  s.required_ruby_version = '>= 1.9.2'
  s.date = "#{Time.now.strftime("%Y-%m-%d")}"
  s.summary = "Ruby tools for c4.5 decission trees"
  s.email = "apohllo@o2.pl"
  s.homepage = "http://github.com/apohllo/c45"
  s.require_path = "lib"
  s.description = "Ruby tools for c4.5 decission trees"
  s.authors = ['Aleksander Pohl']
  s.files = `git ls-files`.split("\n")
  #s.test_files = Dir.glob("spec/**/*") + Dir.glob("integration/**/*")
  #s.rdoc_options = ["--main", "README.rdoc"]
  s.has_rdoc = true
  #s.extra_rdoc_files = ["README.rdoc"]
end
