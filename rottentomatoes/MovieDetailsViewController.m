//
//  MovieDetailsViewController.m
//  rottentomatoes
//
//  Created by Rajeev Nayak on 6/7/14.
//  Copyright (c) 2014 jeev. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface MovieDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (nonatomic, strong) Movie *movie;
@property (nonatomic, strong) UIImage *smallPosterImage;

@end

@implementation MovieDetailsViewController

- (id)initWithMovie:(Movie *)movie smallPosterImage:(UIImage *)image
{
    self = [super initWithNibName:@"MovieDetailsViewController" bundle:nil];
    if (self) {
        self.title = movie.title;
        self.movie = movie;
        self.smallPosterImage = image;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // set the low res poster image immediately and fetch the high res one
    [self.posterView setImageWithURLRequest:[NSURLRequest requestWithURL:self.movie.largePosterUrl] placeholderImage:self.smallPosterImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.posterView.image = image;
    } failure:nil];

    self.titleLabel.text = self.movie.title;
    self.synopsisLabel.text = self.movie.synopsis;
    [self.synopsisLabel sizeToFit];

    // recompute the size of the background view now that we know the height of the synopsis label
    CGRect newBackgroundViewFrame = self.backgroundView.frame;
    // note: the +200 adds padding to the bottom so that the background extends past the bottom of the label. we want some padding below the label, plus we want the background to extend past the end of the scroll view to cover the overscroll region.
    newBackgroundViewFrame.size.height = self.synopsisLabel.frame.origin.y + self.synopsisLabel.frame.size.height + 200;
    self.backgroundView.frame = newBackgroundViewFrame;

    // now set the content height of the scroll view to the background view's y-offset+height
    // note: the -180 balances out most of the extra height we added to the background view above (now the actual bottom of the scroll view will be 20 pts past the last label, and the remaining 180 pts of the background view will extend past the end to cover the overscroll region)
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, self.backgroundView.frame.origin.y + self.backgroundView.frame.size.height - 180)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
