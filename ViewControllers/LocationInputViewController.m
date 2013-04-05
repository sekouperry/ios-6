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
  [self.origin addTarget:self action:@selector(onEditingEnded:) forControlEvents:UIControlEventEditingDidEnd];
  
//  UITextField *origin = self.origin;
//  UITextField *destination = self.destination;
//  NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(origin, destination);
//  float halfScreen = self.view.bounds.size.width / 2 - 30;
//  NSString *layout = [NSString stringWithFormat:@"[origin(%f)]-[destination(==origin)]", halfScreen];
//  NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:layout
//                                                                 options:0
//                                                                 metrics:nil
//                                                                   views:viewsDictionary];
//  [self.view addConstraints:constraints];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark SearchBarDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
  NSLog(@"OH OK IN SHOULD DO STUFF %@", searchString);
  if(searchString.length > 3) {
    self.data = [NSMutableData data];
    NSString *query = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)searchString, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8));
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

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
  [tableView registerNib:[UINib nibWithNibName:@"LocationAutocompleteCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LocationAutocompleteCell"];
}




#pragma mark UITableViewDatasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSLog(@"CALLED thiS %d", self.suggestions.count);
  return self.suggestions.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"GETTING CELL");
  AutoCompleteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationAutocompleteCell"];
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

- (IBAction)onTouchUpInsideLocationField:(id)sender {
  self.originWidth.constant = 200.0;
  self.destinationWidth.constant = 60;
  [self.view setNeedsUpdateConstraints];
  [UIView animateWithDuration:0.3 animations:^{
    [self.view layoutIfNeeded];
  }];
}

-(IBAction)onEditingEnded:(id)sender {
  NSLog(@"EDITING ENDED");
  self.originWidth.constant = 60;
  self.destinationWidth.constant = 200;
  [self.view setNeedsUpdateConstraints];
  [UIView animateWithDuration:0.3 animations:^{
    [self.view layoutIfNeeded];
  }];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField {
  NSLog(@"AHOY THERE");
  NSInteger nextTag = textField.tag + 1;
  // Try to find next responder
  UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
  if (nextResponder) {
    // Found next responder, so set it.
    [nextResponder becomeFirstResponder];
  } else {
    // Not found, so remove keyboard.
    [textField resignFirstResponder];
  }
  return NO; // We do not want UITextField to insert line-breaks.
}
@end
