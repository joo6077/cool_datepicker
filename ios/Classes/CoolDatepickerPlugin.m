#import "CoolDatepickerPlugin.h"
#if __has_include(<cool_datepicker/cool_datepicker-Swift.h>)
#import <cool_datepicker/cool_datepicker-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "cool_datepicker-Swift.h"
#endif

@implementation CoolDatepickerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCoolDatepickerPlugin registerWithRegistrar:registrar];
}
@end
