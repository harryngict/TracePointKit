Pod::Spec.new do |spec|
  spec.name         = "TracePointKitMock"
  spec.module_name  = 'TracePointKitMock'
  spec.version      = "0.0.1"
  spec.summary      = "A Swift library for logging and tracking activities in your iOS application."
  spec.description  = <<-DESC
                      The "TracePointKitMock" to mock TracePointKit using in unit tests
                      DESC
  spec.homepage     = "https://github.com/harryngict/TracePointKit.git"
  spec.authors      = { "Harry Nguyen Chi Hoang" => "harryngict@gmail.com" }
  spec.license      = { :type => "MIT", :text => "Copyright © 2025" }
  spec.requires_arc = true
  spec.static_framework = false
  spec.platform   = :ios, "14.0"
  spec.swift_version = '5.3'
  spec.cocoapods_version    = '>= 1.12.0'
  spec.source      = {
   :git => 'https://github.com/harryngict/TracePointKit.git',
   :tag => 'TracePointKit-' + spec.version.to_s
  }
  spec.source_files = "Sources/TracePointKit/mocks/src/**/*.{swift}"
  spec.dependency 'TracePointKit'
end
