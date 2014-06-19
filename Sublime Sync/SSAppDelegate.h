//
//  SSAppDelegate.h
//  Sublime Sync
//
//  Created by Oame on 2012/10/16.
//  Copyright (c) 2012年 oameya. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SSAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSSegmentedControl *segment;
@property (weak) IBOutlet NSTextField *textLabel;

- (IBAction)pushSegmentButton:(id)sender;

@end
