Pod::Spec.new do |s|
  s.name         = "ContactsKit"
  s.version      = "1.0.0"
  s.summary      = "Easy access to iOS address book"
  s.homepage     = "https://github.com/Serjip/ContactsKit"
  s.license      = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.author       = { "Sergey Popov" => "serj@ttitt.ru" }
  s.source       = { :git => "https://github.com/Serjip/ContactsKit.git",
		                 :tag => s.version.to_s }
  s.requires_arc = true
  s.frameworks   = 'AddressBook'

  s.social_media_url      = "https://ttitt.ru"
  s.ios.deployment_target = "6.0"

  s.subspec 'Core' do |sp|
    sp.source_files = 'Pod/Core/*.{h,m}'
  end

  s.subspec 'Swift' do |sp|
    sp.source_files = 'Pod/Swift/*.h'
    sp.dependency 'APAddressBook/Core'
  end

  s.default_subspecs = 'Core'
end
