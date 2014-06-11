//
//  MovieDetailsViewController.h
//  rottentomatoes
//
//  Created by Rajeev Nayak on 6/7/14.
//  Copyright (c) 2014 jeev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface MovieDetailsViewController : UIViewController

- (id)initWithMovie:(Movie *)movie smallPosterImage:(UIImage *)image;

@end
