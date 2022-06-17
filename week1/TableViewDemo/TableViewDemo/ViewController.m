//
//  ViewController.m
//  TableViewDemo
//
//  Created by Jonathan Torrens on 6/15/22.
//

#import "ViewController.h"
#import "TitleCellTableViewCell.h"
#import "DetailsViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *results;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [UIAlertController alertControllerWithTitle:@"" message:<#(nullable NSString *)#> preferredStyle:<#(UIAlertControllerStyle)#>]
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 150;
    // 1. Create URL
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=698f6f697acc162544b28fb38128879b"];
    
    // 2. Create Request
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 3. Create Session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    
    // 4. Create our session task
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *dataDictionary = [
            NSJSONSerialization JSONObjectWithData:data
            options:NSJSONReadingMutableContainers error:nil
        ];

        NSLog(@"%@", dataDictionary);
        self.results = dataDictionary[@"results"];
        
        [self.tableView reloadData];
        
    }];
    
    // 5.
    [task resume];
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;

}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TitleCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:    @"TitleCellTableViewCell"];
    
    cell.titleLabel.text = self.results[indexPath.row][@"title"];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    TitleCellTableViewCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *dataToPass = self.results[indexPath.row];
    
    DetailsViewController *detailsVC = [segue destinationViewController];
    detailsVC.movieInfo = dataToPass;
    
    
}

@end
