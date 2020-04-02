
  Pod::Spec.new do |s|
    s.name = 'CapacitorChooseVideo'
    s.version = '0.0.1'
    s.summary = 'Select a video in ios'
    s.license = 'MIT'
    s.homepage = 'https://github.com/bennyt2/capacitor-choose-video'
    s.author = 'Ben Thomas'
    s.source = { :git => 'https://github.com/bennyt2/capacitor-choose-video', :tag => s.version.to_s }
    s.source_files = 'ios/Plugin/**/*.{swift,h,m,c,cc,mm,cpp}'
    s.ios.deployment_target  = '11.0'
    s.dependency 'Capacitor'
  end