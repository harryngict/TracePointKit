Pod::Spec.new do |spec|
  spec.name         = "TracePointKitImp"
  spec.module_name  = 'TracePointKitImp'
  spec.version      = "0.0.1"
  spec.summary      = "A Swift library for logging and tracking activities in your iOS application."
  spec.description  = <<-DESC
                      The "TracePointKitImp" to implement TracePointKit
                      DESC
  spec.homepage     = "git@github.com:harryngict/TracePointKit.git"
  spec.authors      = { "Harry Nguyen Chi Hoang" => "harryngict@gmail.com" }
  spec.license      = { :type => "MIT", :text => "Copyright © 2025" }
  spec.requires_arc = true
  spec.static_framework = false
  spec.platform   = :ios, "14.0"
  spec.swift_version = '5.3'
  spec.cocoapods_version    = '>= 1.12.0'
  spec.source      = {
   :git => 'git@github.com:harryngict/TracePointKit.git',
   :tag => 'TracePointKit-' + spec.version.to_s
  }
  spec.source_files = "Sources/TracePointKit/implementation/src/**/*.{swift}"
  spec.dependency 'TracePointKit'

  spec.test_spec 'UnitTests' do |unit_tests|
    unit_tests.scheme = { :code_coverage => true }
    unit_tests.requires_app_host = true
    unit_tests.source_files = 'Sources/TracePointKit/implementation/Tests/**/*.{swift,h}'
    unit_tests.frameworks = ['XCTest']
    unit_tests.dependency 'TracePointKitMock'
  end
end
