//
//  SearchResultTableViewController.h
//  DouBanReading
//
//  Created by hcfilippo on 14-6-17.
//  Copyright (c) 2014年 hcfilippo. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface SearchResultTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSDictionary *searchResult;
@property (strong, nonatomic) NSString *searchText;
@property (strong, nonatomic) NSArray *books;
@property (strong, nonatomic) NSManagedObjectContext *context;

@end
