#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint another_brother.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'another_brother'
  s.version          = '0.0.1'
  s.summary          = 'A flutter plugin project for printing using the Brother printers.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Rounin Labs' => 'hernandez.f@rouninlabs.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'#, 'Classes/PtouchPrinterKit-Bridging-Header.h'

  # The external 'BROTHERSDK' pod (Type B SDK) builds an empty framework:
  # it links libBROTHERSDK.a with a bare `-l` and no -ObjC/-force_load, so the
  # linker dead-strips the whole archive and _OBJC_CLASS_$_BROTHERSDK is missing
  # at app link time. Fix: vendor the .a/.h here and force-load it with -ObjC.
  s.vendored_libraries = 'BROTHERSDK/libBROTHERSDK.a'

  #s.preserve_paths = 'Lib/BRLMPrinterKit.framework'
  #s.xcconfig = { 'OTHER_LDFLAGS' => '-framework BRLMPrinterKit.framework' }
  #s.ios.vendored_frameworks = 'Lib/BRLMPrinterKit.framework'
  #s.vendored_frameworks = 'BRLMPrinterKit.framework'

  #s.ios.vendored_frameworks = 'Lib/BRPtouchPrinterKit.framework'
  #s.vendored_frameworks = 'BRPtouchPrinterKit.framework'

  #s.dependency 'BRLMPrinterKit'
  s.dependency 'BRLMPrinterKit_AB'

  #s.dependency 'BRLMPrinterKitBind'

  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  # OTHER_LDFLAGS -ObjC force-loads the vendored libBROTHERSDK.a into
  # another_brother.framework (the external BROTHERSDK pod dead-stripped it,
  # yielding 'Undefined symbol: _OBJC_CLASS_$_BROTHERSDK' at app link).
  # BROTHERSDK.h is vendored under Classes/ and imported with quotes so the
  # import resolves inside the pod's own headers regardless of which target
  # triggers the Clang module build.
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'OTHER_LDFLAGS' => '$(inherited) -ObjC',
  }
  s.swift_version = '5.0'
  
  #s.subspec 'BRLMPrinterKit' do |br|
  #  br.source_files = 'Lib/BRLMPrinterKit.framework/**/*'
  #  br.public_header_files = 'Lib/BRLMPrinterKit.framework/**/*.h'
  #end
  
  #s.subspec 'BRLMPrinterKitBind' do |brBind|
  #  brBind.public_header_files = 'Classes/PtouchPrinterKit-Bridging-Header.h'
  #  brBind.dependency 'BRLMPrinterKit'
  #end

  
end
