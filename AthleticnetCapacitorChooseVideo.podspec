
  Pod::Spec.new do |s|
    s.name = 'AthleticnetCapacitorChooseVideo'
    s.version = '5.0.2'
    s.summary = 'Select a video in ios'
    s.license = 'MIT'
    s.homepage = 'https://github.com/AthleticNet/capacitor-choose-video'
    s.author = 'Ben Thomas'
    s.source = { :git => 'https://github.com/AthleticNet/capacitor-choose-video', :tag => s.version.to_s }
    s.source_files = 'ios/Plugin/**/*.{swift,h,m,c,cc,mm,cpp}'
    s.ios.deployment_target = '15.0'
    s.dependency 'Capacitor'
  end
