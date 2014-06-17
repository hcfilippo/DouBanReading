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



@interface ViewController () <UITextFieldDelegate, UIDynamicAnimatorDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (strong, nonatomic) UIButton *cancelButton;

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.searchField setFrame:CGRectMake(20, self.view.center.y, self.view.frame.size.width - 40, self.searchField.frame.size.height)];
    self.searchField.text = @"书名、作者、ISBN";
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


-(IBAction) cancelButtonClicked:(id)sender
{
   [self.searchField resignFirstResponder];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    [UIView animateWithDuration:0.05 animations:^{
        [textField setFrame:CGRectMake(20, 20, self.view.frame.size.width - 80, textField.frame.size.height)];
        if ([textField.text isEqualToString:@"书名、作者、ISBN"])
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
    [UIView animateWithDuration:0.05 animations:^{
        [textField setFrame:CGRectMake(20, self.view.center.y, self.view.frame.size.width - 40, textField.frame.size.height)];
        if ([textField.text isEqualToString:@""])
        {
            textField.text = @"书名、作者、ISBN";
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
    NSURL *url = [DouBanFetcher URLforSearchText:searchText];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *propertyListResults =  (NSDictionary *)responseObject;
        NSLog(@"%@", propertyListResults);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
    }];
    [operation start];
}


@end
