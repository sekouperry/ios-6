//
//  LocationInputViewController.m
//  Trpn
//
//  Created by Keith Norman on 3/21/13.
//  Copyright (c) 2013 Trpn. All rights reserved.
//

#import "LocationInputViewController.h"
#import "AutoCompleteCell.h"

@interface LocationInputViewController ()

@property (nonatomic, strong) NSMutableArray *suggestions;
@property (nonatomic, strong) NSMutableData *data;

@end

@implementation LocationInputViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.suggestions = [NSMutableArray array];
  self.data = [NSMutableData data];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark SearchBarDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
  if(self.searchBar.text.length > 2) {
    self.data = [NSMutableData data];
    NSString *query = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self.searchBar.text, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8));
    // https://maps.googleapis.com/maps/api/place/autocomplete/json?input=San+Fran&key=AIzaSyAMbbvWwdvJLyxvynQVLPPdTzAFWjQXBCQ&sensor=false
    NSMutableString *url = [NSMutableString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&sensor=false&key=AIzaSyAMbbvWwdvJLyxvynQVLPPdTzAFWjQXBCQ", query];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    NSLog(@"WOULD HIT URL %@", url);
    [NSURLConnection connectionWithRequest:request delegate:self];
  }
  return NO;
}

-(void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
  NSLog(@"YEAH DID HIDE THAT SHIT");
}




#pragma mark UITableViewDatasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSLog(@"CALLED thiS");
  return self.suggestions.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"GETTING CELL");
  AutoCompleteCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"LocationAutocompleteCell"];
  if(!cell) {
    NSLog(@"NO CELL???!!!");
  }
  cell.label.text = [[self.suggestions objectAtIndex:indexPath.row] objectForKey:@"description"];
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"SELECTED ROW");
}

#pragma mark NSURLConnectionDataDelegate

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  [self.data appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
  NSError *error;
  NSDictionary *json = [NSJSONSerialization
                        JSONObjectWithData:self.data
                        options:NSJSONReadingMutableLeaves
                        error:&error];
  self.suggestions = [json objectForKey:@"predictions"];
  [self.searchDisplayController.searchResultsTableView reloadData];
  NSLog(@"wanting to reload table %d", self.suggestions.count);
}

@end
