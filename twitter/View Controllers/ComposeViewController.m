//
//  ComposeViewController.m
//  twitter
//
//  Created by Aayush Mani Phuyal on 6/30/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController () <UITextViewDelegate>

// MARK: Properties
@property (weak, nonatomic) IBOutlet UITextView *composeView;
@property (weak, nonatomic) IBOutlet UILabel *characterCountLabel;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.composeView.delegate = self;
}

- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Method to post tweet on tapping tweet button
- (IBAction)onTweet:(id)sender {
    NSString *textToTweet = self.composeView.text;
    [[APIManager shared]postStatusWithText:textToTweet completion:^(Tweet *tweet, NSError *error) {
        if(!error){
            [self.delegate didTweet:tweet];
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }];
}

// Text View Delegagte method to make sure typed character is in range of 280 characters
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range   replacementText:(NSString *)text {
    NSUInteger lengthOfCharacters = [textView.text length] + [text length] - range.length;
    return (lengthOfCharacters > 280) ? NO : YES;
}

// Text View Delegate method update to show characters left
-(void)textViewDidChange:(UITextView *)textView {
    NSUInteger maximumCharacters = 280;
    NSUInteger charactersLeft = maximumCharacters - [textView.text length];
    self.characterCountLabel.text = [NSString stringWithFormat:@"Characters Remaining: %lu",charactersLeft];
}

@end
