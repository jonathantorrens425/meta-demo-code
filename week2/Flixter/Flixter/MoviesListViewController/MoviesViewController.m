//
//  MoviesViewController.m
//  Flixter
//
//  Created by Jonathan Torrens on 6/4/22.
//

#import "MoviesViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MovieTableViewCell.h"
#import "DetailsViewController.h"
#import "Movie.h"

#import "APIManager.h"

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@property (strong, nonatomic) UISearchController *searchController;
//@property (strong, nonatomic) NSArray *results;
//@property (strong, nonatomic) NSArray *filteredResults;

@property (strong, nonatomic) NSArray *movies;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    self.tableView.rowHeight = 250;


    self.tableView.rowHeight = UITableViewAutomaticDimension;

    // Refresh Control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];

    // Search Controller
    // Initializing with searchResultsController set to nil means that
    // searchController will use this view controller to display the search results
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;

    // If we are using this same view controller to present the results
    // dimming it out wouldn't make sense. Should probably only set
    // this to yes if using another controller to display the search results.
    self.searchController.dimsBackgroundDuringPresentation = NO;

    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;

    // Sets this view controller as presenting view controller for the search interface
    self.definesPresentationContext = YES;

    APIManager *apiManager = [[APIManager alloc] init];
    
    [apiManager fetchNowPlayingMovies: ^(NSArray * _Nonnull movies, NSError * _Nonnull error) {
        self.movies = movies;
        [self.tableView reloadData];
    }];
    
}


// MARK: Search Controller Methods:
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {

    NSString *searchText = searchController.searchBar.text;
    if (searchText) {
        if (searchText.length != 0) {
            NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
                return [evaluatedObject[@"title"] containsString:searchText];
            }];
//            self.filteredResults = [self.results filteredArrayUsingPredicate:predicate];
        }
        else {
//            self.filteredResults = self.results;
        }

        [self.tableView reloadData];

    }

}


// MARK: Table View Methods:
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    __weak MovieTableViewCell *movieCell = [tableView dequeueReusableCellWithIdentifier: @"MovieTableViewCell"];

//    NSDictionary *movieInfo = self.filteredResults[indexPath.row];

    Movie *movie = [[Movie alloc] initWithDictionary:movieInfo];
        
    NSString *imageURLString = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w200%@", movie.posterPath];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];

    movieCell.titleLabel.text = movie.title;
    movieCell.synopsisLabel.text = movie.overview;

    movieCell.movieImageView.image = nil;
    [movieCell.imageView
     setImageWithURLRequest:request
     placeholderImage: nil
     success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {

        movieCell.movieImageView.image = image;
        [movieCell setNeedsLayout];

    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];

    return movieCell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

#pragma mark - Refresh Control
- (void)beginRefresh: (UIRefreshControl *) refreshControl {
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=698f6f697acc162544b28fb38128879b"];

    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               self.results = dataDictionary[@"results"];
               [self.tableView reloadData];
               [refreshControl endRefreshing];
           }
       }];
    [task resume];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // 1 Get indexpath
    NSIndexPath *indexPath  = [self.tableView indexPathForCell:sender];
    
    // 2. Get movie dictionary
    NSDictionary *dataToPass = self.results[indexPath.row];
    
    // 3. Get reference to destination view controller
    DetailsViewController *detailsVC = [segue destinationViewController];

    // 4: Pass the local dictionary to the view controller property
    detailsVC.movieInfo = dataToPass;
    
}

@end
