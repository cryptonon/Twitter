//
//  DetailsViewController.m
//  twitter
//
//  Created by Aayush Mani Phuyal on 7/1/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@interface DetailsViewController () <UITextViewDelegate>

// MARK: Properties
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userScreenName;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *createdAgoLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UITextView *replyTextView;
@property (weak, nonatomic) IBOutlet UILabel *letterCountLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.replyTextView.delegate = self;
    [self setViewProperties];
}

// Method that sets DetailsViewController Properties
- (void)setViewProperties {
    self.userName.text = self.tweet.user.name;
    self.userScreenName.text = self.tweet.user.screenName;
    self.createdAgoLabel.text = self.tweet.createdAgoString;
    self.tweetLabel.text = self.tweet.text;
    
    NSURL *profileImageURL = [NSURL URLWithString:self.tweet.user.profileImageURLString];
    [self.profileImageView setImageWithURL:profileImageURL];
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.size.width / 2;
    
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
    
    self.retweetButton.selected = NO;
    self.favoriteButton.selected = NO;
    self.replyButton.enabled = NO;

    if (self.tweet.retweeted) {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateSelected];
        self.retweetButton.selected = YES;
    }
    if (self.tweet.favorited) {
        [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateSelected];
        self.favoriteButton.selected = YES;
    }
}

// Method to retweet/unretweet on tapping retweet button
- (IBAction)didTapRetweet:(id)sender {
    
    self.retweetButton.selected = !self.retweetButton.selected;
    if (self.retweetButton.selected) {
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (!error) {
                 [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateSelected];
                 self.tweet.retweeted = YES;
                 self.tweet.retweetCount += 1;
                 self.retweetCountLabel.text = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
                 [self.delegate didFavoriteOrRetweet:self.tweet atIndexPath:self.indexPathOfTweet];
            }
        }];
    } else {
        [[APIManager shared] undoRetweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (!error) {
                 [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon.png"] forState:UIControlStateNormal];
                 self.tweet.retweeted = NO;
                 self.tweet.retweetCount -= 1;
                 self.retweetCountLabel.text = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
                 [self.delegate didFavoriteOrRetweet:self.tweet atIndexPath:self.indexPathOfTweet];
            }
        }];
    }
}

// Method to favorite/unfavorite a tweet on tapping favorite button
- (IBAction)didTapFavorite:(id)sender {
    
    self.favoriteButton.selected = !self.favoriteButton.selected;
    if (self.favoriteButton.selected) {
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (!error) {
                 [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateSelected];
                 self.tweet.favorited = YES;
                 self.tweet.favoriteCount += 1;
                 self.favoriteCountLabel.text = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
                 [self.delegate didFavoriteOrRetweet:self.tweet atIndexPath:self.indexPathOfTweet];
            }
        }];
    } else {
        [[APIManager shared] undoFavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if (!error) {
                 [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
                 self.tweet.favorited = NO;
                 self.tweet.favoriteCount -= 1;
                 self.favoriteCountLabel.text = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
                 [self.delegate didFavoriteOrRetweet:self.tweet atIndexPath:self.indexPathOfTweet];
            }
        }];
    }
}

// Method to reply to a tweet on tapping reply button
- (IBAction)didTapReply:(id)sender {
    NSString *replyText = self.replyTextView.text;
    [[APIManager shared] postStatusWithReply:replyText toTweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if (!error) {
            [self.replyTextView resignFirstResponder];
            self.replyTextView.text = @"";
            [self.replyButton setEnabled:NO];
            [self.delegate didReply:tweet];
            self.letterCountLabel.text = @"";
        }
    }];
}

// Method to enable reply butto after editing begins (option delegate method of UITextView Delegate)
- (void) textViewDidBeginEditing:(UITextView *)textView {
        self.replyButton.enabled = YES;
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
    self.letterCountLabel.text = [NSString stringWithFormat:@"Characters Remaining: %lu",charactersLeft];
}

@end
