//
//  ViewController.h
//  DouBanReading
//
//  Created by hcfilippo on 14-6-9.
//  Copyright (c) 2014年 hcfilippo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong,nonatomic) NSDictionary *searchResult;
@property (strong,nonatomic) NSString *searchText;
@property (strong,nonatomic) NSManagedObjectContext *context;

@end
