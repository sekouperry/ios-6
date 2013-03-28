//
//  AutoCompleteCell.m
//  Trpn
//
//  Created by Keith Norman on 3/21/13.
//  Copyright (c) 2013 Trpn. All rights reserved.
//

#import "AutoCompleteCell.h"

@implementation AutoCompleteCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
