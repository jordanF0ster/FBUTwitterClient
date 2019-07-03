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
#import "ComposeViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tweetsArray;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self; // view controller is the data source
    self.tableView.delegate = self; // view controller is the delegate

    [self fetchTweets];
    
    // Initialize a UIRefreshControl
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
}

- (void)fetchTweets {
    // Get timeline
    // creates an instance on first call, otherwise grabs the same instance
    // the completion block allows for you to continue running the app even if request fails
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSMutableArray *tweets, NSError *error) {
        if (tweets) {
            self.tweetsArray = tweets; // stores data passed by completion handler
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            NSLog(@"%lu", self.tweetsArray.count);
            //            for (Tweet *tweetObj in tweets) {
            //                NSString *text = tweetObj.text;
            //                NSLog(@"%@", text);
            //            }
            [self.tableView reloadData]; // calls numberOfRows and cellForRowAt
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UINavigationController *navigationController = [segue destinationViewController];
    ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
    composeController.delegate = self;
}



// reutrns an instance of the custom cell with the reuse identifier
// with its elements populared with data at the index path
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweet = self.tweetsArray[indexPath.row];
    
    cell.tweet = tweet;
    [cell refreshData];
    
    cell.userName.text = tweet.user.name;
    cell.screenName.text = tweet.user.screenName;
    cell.tweetText.text = tweet.text;
    
    NSString *fullProfileImageURLString = tweet.user.profileImage;
    NSURL *profileImageURL = [NSURL URLWithString:fullProfileImageURLString];
    cell.profilePicture.image = nil;
    [cell.profilePicture setImageWithURL:profileImageURL];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweetsArray.count;
}

// Makes a network request to get updated data
// Updates the tableView with the new data
// Hides the RefreshControl
- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    
    [self fetchTweets];
    
    // Tell the refreshControl to stop spinning
    [refreshControl endRefreshing];
}


- (void)didTweet:(nonnull Tweet *)tweet {
    
    //[self fetchTweets];
    [self.tweetsArray insertObject:tweet atIndex:0];
    NSLog(@"COUNTTTTT22222222222    : %lu", self.tweetsArray.count);
    [self.tableView reloadData];
    
}
- (IBAction)logoutUser:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    [[APIManager shared] logout];
}


@end
