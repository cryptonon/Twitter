//
//  ComposeViewController.m
//  twitter
//
//  Created by Aayush Mani Phuyal on 6/30/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController ()

// MARK: Properties
@property (weak, nonatomic) IBOutlet UITextView *composeView;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onTweet:(id)sender {
    NSString *textToTweet = self.composeView.text;
    [[APIManager shared]postStatusWithText:textToTweet completion:^(Tweet *tweet, NSError *error) {
        if(!error){
            [self.delegate didTweet:tweet];
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }];
}

@end
