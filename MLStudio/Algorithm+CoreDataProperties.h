//
//  Algorithm+CoreDataProperties.h
//  MLStudio
//
//  Created by Водолазкий В.В. on 08.11.15.
//  Copyright © 2015 Geomatix Laboratoriess S.R.O. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Algorithm.h"

NS_ASSUME_NONNULL_BEGIN

@interface Algorithm (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *algorithm;
@property (nullable, nonatomic, retain) NSString *callingFragment;

@end

NS_ASSUME_NONNULL_END
