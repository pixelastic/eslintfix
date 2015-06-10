Gem::Specification.new do |s|
  s.name          = 'eslintfix'
  s.version       = '0.0.0'
  s.summary       = 'Automatically fixes some Eslint errors'
  s.description   = <<-eos
  Eslintfix will read your .eslintrc and try to fix as many errors in your
  JavaScript files as it can. It will internally use a mix of regexp,
  js-beautify and jscs
                     eos
  s.authors       = ['Tim Carry']
  s.email         = 'tim@pixelastic.com'
  s.homepage      = 'https://github.com/pixelastic/eslintfix'
  s.license       = 'MIT'
  s.files         = [
    'lib/eslintfix.rb'
  ]

  s.add_runtime_dependency 'awesome_print'

  s.add_development_dependency 'minitest'
  s.add_development_dependency 'minitest-reporters'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-minitest'

  s.bindir        = 'bin'
  s.executables   = ['eslintfix']
end
