//
//  WinnerController.h
//  WordChallenge
//
//  Created by Nguyen on 10/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface WinnerController : UIViewController <AVAudioPlayerDelegate> {

	NSTimer *timerPlayLoop;
	UILabel *labelCompleted;
	UILabel *labelScore;
	AVAudioPlayer *audioPlayer;
}

@property (nonatomic, retain) NSTimer *timerPlayLoop;
@property (nonatomic, retain) IBOutlet UILabel *labelScore;
@property (nonatomic, retain) IBOutlet UILabel *labelCompleted;

- (IBAction) goBackToStartScreen;
- (void) playLoopedSound;
@end
