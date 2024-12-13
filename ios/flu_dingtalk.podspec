#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flu_dingtalk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flu_dingtalk'
  s.version          = '1.1.0'
  s.summary          = 'dingtalk SDK flutter plugin.'
  s.description      = <<-DESC
dingtalk SDK flutter plugin.
                       DESC
  s.homepage         = 'https://github.com/yangyu92/flu_dingtalk'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'yangyu' => 'yang_yu92@foxmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  # s.static_framework = true
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  s.static_framework = true
  s.vendored_frameworks = ['Libraries/DTShareKit.xcframework']

  # v3.0.0
  # s.subspec 'vendor' do |sp|
    
  #   s.vendored_frameworks = ['Libraries/DTShareKit.xcframework']
  # #   sp.vendored_frameworks = 'Libraries/*.framework'
  # #   #sp.frameworks = 'Security', 'SystemConfiguration', 'CoreGraphics', 'CoreTelephony', 'WebKit'
  # #   #sp.libraries = 'iconv', 'sqlite3', 'stdc++', 'z'
  # #   #sp.requires_arc = true
  # end

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'flu_dingtalk_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
