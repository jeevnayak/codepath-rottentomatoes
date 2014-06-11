//
//  MoviesViewController.h
//  rottentomatoes
//
//  Created by Rajeev Nayak on 6/6/14.
//  Copyright (c) 2014 jeev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoviesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

typedef NS_ENUM(NSInteger, MoviesViewControllerType) {
    MoviesViewControllerTypeBoxOffice,
    MoviesViewControllerTypeDvd,
};

- (id)initWithType:(MoviesViewControllerType)type;

@end
