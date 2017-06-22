//
//  TopScoreCell.m
//  WordChallenge
//
//  Created by Nguyen on 10/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TopScoreCell.h"


@implementation TopScoreCell

@synthesize labelRank, labelPlayerDesc, labelWordsFound, labelPlayerScore, labelPlayerInfo;

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
	self.labelRank			= nil;
	self.labelPlayerInfo	= nil;
	self.labelWordsFound	= nil;
	self.labelPlayerScore	= nil;
	self.labelPlayerDesc	= nil;
    [super dealloc];
}


@end
