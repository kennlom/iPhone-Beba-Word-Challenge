//
//  HelpController.h
//  WordChallenge
//
//  Created by Nguyen on 10/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HelpController : UIViewController {

	UIButton *buttonBack;
}

@property (nonatomic, retain) IBOutlet UIButton *buttonBack;


- (IBAction) back;


@end