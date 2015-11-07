//
//  Document.h
//  MLStudio
//
//  Created by Водолазкий В.В. on 16.09.15.
//  Copyright (c) 2015 Geomatix Laboratoriess S.R.O. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SyntaxKit.h"

@interface Document : NSPersistentDocument

- (IBAction)testModule:(id)sender;

@property (strong) IBOutlet ASKSyntaxViewController *syntaxViewController;
@property (weak) IBOutlet NSScrollView *logWindow;

@property (nonatomic, readonly) IBOutlet BOOL generateButtonEnabled;

@end
