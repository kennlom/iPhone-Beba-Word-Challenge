//
//  PausedController.h
//  WordChallenge
//
//  Created by Nguyen on 10/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PausedController : UIViewController {

	UILabel *labelFoundWord6;
	UILabel *labelFoundWord5;
	UILabel *labelFoundWord4;
	UILabel *labelFoundWord3;
	UILabel *labelWordsRemaining;
	UILabel *labelGamePaused;
	UILabel *labelGameRunning;
}

@property (nonatomic, retain) IBOutlet UILabel *labelFoundWord6;
@property (nonatomic, retain) IBOutlet UILabel *labelFoundWord5;
@property (nonatomic, retain) IBOutlet UILabel *labelFoundWord4;
@property (nonatomic, retain) IBOutlet UILabel *labelFoundWord3;
@property (nonatomic, retain) IBOutlet UILabel *labelWordsRemaining;
@property (nonatomic, retain) IBOutlet UILabel *labelGamePaused;
@property (nonatomic, retain) IBOutlet UILabel *labelGameRunning;


- (IBAction) back;
- (IBAction) resumeGame;

@end


