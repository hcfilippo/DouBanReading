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
    NSString *strUrl = [NSString stringWithFormat:@"https://api.douban.com/v2/book/search?count=1&q='%@'", text];
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return  [NSURL URLWithString:strUrl];
}


@end
