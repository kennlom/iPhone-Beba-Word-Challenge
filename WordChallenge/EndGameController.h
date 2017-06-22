//
//  EndGameController.h
//  WordChallenge
//
//  Created by Nguyen on 9/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EndGameController : UIViewController {
		
	UILabel *labelPlayerScore;
	UILabel *labelGameLevel;
	UILabel *labelGameMode;
	UILabel *labelWordsFound;
	UILabel *labelWordsMissed;
	UILabel *labelWordsSkipped;
	UILabel *labelBonusWords;
	UILabel *labelWordsCompleted;
	UILabel *labelCustomMessage;
	UILabel *labelEndTitle;
	
	IBOutlet UIButton *buttonPostScore;
	IBOutlet UIButton *buttonTopScore;
}

@property (nonatomic, retain) IBOutlet UILabel	*labelEndTitle;
@property (nonatomic, retain) IBOutlet UILabel	*labelWordsCompleted;
@property (nonatomic, retain) IBOutlet UILabel	*labelCustomMessage;
@property (nonatomic, retain) IBOutlet UILabel	*labelPlayerScore;
@property (nonatomic, retain) IBOutlet UILabel	*labelGameMode;
@property (nonatomic, retain) IBOutlet UILabel	*labelGameLevel;
@property (nonatomic, retain) IBOutlet UILabel	*labelWordsFound;
@property (nonatomic, retain) IBOutlet UILabel	*labelWordsMissed;
@property (nonatomic, retain) IBOutlet UILabel	*labelWordsSkipped;
@property (nonatomic, retain) IBOutlet UILabel	*labelBonusWords;

- (IBAction) gotoTopScore;
- (IBAction) goBackToStartScreen;
- (IBAction) postScoreOnline;
//- (IBAction) test;

@end