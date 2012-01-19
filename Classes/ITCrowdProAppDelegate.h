//
//  ITCrowdProAppDelegate.h
//  ITCrowdPro
//
//  Created by Sanchit Bareja on 3/29/11.
//  Copyright 2011 Nus High. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ITCrowdProAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UITabBarController *tabBarController;
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

