//
//  SSAppDelegate.m
//  Sublime Sync
//
//  Created by Oame on 2012/10/16.
//  Copyright (c) 2012年 oameya. All rights reserved.
//

#import "SSAppDelegate.h"

@implementation SSAppDelegate
@synthesize segment;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  NSFileManager* fm = [NSFileManager defaultManager];
  NSString* st_p_dir = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Application Support/Sublime Text 2/Packages"];
  NSDictionary* attr = [fm attributesOfItemAtPath:st_p_dir error:nil];
  if(attr[NSFileType] == NSFileTypeSymbolicLink){
    [self.textLabel setStringValue:NSLocalizedString(@"iCloud Sync is enabled", @"")];
    [self.segment setSelected:YES forSegment:0];
  } else {
    [self.textLabel setStringValue:NSLocalizedString(@"iCloud Sync is disabled", @"")];
    [self.segment setSelected:YES forSegment:1];
  }
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag {
  [self.window makeKeyAndOrderFront:nil];
  return NO;
}

- (IBAction)pushSegmentButton:(id)sender {
  NSString* home_dir = NSHomeDirectory();
  NSString* sync_dir = [home_dir stringByAppendingPathComponent:@"Library/Mobile Documents/com~oameya~SublimeSync"];
  NSString* st_dir = [home_dir stringByAppendingPathComponent:@"Library/Application Support/Sublime Text 2"];
  NSString* st_ip_dir = [st_dir stringByAppendingPathComponent:@"Installed Packages"];
  NSString* st_pp_dir = [st_dir stringByAppendingPathComponent:@"Pristine Packages"];
  NSString* st_p_dir = [st_dir stringByAppendingPathComponent:@"Packages"];
  NSString* sync_ip_dir = [sync_dir stringByAppendingPathComponent:@"Installed Packages"];
  NSString* sync_pp_dir = [sync_dir stringByAppendingPathComponent:@"Pristine Packages"];
  NSString* sync_p_dir = [sync_dir stringByAppendingPathComponent:@"Packages"];
  
  NSFileManager* fm = [NSFileManager defaultManager];
  if(![fm fileExistsAtPath:sync_dir]){
    [fm createDirectoryAtPath:sync_dir withIntermediateDirectories:NO attributes:nil error:nil];
  }
  
  if ((int)[sender selectedSegment] == 0){
    //iCloudにデータを移動してAppSupportにシンボリックリンク
    NSLog(@"First");
    
    NSDictionary* attr = [fm attributesOfItemAtPath:st_p_dir error:nil];
    if(attr[NSFileType] == NSFileTypeDirectory){
      NSLog(@"Run2");
      [fm moveItemAtPath:st_ip_dir toPath:sync_ip_dir error:nil];
      [fm moveItemAtPath:st_pp_dir toPath:sync_pp_dir error:nil];
      [fm moveItemAtPath:st_p_dir toPath:sync_p_dir error:nil];
      [fm createSymbolicLinkAtPath:st_ip_dir withDestinationPath:sync_ip_dir error:nil];
      [fm createSymbolicLinkAtPath:st_pp_dir withDestinationPath:sync_pp_dir error:nil];
      [fm createSymbolicLinkAtPath:st_p_dir withDestinationPath:sync_p_dir error:nil];
      
      [self.textLabel setStringValue:NSLocalizedString(@"iCloud Sync is enabled", @"")];
    }
  }else {
    //シンボリックリンクを削除してiCloudからSublimeに移動
    NSLog(@"Second");
    NSDictionary* attr = [fm attributesOfItemAtPath:st_p_dir error:nil];
    if(attr[NSFileType] == NSFileTypeSymbolicLink){
      NSLog(@"Run");
      [fm removeItemAtPath:st_ip_dir error:nil];
      [fm removeItemAtPath:st_pp_dir error:nil];
      [fm removeItemAtPath:st_p_dir error:nil];
      [fm moveItemAtPath:sync_ip_dir toPath:st_ip_dir error:nil];
      [fm moveItemAtPath:sync_pp_dir toPath:st_pp_dir error:nil];
      [fm moveItemAtPath:sync_p_dir toPath:st_p_dir error:nil];
      
      [self.textLabel setStringValue:NSLocalizedString(@"iCloud Sync is disabled", @"")];
    }
  }
}
@end
