//
//  Book+Create.h
//  DouBanReading
//
//  Created by hcfilippo on 14-6-21.
//  Copyright (c) 2014年 hcfilippo. All rights reserved.
//

#import "Book.h"

@interface Book (Create)
+ (Book *)bookWithDictionary:(NSDictionary *)bookDictionary
                  withAuthor:(NSString *)author
inManagedObjectContext:(NSManagedObjectContext *)context;


+ (Book *)bookWithBookID:(NSString *)bookID
      inManagedObjectContext:(NSManagedObjectContext *)context;

@end
