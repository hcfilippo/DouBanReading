//
//  ViewController.m
//  DouBanReading
//
//  Created by hcfilippo on 14-6-9.
//  Copyright (c) 2014年 hcfilippo. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "DouBanFetcher.h"
#import "SearchResultTableViewController.h"
#import "Book+Create.h"
#import "AppDelegate.h"


@interface ViewController () <UITextFieldDelegate, UIDynamicAnimatorDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (strong, nonatomic) UIButton *cancelButton;
@end

@implementation ViewController

#define BLANKTEXT @"书名、作者、ISBN"

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.searchField setFrame:CGRectMake(20, self.view.center.y, self.view.frame.size.width - 40, self.searchField.frame.size.height)];
    self.searchField.text = BLANKTEXT;
    self.searchField.textColor = [UIColor grayColor];
    
    CGRect frame = CGRectMake(self.view.frame.size.width - 55, 20, 35, self.searchField.frame.size.height);
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.cancelButton.frame = frame;
    self.cancelButton.backgroundColor = [UIColor whiteColor];
    [self.cancelButton setTitle:@"取消" forState: UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];
    self.cancelButton.hidden = YES;
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



-(IBAction) cancelButtonClicked:(id)sender
{
    self.searchField.text = @"";
    [self.searchField resignFirstResponder];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    [UIView animateWithDuration:0.1 animations:^{
        [textField setFrame:CGRectMake(20, 20, self.view.frame.size.width - 80, textField.frame.size.height)];
        if ([textField.text isEqualToString:BLANKTEXT])
        {
            textField.text = @"";
        }
        textField.textColor = [UIColor blackColor];
        self.cancelButton.hidden = NO;
    }];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.1 animations:^{
        [textField setFrame:CGRectMake(20, self.view.center.y - 15, self.view.frame.size.width - 40, textField.frame.size.height)];
        if ([textField.text isEqualToString:@""])
        {
            textField.text = BLANKTEXT;
            textField.textColor = [UIColor grayColor];
        }
        else {
            [self searchBookByText:textField.text];
        }
        self.cancelButton.hidden = YES;
    }];
    return YES;
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)searchBookByText:(NSString *)searchText
{
    self.searchText = searchText;
    NSURL *url = [DouBanFetcher URLforSearchText:searchText];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.searchResult = (NSDictionary *)responseObject;
        [self insertBooks];
        
        [self performSegueWithIdentifier:@"SearchSegue" sender:self];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
    }];
    [operation start];
}

- (void)insertBooks
{
    NSArray *books = [self.searchResult valueForKey:@"books"];
 
    for (NSDictionary *book in books)
    {
        NSArray *authors = [book valueForKeyPath:@"author"];
        NSString *authorsString = @"";
        if (authors.count)
        {
            authorsString = [authors firstObject];
            for (int i = 1 ; i < authors.count; i++)
            {
                NSString *author = [authors objectAtIndex:i];
                authorsString = [NSString stringWithFormat:@"%@,%@",authorsString,author];
            }
        }
        else {
            authorsString = @"匿名作家";
        }
        if (![[book valueForKeyPath:@"publisher"] isEqualToString:@""])
        {
            authorsString = [NSString stringWithFormat:@"%@ / %@",authorsString,[book valueForKeyPath:@"publisher"]];
        }
        if (![[book valueForKeyPath:@"pubdate"] isEqualToString:@""])
        {
            authorsString = [NSString stringWithFormat:@"%@ / %@",authorsString,[book valueForKeyPath:@"pubdate"]];
        }
        
        [Book bookWithDictionary:book withAuthor:authorsString inManagedObjectContext:self.context];
    }
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SearchSegue"]) {
        if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
            
            UINavigationController *dest = (UINavigationController *)segue.destinationViewController;
            SearchResultTableViewController *srvc = (SearchResultTableViewController *)dest.topViewController;
            srvc.searchResult = self.searchResult;
            srvc.searchText = self.searchText;
        }
    }
}


@end
