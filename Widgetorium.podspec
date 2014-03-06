#
# Be sure to run `pod spec lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about the attributes see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = "Widgetorium"
  s.version          = "0.1.0"
  s.summary          = "A small set of widgets/controls that we usually reuse on several projects and we thought it was a good idea to make it a CocoaPod library."
  s.description      = <<-DESC
                       Widgetorium is not meant to be a big framework that will force you to work like
		       we like. On the other hand, we are deliverying a set of tools that you can use
		       individually which main goal is avoid having to re invent the wheel everytime 
		       you start a new project. 

		       Some examples are:
                       * A loading indicator
		       * Input validators
                       * NSArray & NSDictionary categories
                       DESC
  s.homepage         = "https://github.com/scvsoft/widgetorium_ios/blob/master/README.md"
  s.license          = 'MIT'
  s.author           = { "gomera" => "sebastian.mera@gmail.com" }
  s.source           = { :git => "https://github.com/scvsoft/widgetorium_ios", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/scvsoft'

  s.platform     = :ios, '6.1.3'
  s.ios.deployment_target = '6.1.3'
  s.requires_arc = true

  s.source_files = 'Classes'
  s.resources = 'Resources'

  s.ios.exclude_files = 'Classes/osx'
  s.osx.exclude_files = 'Classes/ios'
  # s.public_header_files = 'Classes/**/*.h'
  # s.frameworks = 'SomeFramework', 'AnotherFramework'
  # s.dependency 'JSONKit', '~> 1.4'
end
