
Pod::Spec.new do |s|

  s.name         = "OFXParser"
  s.version      = "0.0.1"
  s.summary      = "Fast OFX 2.x parser."

  s.description  = <<-DESC
	Fast OFX 2.x parser.
        DESC
  s.license      = "MIT"
  s.author             = { "Dmitriy Zakharkin" => "mail@zdima.net" }

  # s.ios.deployment_target = "5.0"
  s.osx.deployment_target = "10.8"

  s.source       = { :git => "https://github.com/zdima/OFXParser.git", :commit => "" }

  s.source_files  = "OFXParser/**/*.{h,m}"
  s.public_header_files = "OFXParser/**/*.h"

  s.requires_arc = true

end
