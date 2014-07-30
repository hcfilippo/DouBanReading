//
//  SearchResultTableViewController.m
//  DouBanReading
//
//  Created by hcfilippo on 14-6-17.
//  Copyright (c) 2014年 hcfilippo. All rights reserved.
//

#import "SearchResultTableViewController.h"
#import "Book+Create.h"
#import "BookTableViewCell.h"
#import "AppDelegate.h"
#import <AFNetworking/AFNetworking.h>

@interface SearchResultTableViewController ()

@end

@implementation SearchResultTableViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)managedObjectContextDidSave:(NSNotification *)notification
{
    [self.tableView reloadData];
}


- (IBAction)clickHome:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(managedObjectContextDidSave:)
                                                 name:@"ImageSavedNotification"
                                               object:nil];
    
    
    if (self.searchResult) {
        self.books = [self.searchResult valueForKey:@"books"];
    }
    else {
        NSLog(@"search result not prepared");
    }
}


- (NSManagedObjectContext *)context
{
    if (!_context)
    {
        AppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
        _context = appDelegate.document.managedObjectContext;
        
    }
    return _context;
}


- (NSDictionary *)searchResult
{
    if (!_searchResult)
    {
        _searchResult = [[NSDictionary alloc] init];
    }
    return _searchResult;
}

- (NSString *)searchText
{
    if (!_searchText)
    {
        _searchText = [[NSString alloc] init];
    }
    return _searchText;
}

- (NSArray *)books
{
    if (!_books)
    {
        _books = [[NSArray alloc] init];
    }
    return _books;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BookCell";
    BookTableViewCell *cell = (BookTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BookTableViewCell" owner:self options:nil] lastObject];
    }
    
    NSDictionary *bookDictionary = [self.books objectAtIndex:indexPath.row];
    
    NSString *book_id = [bookDictionary valueForKeyPath:@"id"];
    Book *book = [Book bookWithBookID:book_id inManagedObjectContext:self.context];
    
    cell.titleLabel.text = book.title;
    cell.subtitleLabel.text = book.author;
    cell.ratingLabel.text = [NSString stringWithFormat:@"平均得分：%@",book.averageRating];
    cell.priceLabel.text = book.price;
    
    if (book.image)
    {
        [cell.imgView setContentMode:UIViewContentModeScaleToFill];
        cell.imgView.image = [UIImage imageWithData:book.image] ;
    }
    else {
        cell.imgView.image = nil;
        [self fetchImage:cell withBook:book times:1];
    }
    return cell;
}

- (void)fetchImage:(UITableViewCell *)cell withBook:(Book *)book times:(int)times
{
    NSURL *thumbnailURL = [NSURL URLWithString:book.imageUrl];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:thumbnailURL];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *imageData = (NSData *)responseObject;
        book.image = imageData;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ImageSavedNotification" object:nil];
        
//        BookTableViewCell *bookcell = (BookTableViewCell *)cell;
//        [bookcell.imgView setContentMode:UIViewContentModeScaleToFill];
//        bookcell.imgView.image = [[UIImage alloc] initWithData:imageData];
 
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Fetching Image Failure -- %@", error);
        int t = times + 1;
        if (t < 3)
        {
            //retry fetching image
            [self fetchImage:cell withBook:book times:t];
        }
        else {
            cell.imageView.image = nil;
        }
    }];
    [operation start];
}



- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.books.count;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
