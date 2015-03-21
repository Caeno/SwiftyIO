#
# Be sure to run `pod lib lint CoreDataContext.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "CoreDataContext"
  s.version          = "1.0.1"
  s.summary          = "A Framework to allow fast integration of Core Data into your iOS projects, and easy data operations on defined entities."
  s.homepage         = "https://github.com/ravero/CoreDataContext"
  s.license          = 'MIT'
  s.author           = { "Rafael Veronezi" => "rafael@ravero.net" }
  s.source           = { :git => "https://github.com/ravero/CoreDataContext.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'CoreDataContext/**/*.swift'
  s.resource_bundles = {
    'CoreDataContext' => ['Pod/Assets/*.png']
  }
end
