//
//  MovieTableViewCell.h
//  rottentomatoes
//
//  Created by Rajeev Nayak on 6/6/14.
//  Copyright (c) 2014 jeev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;

@end
