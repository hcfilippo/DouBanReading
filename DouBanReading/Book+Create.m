//
//  Book+Create.m
//  DouBanReading
//
//  Created by hcfilippo on 14-6-21.
//  Copyright (c) 2014年 hcfilippo. All rights reserved.
//

#import "Book+Create.h"

@implementation Book (Create)

+ (Book *)bookWithDictionary:(NSDictionary *)bookDictionary
                  withAuthor:(NSString *)author
      inManagedObjectContext:(NSManagedObjectContext *)context;
{
    NSString *bookID = [NSString stringWithString:[bookDictionary objectForKey:@"id"]];
    Book *book = nil;
    if ([bookID length]) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Book"];
        request.predicate = [NSPredicate predicateWithFormat:@"book_id = %@", bookID];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        if (!matches || ([matches count] > 1)) {
            // handle error
        } else if (![matches count]) {
            book = [NSEntityDescription insertNewObjectForEntityForName:@"Book"
                                                         inManagedObjectContext:context];
            book.book_id = bookID;
            book.title = [bookDictionary valueForKeyPath:@"title"];
            book.author = author;
            book.averageRating = [bookDictionary valueForKeyPath:@"rating.average"];
            book.imageUrl = [bookDictionary valueForKeyPath:@"image"];
            book.price = [bookDictionary valueForKeyPath:@"price"];
            book.image = nil;
        } else {
            book = [matches lastObject];
        }

    }
    
    return book;
}


+ (Book *)bookWithBookID:(NSString *)bookID
  inManagedObjectContext:(NSManagedObjectContext *)context
{
    Book *book = nil;
    if ([bookID length]) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Book"];
        request.predicate = [NSPredicate predicateWithFormat:@"book_id = %@", bookID];
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        if (!matches || ([matches count] > 1)) {
            // handle error
        } else if (![matches count]) {
            book = nil;
        } else {
            book = [matches lastObject];
        }
    }
    return book;
}


@end
