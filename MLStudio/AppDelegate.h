//
//  AppDelegate.h
//  MLStudio
//
//  Created by Водолазкий В.В. on 16.09.15.
//  Copyright (c) 2015 Geomatix Laboratoriess S.R.O. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SyntaxKit.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, strong) ASKSyntax *objectiveCSyntax;

@end

