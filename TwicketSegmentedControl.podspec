Pod::Spec.new do |s|
	s.name    = 'TwicketSegmentedControl'
	s.version = '0.1.2'

	s.author      = { 'Pol Quintana' => 'pol.quintana1@gmail.com' }
	s.homepage    = 'https://github.com/twicketapp/TwicketSegmentedControl'
	s.license     = { :type => 'MIT', :file => 'LICENSE' }
	s.platform    = :ios, '9.0'
	s.source      = { :git => 'https://github.com/twicketapp/TwicketSegmentedControl.git', :tag => s.version.to_s }
	s.summary     = 'Custom UISegmentedControl replacement for iOS, written in Swift'
	s.source_files = 'TwicketSegmentedControl/*.swift'
end
