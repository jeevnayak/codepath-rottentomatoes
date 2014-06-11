//
//  MoviesViewController.m
//  rottentomatoes
//
//  Created by Rajeev Nayak on 6/6/14.
//  Copyright (c) 2014 jeev. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "Movie.h"
#import "MovieDetailsViewController.h"
#import <UIImageView+AFNetworking.h>
#import <MBProgressHUD.h>

@interface MoviesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *networkErrorLabel;
@property (nonatomic, assign) MoviesViewControllerType type;
@property (nonatomic, strong) NSURL *smallPosterThumbnail;
@property (nonatomic, strong) NSArray *movies;

@end

@implementation MoviesViewController

// QUESTION: is this the right way to pass data to a view controller? or is it more standard to expose the type property as public so that the caller can set the property and then call the standard init?
- (id)initWithType:(MoviesViewControllerType)type {
    self = [super initWithNibName:@"MoviesViewController" bundle:nil];
    if (self) {
        self.title = @"Movies";
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // show a loading spinner and kick off the api request to rotten tomatoes
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadMoviesFromNetworkWithCompletionHandler:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

    // init the table view
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
        UINib *movieCellNib = [UINib nibWithNibName:@"MovieCell" bundle:nil];
    self.tableView.rowHeight = 110;
    [self.tableView registerNib:movieCellNib forCellReuseIdentifier:@"MovieCell"];

    // init the refresh control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];

    Movie *movie = self.movies[indexPath.row];
    cell.titleLabel.text = movie.title;
    cell.synopsisLabel.text = movie.synopsis;

    // fetch the poster image asynchronously
    [cell.posterView setImageWithURLRequest:[NSURLRequest requestWithURL:movie.smallPosterUrl] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        // fade in the image
        cell.posterView.image = image;
        cell.posterView.alpha = 0.0;
        [UIView animateWithDuration:0.5 animations:^{
            cell.posterView.alpha = 1.0;
        }];
    } failure:nil];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    Movie *movie = self.movies[indexPath.row];
    UIImageView *posterView = ((MovieCell *)[tableView cellForRowAtIndexPath:indexPath]).posterView;
    MovieDetailsViewController *vc = [[MovieDetailsViewController alloc] initWithMovie:movie smallPosterImage:posterView.image];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleRefresh:(UIRefreshControl *)refreshControl
{
    [self loadMoviesFromNetworkWithCompletionHandler:^{
        [refreshControl endRefreshing];
    }];
}

- (void)loadMoviesFromNetworkWithCompletionHandler:(void (^)(void))completionHandler
{
    // build a request for the rotten tomatoes api we want to hit
    NSString *urlString;
    switch (self.type) {
        case MoviesViewControllerTypeBoxOffice:
            urlString = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=g9au4hv6khv6wzvzgt55gpqs";
            break;
        case MoviesViewControllerTypeDvd:
            urlString = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=g9au4hv6khv6wzvzgt55gpqs";
            break;
        default:
            // QUESTION: is this the right way to handle invalid enum values?
            NSAssert(false, @"Invalid type %d", self.type);
    }
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    // kick off the api request
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError != nil) {
            // fade in network error message if it's hidden
            if (self.networkErrorLabel.hidden) {
                // QUESTION: is this the right way to fade in a hidden view?
                self.networkErrorLabel.hidden = NO;
                self.networkErrorLabel.alpha = 0.0;
                [UIView animateWithDuration:0.2 animations:^{
                    self.networkErrorLabel.alpha = 1.0;
                }];
            }
        } else {
            NSAssert(data != nil, @"Data missing even though request succeeded");

            // parse out the list of movies
            id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.movies = [Movie moviesWithArray:object[@"movies"]];

            // hide the network error and refresh the table view
            self.networkErrorLabel.hidden = YES;
            [self.tableView reloadData];
        }

        completionHandler();
    }];
}

@end
