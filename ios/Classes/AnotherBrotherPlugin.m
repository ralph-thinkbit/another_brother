#import "AnotherBrotherPlugin.h"
#if __has_include(<another_brother/another_brother-Swift.h>)
#import <another_brother/another_brother-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
//#import "another_brother-Swift.h"
#endif

#import <BRLMPrinterKit/BRLMPrinterKit.h>
#import <BRLMPrinterKit/BRPtouchDeviceInfo.h>

#import "Method/PrintFileMethodCall.h"
#import "Method/PrintImageMethodCall.h"
#import "Method/PrintFileListMethodCall.h"
#import "Method/PrintPdfFileMethodCall.h"
#import "Method/CancelMethodCall.h"
#import "Method/GetPrinterStatusMethodCall.h"
#import "Method/GetNetPrintersMethodCall.h"
#import "Method/GetBluetoothPrintersMethodCall.h"
#import "Method/StartCommunicationMethodCall.h"
#import "Method/EndCommunicationMethodCall.h"

/*
@implementation AnotherBrotherPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAnotherBrotherPlugin registerWithRegistrar:registrar];
}
*/

#import "AnotherBrotherPlugin.h"
#import "Method/BrotherUtils.h"

@implementation AnotherBrotherPlugin

// Print method calls do synchronous network I/O against the printer.
// Run them off the main thread so the Flutter UI never freezes mid-print.
static void ExecuteOnBackground(void (^block)(void)) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    
    // Track the registrar to get Asstes from.
    [BrotherUtils setRegistrarFlutter:registrar];
    
  FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"another_brother" binaryMessenger:[registrar messenger]];
    AnotherBrotherPlugin* instance = [AnotherBrotherPlugin new];
  [registrar addMethodCallDelegate:instance channel:channel];
    
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
      result([NSString stringWithFormat:@"iOS %@", UIDevice.currentDevice.systemVersion]);
  }
  else if ([[PrintFileMethodCall METHOD_NAME] isEqualToString:call.method]) {
      ExecuteOnBackground(^{
          [[[PrintFileMethodCall alloc] initWithCall:call result:result] execute];
      });
  }
  else if ([[PrintImageMethodCall METHOD_NAME] isEqualToString:call.method]) {
      ExecuteOnBackground(^{
          [[[PrintImageMethodCall alloc] initWithCall:call result:result] execute];
      });
  }
  else if ([[PrintFileListMethodCall METHOD_NAME] isEqualToString:call.method]) {
      ExecuteOnBackground(^{
          [[[PrintFileListMethodCall alloc] initWithCall:call result:result] execute];
      });
  }
  else if ([[PrintPdfFileMethodCall METHOD_NAME] isEqualToString:call.method]) {
      ExecuteOnBackground(^{
          [[[PrintPdfFileMethodCall alloc] initWithCall:call result:result] execute];
      });
  }
  else if ([[CancelMethodCall METHOD_NAME] isEqualToString:call.method]) {
      [[[CancelMethodCall alloc] initWithCall:call result:result] execute];
  }
  else if ([[GetPrinterStatusMethodCall METHOD_NAME] isEqualToString:call.method]) {
      [[[GetPrinterStatusMethodCall alloc] initWithCall:call result:result] execute];
  }
  else if ([[GetNetPrintersMethodCall METHOD_NAME] isEqualToString:call.method]){
      //[[[GetNetPrintersMethodCall alloc] initWithCall:call result:result] execute];
      _lastNetPrinterCall = [[GetNetPrintersMethodCall alloc] initWithCall:call result:result];
      [(GetNetPrintersMethodCall*)_lastNetPrinterCall execute];
  }
  else if ([[GetBluetoothPrintersMethodCall METHOD_NAME] isEqualToString:call.method]) {
      [[[GetBluetoothPrintersMethodCall alloc] initWithCall:call result:result] execute];
  }
  else if ([[StartCommunicationMethodCall METHOD_NAME] isEqualToString:call.method]) {
      [[[StartCommunicationMethodCall alloc] initWithCall:call result:result] execute];
  }
  else if ([[EndCommunicationMethodCall METHOD_NAME] isEqualToString:call.method]) {
      [[[EndCommunicationMethodCall alloc] initWithCall:call result:result] execute];
  }
  else {
      result(FlutterMethodNotImplemented);
  }
    
}


@end
