//
//  VideoPlayViewController.m
//  Flixter
//
//  Created by Jonathan Torrens on 6/8/22.
//

#import "VideoPlayViewController.h"
#import "WebKit/WKWebView.h"

@interface VideoPlayViewController ()

@property (weak, nonatomic) IBOutlet WKWebView *webView;

@end

@implementation VideoPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *movieId = self.movieInfo[@"id"];
    NSString *videosURLString =  [NSString stringWithFormat: @"https://api.themoviedb.org/3/movie/%@/videos?api_key=698f6f697acc162544b28fb38128879b", movieId];

    NSURL *videoURL = [NSURL URLWithString:videosURLString];

    NSURLRequest *request = [NSURLRequest requestWithURL:videoURL];

    // Create Session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];

    // Create task
    NSURLSessionDataTask *task = [
        session dataTaskWithRequest:request
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil) {
                NSLog(@"%@", error);
            }
            else {
                NSDictionary *dataDictionary = [
                    NSJSONSerialization JSONObjectWithData:data
                    options:NSJSONReadingMutableContainers error:nil
                ];

                NSArray *results = dataDictionary[@"results"];
                NSDictionary *firstVideo = results[0];
                NSString *key = firstVideo[@"key"];
                NSString *youtubeURLString = [NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@", key];

                

                NSURL *youtubeURL = [NSURL URLWithString:youtubeURLString];
                NSURLRequest *youTubeRequest = [NSURLRequest requestWithURL:youtubeURL];

                [self.webView loadRequest:youTubeRequest];

            }
        }];
    [task resume];


}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
