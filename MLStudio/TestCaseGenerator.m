//
//  TestCaseGenerator.m
//  MLStudio
//
//  Created by Водолазкий В.В. on 07.11.15.
//  Copyright © 2015 Geomatix Laboratoriess S.R.O. All rights reserved.
//

#import "TestCaseGenerator.h"


NSString * const WorkingDirectory	=	@"BUILD";
NSString * const TESTFILE			=	@"TestFile.c";
NSString * const OUTFILE			=	@"TestExecutable";

@implementation TestCaseGenerator


- (NSString *) templatef
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


- (NSString *)callTemplate
{
	
	NSBundle *mb = [NSBundle mainBundle];
	NSString *tPath = [mb pathForResource:@"Initializer" ofType:@"cctemplate"];
	if (tPath) {
		NSError *error = nil;
		NSString *formatString = [NSString stringWithContentsOfFile:tPath encoding:NSUTF8StringEncoding error:&error];
		if (!error) {
			return formatString;
		}
	}
	return @"";

}


- (NSString *)appDictionary
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
	NSString *applicationSupportDirectory = [paths firstObject];

	NSFileManager *fm = [NSFileManager defaultManager];
	NSString *workingDir = [applicationSupportDirectory stringByAppendingPathComponent:WorkingDirectory];
	BOOL isDirectory = NO;
	if ([fm fileExistsAtPath:WorkingDirectory isDirectory:&isDirectory] == NO) {
		NSError *error = nil;
		NSDictionary *dict = nil;
		[fm createDirectoryAtPath:workingDir withIntermediateDirectories:YES attributes:dict error:&error];
		return (error ? nil : workingDir);
	}
	return workingDir;
}


- (NSString *) createTestApp:(Algorithm *)alg
{
	NSBundle *mb = [NSBundle mainBundle];
	NSString *mPath = [mb pathForResource:@"Mainfile" ofType:@"cctemplate"];
	if (mPath) {
		NSError *error = nil;
		NSString *mainFile = [ NSString stringWithContentsOfFile:mPath encoding:NSUTF8StringEncoding
																		 error:&error];
		if (!error) {
			NSRange replaceZone = [mainFile rangeOfString:@"<<<PutFunctionHere>>>"];
			if (replaceZone.location != NSNotFound) {
				mainFile = [mainFile stringByReplacingCharactersInRange:replaceZone
															 withString:alg.algorithm];
                
				// вторая часть - замена фрагмента вызова функции и ее начальных данных
				
				replaceZone = [mainFile rangeOfString:@"<<<PutCallHere>>>"];
				if (replaceZone.location != NSNotFound) {
					mainFile = [mainFile stringByReplacingCharactersInRange:replaceZone withString:alg.callingFragment];
				}
				
				// Теперь надо сохранить эту строчку в виде текстового файла в специальном каталоге
				
                NSString *wdFile = [[self appDictionary] stringByAppendingPathComponent:TESTFILE];
				NSFileManager *fm = [NSFileManager defaultManager];
				if ([fm fileExistsAtPath:wdFile]) {
					[fm removeItemAtPath:wdFile error:&error];
				}
				BOOL succeed = [mainFile writeToFile:wdFile
										  atomically:YES encoding:NSUTF8StringEncoding
											   error:&error];
				if (succeed) {
					return wdFile;
				}
			}
		}
	}
	
	
	return nil;
}


- (BOOL) compileFile
{
	NSString *wdFile = [[self appDictionary] stringByAppendingPathComponent:TESTFILE];
	NSString *outFile = [[self appDictionary] stringByAppendingPathComponent:OUTFILE];

	// флормируем задачу и ее параметры
	NSTask *task = [[NSTask alloc] init];
	[task setLaunchPath:@"/usr/bin/gcc"];
	NSArray *args = @[wdFile, @"-o", outFile];
	task.arguments = args;
	
	// Формируем конвейер для вывода результатов комиляции
	NSPipe *outPipe = [[NSPipe alloc] init];
	[task setStandardOutput:outPipe];
	[task setStandardError:outPipe];
	
	// стартуем задачу
	[task launch];
	
	NSData *outData = [[outPipe fileHandleForReading] readDataToEndOfFile];
	self.compilationResult = [[NSString alloc] initWithData:outData encoding:NSUTF8StringEncoding];
	
	return (task.terminationStatus == 0);
}

- (BOOL) executeTestFile
{
	NSString *outFile = [[self appDictionary] stringByAppendingPathComponent:OUTFILE];
	NSTask *task = [[NSTask alloc] init];
	
	task.launchPath = outFile;
	
	NSPipe *outPipe = [[NSPipe alloc] init];
	[task setStandardOutput:outPipe];
	[task setStandardError:outPipe];
	
	// стартуем задачу
	[task launch];
	
	NSData *outData = [[outPipe fileHandleForReading] readDataToEndOfFile];

	self.executionResult = [[NSString alloc] initWithData:outData encoding:NSUTF8StringEncoding];
	
	return (task.terminationStatus == 0);
	
}

@end
