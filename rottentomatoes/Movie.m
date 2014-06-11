//
//  Movie.m
//  rottentomatoes
//
//  Created by Rajeev Nayak on 6/7/14.
//  Copyright (c) 2014 jeev. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.title = dictionary[@"title"];
        self.synopsis = dictionary[@"synopsis"];
        self.smallPosterUrl = [NSURL URLWithString:dictionary[@"posters"][@"profile"]];
        self.largePosterUrl = [NSURL URLWithString:dictionary[@"posters"][@"original"]];
    }

    return self;
}

+ (NSArray *)moviesWithArray:(NSArray *)array {
    NSMutableArray *movies = [[NSMutableArray alloc] init];

    for (NSDictionary *dictionary in array) {
        Movie *movie = [[Movie alloc] initWithDictionary:dictionary];
        [movies addObject:movie];
    }
    
    return movies;
}

@end
