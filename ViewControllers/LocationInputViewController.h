//
//  LocationInputViewController.h
//  Trpn
//
//  Created by Keith Norman on 3/21/13.
//  Copyright (c) 2013 Trpn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationInputViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UISearchDisplayDelegate, UISearchBarDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;

@end
