#import "SpectacleLoginItemHelper.h"

#import <ServiceManagement/ServiceManagement.h>

@implementation SpectacleLoginItemHelper

+ (BOOL)isLoginItemEnabledForBundle:(NSBundle *)bundle
{
  if (@available(macOS 13.0, *)) {
    return [[SMAppService mainAppService] status] == SMAppServiceStatusEnabled;
  }
  // On macOS 10.13-12 the login item state cannot be queried without deprecated
  // LSSharedFileList APIs that are no longer in the SDK; return NO as a safe default.
  return NO;
}

+ (void)enableLoginItemForBundle:(NSBundle *)bundle
{
  if (@available(macOS 13.0, *)) {
    NSError *error = nil;
    if (![[SMAppService mainAppService] registerAndReturnError:&error]) {
      NSLog(@"Failed to enable login item: %@", error);
    }
  } else {
    NSLog(@"Launch at login requires macOS 13 or later.");
  }
}

+ (void)disableLoginItemForBundle:(NSBundle *)bundle
{
  if (@available(macOS 13.0, *)) {
    NSError *error = nil;
    if (![[SMAppService mainAppService] unregisterAndReturnError:&error]) {
      NSLog(@"Failed to disable login item: %@", error);
    }
  }
}

@end
