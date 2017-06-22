//
//  SavedGameCell.h
//  WordChallenge
//
//  Created by Nguyen on 9/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SavedGameCell : UITableViewCell {

	IBOutlet UILabel *labelGameLevel;
	IBOutlet UILabel *labelGameMode;
	IBOutlet UILabel *labelPlayerScore;
	IBOutlet UILabel *labelLastPlayed;
}

@property (nonatomic, retain) IBOutlet UILabel *labelGameMode;
@property (nonatomic, retain) IBOutlet UILabel *labelGameLevel;
@property (nonatomic, retain) IBOutlet UILabel *labelPlayerScore;
@property (nonatomic, retain) IBOutlet UILabel *labelLastPlayed;

@end
