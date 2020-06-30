//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate>

// MARK: Properties
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tweets;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setting the tableView's dataSource and delegate
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Getting the timeline tweets
    [self fetchTweets];
    
}

// Method to fetch the timeline tweets from the API
- (void) fetchTweets {
    
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.tweets = tweets;
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            for (Tweet *tweet in tweets) {
                NSString *text = tweet.text;
                NSLog(@"%@", text);
            }
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

// Method to configure the Table View's cell (Table View Data Source's required method)
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweet = self.tweets[indexPath.row];
    cell.userName.text = tweet.user.name;
    cell.userScreenName.text = tweet.user.screenName;
    cell.createdAtLabel.text = tweet.createdAtString;
    cell.tweetLabel.text = tweet.text;
    
    NSURL *profileImageURL = [NSURL URLWithString:tweet.user.profileImageURLString];
    [cell.profileImageView setImageWithURL:profileImageURL];
    cell.profileImageView.layer.masksToBounds = YES;
    cell.profileImageView.layer.cornerRadius = cell.profileImageView.bounds.size.width / 2;
    
    cell.retweetCountLabel.text = [NSString stringWithFormat:@"%i", tweet.retweetCount];
    cell.favoriteCountLabel.text = [NSString stringWithFormat:@"%i", tweet.favoriteCount];
    
    return cell;
}

// Method to find out the number of rows in Table View (Table View Data Source's required method)
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
