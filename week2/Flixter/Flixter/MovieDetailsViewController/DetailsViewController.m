//
//  DetailsViewController.m
//  Flixter
//
//  Created by Jonathan Torrens on 6/4/22.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "VideoPlayViewController.h"


@interface DetailsViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIImageView *backdropImageView;

@property (weak, nonatomic) IBOutlet UIImageView *movieImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;

@end

@implementation DetailsViewController

// 5: On viewDidLoad, use the information I received to populate my views.
- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *title = self.movieInfo[@"title"];
    NSString *synopsis = self.movieInfo[@"overview"];

    // Set text:
    self.titleLabel.text = title;
    self.synopsisLabel.text = synopsis;
    self.releaseDateLabel.text = self.movieInfo[@"release_date"];


    // Backdrop Image
    NSString *backdropPath = self.movieInfo[@"backdrop_path"];
    NSString *backdropImageURLString = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w500%@", backdropPath];
    NSURL *backdropImageURL = [NSURL URLWithString:backdropImageURLString];
//    NSURLRequest *backdropRequest = [NSURLRequest requestWithURL:backdropImageURL];

    // Fetch the movie image:
    [self.backdropImageView setImageWithURL:backdropImageURL];
    
    
    // Poster Image
    NSString *posterPath = self.movieInfo[@"poster_path"];
    NSString *imageURLString = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w200%@", posterPath];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];

    // Fetch the movie image:
    [self.movieImageView
     setImageWithURLRequest:request
     placeholderImage:nil
     success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {

        self.movieImageView.image = image;
        [self.movieImageView setNeedsLayout];

    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
}


- (IBAction)moviePosterWasTapped:(UITapGestureRecognizer *)sender {
    NSLog(@"Movie poster was tapped");
}





#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    NSDictionary *movieInfo = self.movieInfo;
    VideoPlayViewController *videoVC = [segue destinationViewController];
    videoVC.movieInfo = movieInfo;

}


@end
