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
@property (weak) IBOutlet NSButton *showMEssageWindow;

@property (strong) IBOutlet ASKSyntaxViewController *syntaxViewController;

@property (strong) IBOutlet ASKSyntaxViewController *initalizerViewController;
@property (weak) IBOutlet NSScrollView *scrollView;
@property (unsafe_unretained) IBOutlet NSTextView *logView;

@property (nonatomic, readonly)  BOOL generateButtonEnabled;

@end
