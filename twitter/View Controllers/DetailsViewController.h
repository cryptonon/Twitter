//
//  DetailsViewController.h
//  twitter
//
//  Created by Aayush Mani Phuyal on 7/1/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

//MARK: Protocol
@protocol DetailsViewControllerDelegate

- (void)didFavoriteOrRetweet:(Tweet *)tweet atIndexPath:(NSIndexPath *)indexPath;
- (void)didReply:(Tweet *)tweet;

@end

@interface DetailsViewController : UIViewController

// MARK: Properties
@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, strong) NSIndexPath *indexPathOfTweet;
@property (nonatomic, weak) id<DetailsViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
