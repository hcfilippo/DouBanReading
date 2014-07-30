//
//  DouBanFetcher.m
//  DouBanReading
//
//  Created by hcfilippo on 14-6-17.
//  Copyright (c) 2014年 hcfilippo. All rights reserved.
//

#import "DouBanFetcher.h"

@implementation DouBanFetcher

+ (NSURL *)URLforSearchText:(NSString *)text
{
    NSString *strUrl = [NSString stringWithFormat:@"https://api.douban.com/v2/book/search?q='%@'", text];
    strUrl = [DouBanFetcher addAPIKey:strUrl];
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return  [NSURL URLWithString:strUrl];
}


+ (NSURL *)URLforBookAnnotation:(NSInteger)bookID
{
    NSString *strUrl = [NSString stringWithFormat:@"https://api.douban.com/v2/book/%d/annotations", bookID];
    strUrl = [DouBanFetcher addAPIKey:strUrl];
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return  [NSURL URLWithString:strUrl];
}

+ (NSURL *)URLWithAnnotationID:(NSInteger)annotationID
{
    NSString *strUrl = [NSString stringWithFormat:@"https://api.douban.com/v2/book/annotation/%d", annotationID];
    strUrl = [DouBanFetcher addAPIKey:strUrl];
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return  [NSURL URLWithString:strUrl];
}


+ (NSString *)addAPIKey:(NSString *)s
{
    return [NSString stringWithFormat:@"%@&apikey=%s", s, DouBanAPIKey];
}


@end
