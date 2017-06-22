//
//  PostScoreController.h
//  WordChallenge
//
//  Created by Nguyen on 10/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PostScoreController : UIViewController {

	IBOutlet UIButton					*buttonPostScore;
	IBOutlet UITextField				*textName;
	IBOutlet UITextField				*textMessage;
	IBOutlet UILabel					*labelPlayerScore;
	IBOutlet UILabel					*labelPlayerStats;
	IBOutlet UIActivityIndicatorView	*iconSpinner;
	
	NSURLConnection	*connection;
    NSMutableData	*requestData;

}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *iconSpinner;
@property (nonatomic, retain) IBOutlet UILabel	*labelPlayerScore;
@property (nonatomic, retain) IBOutlet UILabel	*labelPlayerStats;

- (IBAction) postScore;
- (IBAction) close;
- (void) postScoreAsync;
//- (void) displayAlert: (NSString*) text;

@end