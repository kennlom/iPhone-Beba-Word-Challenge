//
//  GameModeController.h
//  WordChallenge
//
//  Created by Nguyen on 9/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GameModeController : UIViewController {

	UIButton *buttonContinueGame;

}

@property (nonatomic, retain) IBOutlet UIButton *buttonContinueGame;

- (IBAction) startGame: (id) sender;
- (IBAction) goBackToStartScreen;
- (IBAction) continueSavedGame;

@end