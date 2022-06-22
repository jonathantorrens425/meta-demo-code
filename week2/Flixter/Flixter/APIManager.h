//
//  APIManager.h
//  Flixter
//
//  Created by Jonathan Torrens on 6/21/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject

-(void)fetchNowPlayingMovies:(void (^) (NSArray *movies, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
