//
//  DouBanFetcher.h
//  DouBanReading
//
//  Created by hcfilippo on 14-6-17.
//  Copyright (c) 2014年 hcfilippo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DouBanAPIKey.h"

@interface DouBanFetcher : NSObject

+ (NSURL *)URLforSearchText:(NSString *)text;

+ (NSURL *)URLforBookAnnotation:(NSInteger)bookID;

+ (NSURL *)URLWithAnnotationID:(NSInteger)annotationID;

@end
