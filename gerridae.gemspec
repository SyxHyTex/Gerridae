require "gerridae/version"

Gem::Specification.new do |gem|
  gem.name              = 'Gerridae'
  gem.version           = '0.0.1.pre'
  gem.licenses          = ['MIT']
  gem.summary           = %q{Basic web crawler gem utility.}
  gem.description       = %q{Web crawler utility through API.}
  gem.homepage          = 'https://github.com/SyxHyTex/Gerridae'
  gem.author            = 'Austin Schaefer'
  gem.email             = 'Schaefer.Austin@tutanota.com'

  gem.files             = `git ls-files`.split("\n")
  gem.test_files        = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables       = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.require_paths     = ["lib"]

  gem.add_development_dependency "rspec", "~>3.3.1"
end
