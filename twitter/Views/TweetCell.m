//
//  TweetCell.m
//  twitter
//
//  Created by Aayush Mani Phuyal on 6/30/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

// Setter Method that sets TweetCell's tweet property
- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
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
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateSelected];
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        self.retweetCountLabel.text = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
        
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            }
        }];
    } else {
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon.png"] forState:UIControlStateNormal];
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        self.retweetCountLabel.text = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
        
        [[APIManager shared] undoRetweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
}

// Method to favorite/unfavorite a tweet on tapping favorite button
- (IBAction)didTapFavorite:(id)sender {
    
    self.favoriteButton.selected = !self.favoriteButton.selected;
    if (self.favoriteButton.selected) {
        [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateSelected];
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        self.favoriteCountLabel.text = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
        
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    } else {
        [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        self.favoriteCountLabel.text = [NSString stringWithFormat:@"%i", self.tweet.favoriteCount];
        
        [[APIManager shared] undoFavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
        }];
    }
}


@end
