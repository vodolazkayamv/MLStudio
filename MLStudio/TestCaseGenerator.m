//
//  TestCaseGenerator.m
//  MLStudio
//
//  Created by Водолазкий В.В. on 07.11.15.
//  Copyright © 2015 Geomatix Laboratoriess S.R.O. All rights reserved.
//

#import "TestCaseGenerator.h"

@implementation TestCaseGenerator



- (NSString *) template
{
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateStyle:NSDateFormatterMediumStyle];
	NSString *dateString = [df stringFromDate:[NSDate date]];
	NSString *userName = NSFullUserName();
	
	NSBundle *mb = [NSBundle mainBundle];
	NSString *tPath = [mb pathForResource:@"testFunctionTemplate" ofType:@"cctemplate"];
	if (tPath) {
		NSError *error = nil;
		NSString *formatString = [NSString stringWithContentsOfFile:tPath encoding:NSUTF8StringEncoding error:&error];
		if (!error) {
			return [NSString stringWithFormat:formatString, userName, dateString];
		}
	}
		return @"";
}


- (void) createTestApp
{
	
}

@end
