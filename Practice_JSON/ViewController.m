//
//  ViewController.m
//  Practice_JSON
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, NSURLSessionDelegate,
NSURLSessionDownloadDelegate> {
    
    NSMutableArray *mutableArray;
    NSString *stringForStopName;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


#pragma mark -

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    
    NSURL *url = [NSURL URLWithString:@"http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=a3e2b221-75e0-45c1-8f97-75acbd43d613"];
    NSURLSessionConfiguration *urlSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:urlSessionConfiguration
                                                             delegate:self
                                                        delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDownloadTask *urlSessionDownloadTask = [urlSession downloadTaskWithURL:url];
    [urlSessionDownloadTask resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Init

- (instancetype)initWithCoder:(NSCoder *)coder {
    
    self = [super initWithCoder:coder];
    if (self) {
        
        mutableArray = [NSMutableArray new];
    }
    
    return self;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    return [mutableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"Basic Cell"];
    for (int i = 0; i < [mutableArray count]; i++) {
        [[tableViewCell textLabel] setText:[mutableArray objectAtIndex:[indexPath row]]];
    }
    
    return tableViewCell;
}


#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    
    NSData *data = [NSData dataWithContentsOfURL:location];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary *dictionaryResults in dictionary[@"result"][@"results"]) {
        NSString *stringName = [dictionaryResults objectForKey:@"A_Name_Ch"];
        [mutableArray addObject:stringName];
    }
    
    [session finishTasksAndInvalidate];
    [downloadTask cancel];
    [_tableView reloadData];
}

@end
