//
//  Document.m
//  MLStudio
//
//  Created by Водолазкий В.В. on 16.09.15.
//  Copyright (c) 2015 Geomatix Laboratoriess S.R.O. All rights reserved.
//

#import "Document.h"
#import "AppDelegate.h"
#import "MLStudioErrors.h"
#import "TestCaseGenerator.h"

@interface Document ()
{
	TestCaseGenerator *generator;
}
@end

@implementation Document

- (instancetype)init {
    self = [super init];
    if (self) {
		// Add your subclass-specific initialization here.
		generator = [[TestCaseGenerator alloc] init];
    }
    return self;
}


// Метод исопльзуетс для инициализации объектов при загрузке окна документа
- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
	[super windowControllerDidLoadNib:aController];

	AppDelegate *d = (AppDelegate *)[[NSApplication sharedApplication] delegate];
	// настраиваем окно синтаксизатора
	self.syntaxViewController.syntax = d.objectiveCSyntax;
	self.syntaxViewController.showsLineNumbers = YES;
	if (self.generateButtonEnabled == NO) {
		[self.syntaxViewController.view setString:generator.template];
	}
	
}

- (BOOL) generateButtonEnabled
{
	return ([self.syntaxViewController.view.textStorage  string].length > 0);
}


+ (BOOL)autosavesInPlace {
	return YES;
}

- (NSString *)windowNibName {
	// Override returning the nib file name of the document
	// If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
	return @"Document";
}

- (IBAction)testModule:(id)sender
{
	if (self.generateButtonEnabled) {
		// обънкт не пустой, пытаемся создать и сгененрировать файл
		
	}
}
@end
