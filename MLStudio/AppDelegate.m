//
//  AppDelegate.m
//  MLStudio
//
//  Created by Водолазкий В.В. on 16.09.15.
//  Copyright (c) 2015 Geomatix Laboratoriess S.R.O. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
	
	NSBundle *mainBundle = [NSBundle mainBundle];
	NSString *pathName = [mainBundle pathForResource:@"Objective C" ofType:@"plist"];
	if (pathName) {
		NSDictionary *objeCdict = [[NSDictionary alloc] initWithContentsOfFile:pathName];
		if (objeCdict) {
			self.objectiveCSyntax = [[ASKSyntax alloc] initWithDefinition:objeCdict];
		}
	}
	
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}

@end
