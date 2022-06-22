//
//  Movie.m
//  Flixter
//
//  Created by Jonathan Torrens on 6/21/22.
//

#import "Movie.h"

@implementation Movie

- (id) initWithTitle: (NSString *)title posterPath: (NSString *)posterPath overView: (NSString *)overview {
    self = [super init];
    self.title = title;
    self.posterPath = posterPath;
    self. overview = overview;

    return self;
}

- (id)initWithDictionary: (NSDictionary *)dictionary {
    self = [self init];
    
    NSString *title = dictionary[@"title"];
    NSString *overview = dictionary[@"overview"];
    NSString *posterPath = dictionary[@"poster_path"];

    self.title = title;
    self.overview = overview;
    self.posterPath = posterPath;
        
    return self;
}


@end
