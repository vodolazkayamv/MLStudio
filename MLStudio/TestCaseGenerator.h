//
//  TestCaseGenerator.h
//  MLStudio
//
//  Created by Водолазкий В.В. on 07.11.15.
//  Copyright © 2015 Geomatix Laboratoriess S.R.O. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Algorithm.h"

@interface TestCaseGenerator : NSObject

@property (nonatomic, readwrite) NSString *subroutineToTest;	// реальная функция для теста
@property (nonatomic, readonly) NSString *template;			// шаблон для начальной подстановки в редактор
@property (nonatomic, readonly) NSString *callTemplate;
@property (nonatomic, readwrite) NSString *compilationResult;
@property (nonatomic, readwrite) NSString *executionResult;


- (NSString *) createTestApp:(Algorithm *)alg;		// создание и компиляция ткстовой программы на базе функции
- (BOOL) compileFile;								// компиляция файла с тестомб Возвращает YES, если успешно
- (BOOL) executeTestFile;							// запустить на выполнение файл с тестовым алгоритмом

@end
