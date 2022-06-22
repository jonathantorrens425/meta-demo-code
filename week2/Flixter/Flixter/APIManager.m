//
//  APIManager.m
//  Flixter
//
//  Created by Jonathan Torrens on 6/21/22.
//

#import "APIManager.h"
#import "Movie.h"

@interface APIManager ()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation APIManager

-(void)fetchNowPlayingMovies:(void (^) (NSArray *movies, NSError *error))completion {
    
    // Create URL
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=698f6f697acc162544b28fb38128879b"];

    // Create Request
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];

    // Create Session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];

    // Create task
    NSURLSessionDataTask *task = [
        session dataTaskWithRequest:request
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
                completion(nil, error);
            }
            else {
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                NSArray *results = dataDictionary[@"results"];
                NSLog(results);
                
                
                NSMutableArray *moviesArray = [[NSMutableArray alloc] init];
                for(NSDictionary *movieDictionary in results) {
                    Movie *movie = [[Movie alloc] initWithDictionary:movieDictionary];
                    [moviesArray addObject:movie];
                }
                
                
                completion([NSArray arrayWithArray:moviesArray], nil);
            }

        }];
    [task resume];
    
}

@end
