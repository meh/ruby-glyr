$:.unshift('lib') and require 'glyr'

Gem::Specification.new {|s|
	s.name         = 'glyr'
	s.version      = Glyr.version
	s.author       = 'meh.'
	s.email        = 'meh@paranoici.org'
	s.homepage     = 'http://github.com/meh/ruby-glyr'
	s.platform     = Gem::Platform::RUBY
	s.summary      = 'Wrapper library for glyr.'

	s.files         = `git ls-files`.split("\n")
	s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
	s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
	s.require_paths = ['lib']

	s.add_dependency 'ffi'
	s.add_dependency 'ffi-extra'
	s.add_dependency 'bitmap'
}
