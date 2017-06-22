//
//  NextLevelController.h
//  WordChallenge
//
//  Created by Nguyen on 9/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NextLevelController : UIViewController {

	UILabel *labelLevel;
	UILabel	*labelMessage;
	UILabel *labelLuckyNumber;
}

@property (nonatomic, retain) IBOutlet UILabel	*labelLevel;
@property (nonatomic, retain) IBOutlet UILabel	*labelMessage;
@property (nonatomic, retain) IBOutlet UILabel	*labelLuckyNumber;


- (IBAction) startNextLevel;
- (IBAction) saveGame;
- (NSMutableDictionary *) prepareGameDataDictionary;
- (void) saveGameDataToDb: (NSMutableDictionary *) gameDataDictionary: (int) gameId;

@end