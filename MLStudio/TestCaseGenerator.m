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
	return [NSString stringWithFormat:@"/*\n    MLStudio. \n    Copyright (C) %@, %@\n*/\n\n int testFunction(int a, int b, int c)\n{\n\n\n}",userName, dateString];
}


- (void) createTestApp
{
	
}

@end
