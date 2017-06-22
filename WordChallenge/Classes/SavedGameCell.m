//
//  SavedGameCell.m
//  WordChallenge
//
//  Created by Nguyen on 9/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SavedGameCell.h"


@implementation SavedGameCell
@synthesize labelPlayerScore, labelGameMode, labelGameLevel, labelLastPlayed;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	self.labelPlayerScore	= nil;
	self.labelLastPlayed	= nil;
	self.labelGameMode		= nil;
	self.labelGameLevel		= nil;
    [super dealloc];
}


@end
