//
//  TopScoreCell.h
//  WordChallenge
//
//  Created by Nguyen on 10/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TopScoreCell : UITableViewCell {

	IBOutlet UILabel *labelRank;
	IBOutlet UILabel *labelPlayerInfo;
	IBOutlet UILabel *labelWordsFound;
	IBOutlet UILabel *labelPlayerScore;
	IBOutlet UILabel *labelPlayerDesc;
}

@property (nonatomic, retain) IBOutlet UILabel *labelRank;
@property (nonatomic, retain) IBOutlet UILabel *labelPlayerInfo;
@property (nonatomic, retain) IBOutlet UILabel *labelWordsFound;
@property (nonatomic, retain) IBOutlet UILabel *labelPlayerScore;
@property (nonatomic, retain) IBOutlet UILabel *labelPlayerDesc;

@end
