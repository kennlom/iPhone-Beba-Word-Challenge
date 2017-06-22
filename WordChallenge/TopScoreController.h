//
//  TopScoreController.h
//  WordChallenge
//
//  Created by Nguyen on 10/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TopScoreController : UIViewController {

	NSURLConnection	*connection;
    NSMutableData	*requestData;
	
	NSMutableArray			*arrayTopScores;
	UIActivityIndicatorView *iconSpinner;
	UITableView				*tableTopScore;
	UIViewController		**previousView;
	
	IBOutlet UILabel		*labelLoadingFromServer;
	IBOutlet UILabel		*labelPleaseWait;
	IBOutlet UIImageView	*imageLoadingBackground;
	IBOutlet UIButton		*buttonRefresh;
	IBOutlet UIButton		*buttonGoBack;
	BOOL isLoading;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView	*iconSpinner;
@property (nonatomic, retain) IBOutlet UITableView				*tableTopScore;
@property (nonatomic, retain) IBOutlet UILabel					*labelLoadingFromServer;
@property (nonatomic, retain) IBOutlet UILabel					*labelPleaseWait;
@property (nonatomic, retain) IBOutlet UIImageView				*imageLoadingBackground;
@property (nonatomic, retain) IBOutlet UIButton					*buttonRefresh;
@property (nonatomic, retain) IBOutlet UIButton					*buttonGoBack;

- (IBAction) getTopScore;
- (IBAction) refreshScore;
- (IBAction) back;
- (void) getTopScoreAsync;
- (void) setAddressOfPreviousView:	(UIViewController **) view;
- (void) saveTopPlayersToDb:		(NSArray *) arrayTopPlayerScore;
- (BOOL) parseTopScoreXml:			(NSData *) xmlData;
- (void) loadCachedTopPlayerScore;

@end