//
//  Movie.h
//  rottentomatoes
//
//  Created by Rajeev Nayak on 6/7/14.
//  Copyright (c) 2014 jeev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *synopsis;
@property (nonatomic, strong) NSURL *smallPosterUrl;
@property (nonatomic, strong) NSURL *largePosterUrl;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSArray *)moviesWithArray:(NSArray *)array;

@end
