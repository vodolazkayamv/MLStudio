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
#import "Algorithm.h"

@interface Document ()
{
	TestCaseGenerator *generator;
	Algorithm *currentAlgorithm;
	BOOL newDocument;
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
	
	NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:[[Algorithm class] description]];
	NSError *error = nil;
	NSArray *res = [self.managedObjectContext executeFetchRequest:req error:&error];
	if (!error && res.count > 0) {
		currentAlgorithm = res[0];
		newDocument = NO;
	} else {
		currentAlgorithm = [NSEntityDescription insertNewObjectForEntityForName:[[Algorithm class] description]
														 inManagedObjectContext:self.managedObjectContext];
		currentAlgorithm.algorithm = generator.template;
		currentAlgorithm.callingFragment = generator.callTemplate;
		newDocument = YES;
	}

	AppDelegate *d = (AppDelegate *)[[NSApplication sharedApplication] delegate];
	// настраиваем окно синтаксизатора
	self.syntaxViewController.syntax = d.objectiveCSyntax;
	self.syntaxViewController.showsLineNumbers = YES;
	
	[self.syntaxViewController.view setString:currentAlgorithm.algorithm];
	
	self.initalizerViewController.syntax = d.objectiveCSyntax;
	self.initalizerViewController.showsLineNumbers = YES;
	
	[self.initalizerViewController.view setString:currentAlgorithm.callingFragment];
}

- (BOOL) generateButtonEnabled
{
	return ([self.syntaxViewController.view.textStorage  string].length > 0);
}

- (BOOL) callTemplateEnabled
{
	return ([self.initalizerViewController.view.textStorage  string].length > 0);
}

- (BOOL) isDocumentEdited
{
	NSString *curT = [self.syntaxViewController.view.textStorage  string];
	NSString *curI = [self.initalizerViewController.view.textStorage  string];
	if ([currentAlgorithm.algorithm isEqualToString:curT] &&
		[currentAlgorithm.callingFragment isEqualToString:curI]) {
		return newDocument;
	}
	currentAlgorithm.algorithm = curT;
	currentAlgorithm.callingFragment = curI;
	return YES;
}


+ (BOOL)autosavesInPlace {
	return YES;
}

- (NSString *)windowNibName {
	// Override returning the nib file name of the document
	// If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
	return @"Document";
}

- (void)appendToLogWindow:(NSString*)text
{
	dispatch_async(dispatch_get_main_queue(), ^{
		NSString *texta = [text stringByAppendingString:@"\n"];
		NSAttributedString* attr = [[NSAttributedString alloc] initWithString:texta];
		
		[[self.logView textStorage] appendAttributedString:attr];
		[self.logView scrollRangeToVisible:NSMakeRange([[self.logView string] length], 0)];
	});
}

- (IBAction)testModule:(id)sender
{
	if (self.generateButtonEnabled) {
		[self appendToLogWindow:@"\n"];
		// объект не пустой, пытаемся создать и сгененрировать файл
		NSString *curT = [self.syntaxViewController.view.textStorage  string];
		NSString *curI = [self.initalizerViewController.view.textStorage  string];
		currentAlgorithm.algorithm = curT;
		currentAlgorithm.callingFragment = curI;
		[self.managedObjectContext save:nil];
		NSString *generatedTestFile = [generator createTestApp:currentAlgorithm];
		if (generatedTestFile) {
			[self appendToLogWindow:@"Файл сгенерирован"];
			
			// Этап №2 уомпиляция файла
			BOOL fileCompiled = [generator compileFile];
			if (fileCompiled) {
				// Запускаем тест на выполнение
				[self appendToLogWindow:@"Компиляция успешно завершена"];
				BOOL taskResult = [generator executeTestFile];
				
				[self appendToLogWindow:generator.executionResult];
				[self appendToLogWindow:(taskResult ? @"Задача успешно завершена" : @"Оибка выполнения")];
				
				
			} else {
				// компиляция неудачна
				[self appendToLogWindow:@"Ошибка компиляции!"];
				[self appendToLogWindow:generator.compilationResult];
			}
			
		}
	}
}
@end
