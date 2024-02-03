Pod::Spec.new do |spec|
  spec.name         = "XCTestDocProjectGen"
  spec.version      = "0.0.1"
  spec.summary      = "Create a project to generate documents from XCTest targets."
  spec.homepage     = "https://github.com/shotaIDE/xctest-document-project-generater"
  spec.license      = { :type => "MIT", :file => "LICENSE.txt" }
  spec.author             = { "Shota Ide" => "ide.shota.dev@gmail.com" }
  spec.osx.deployment_target = "12.0"
  spec.source       = { :git => "https://github.com/shotaIDE/xctest-document-project-generater.git", :tag => "#{spec.version}" }
  spec.preserve_paths   = '*'
end
