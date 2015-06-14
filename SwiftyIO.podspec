Pod::Spec.new do |s|
  s.name             = "SwiftyIO"
  s.version          = "1.3.0-beta2"
  s.summary          = "A Framework to allow fast integration of Core Data into your iOS and OSX and easily operate on your entity objects"
  s.homepage         = "https://github.com/ravero/SwiftyIO"
  s.license          = 'MIT'
  s.author           = { "Rafael Veronezi" => "rafael@ravero.net" }
  s.source           = { :git => "https://github.com/ravero/SwiftyIO.git", :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.requires_arc = true

  s.source_files = 'SwiftyIO/**/*.swift'
  s.osx.exclude_files = 'SwiftyIO/iOS'
end
