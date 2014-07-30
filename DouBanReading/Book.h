//
//  Book.h
//  DouBanReading
//
//  Created by hcfilippo on 14-7-4.
//  Copyright (c) 2014年 hcfilippo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Book : NSManagedObject

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * averageRating;
@property (nonatomic, retain) NSString * book_id;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * title;

@end
