//
//  StartScreenController.h
//  WordChallenge
//
//  Created by Nguyen on 9/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartScreenController : UIViewController {

	UIButton	*buttonOLogo;
}

@property (nonatomic, retain) IBOutlet UIButton		*buttonOLogo;

- (IBAction) StartGame_Clicked:(id) sender;
- (IBAction) logoClicked;
- (IBAction) help;
- (IBAction) gotoTopScore;

@end