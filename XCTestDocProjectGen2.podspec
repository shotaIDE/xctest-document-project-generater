# frozen_string_literal: true

Pod::Spec.new do |s|
  s.name = 'XCTestDocProjectGen'
  s.version = '0.0.1'
  s.summary = 'update check.'
  s.homepage = 'https://github.com/shotaIDE/xctest-document-project-generater'
  s.social_media_url = 'https://github.com/shotaIDE/xctest-document-project-generater'
  s.authors = { 'Shota Ide' => 'ide.shota.dev@gmail.com' }
  s.source = { git: 'https://github.com/shotaIDE/xctest-document-project-generater.git', tag: s.version }
  s.ios.deployment_target = '8.0'
  s.source_files = 'Sources/**'
  s.license = {
    type: 'MIT',
    text: File.read('LICENSE.txt')
  }
end
