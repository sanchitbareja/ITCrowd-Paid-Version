//
//  flyersViewController.m
//  ITCrowd
//
//  Created by Sanchit Bareja on 2/17/11.
//  Copyright 2011 Nus High. All rights reserved.
//

#import "AboutUsController.h"


@implementation AboutUsController

// Override init to load the view using a nib file then perform additional customization that is not appropriate for viewDidLoad.
- (id)init{
    if (self = [super init]) {
        // Custom initialization
        self.tabBarItem.title = @"Info";
        self.tabBarItem.image = [UIImage imageNamed:@"info_icon_black_glossy_small.png"];
    }
    return self;
}

-(void)viewDidLoad{
	[super viewDidLoad];
	
//title of Navigation Bar	
	self.navigationItem.title = @"Information";
	self.navigationController.navigationBar.tintColor = [UIColor grayColor];

//add scrollViewMain to self.view	
	scrollViewMain = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 367)];
	scrollViewMain.delegate = self;
	scrollViewMain.maximumZoomScale = 10.0;
	scrollViewMain.minimumZoomScale = 1.0;// minimumZoomScale = 1.0 because imageView.frame is already made to fit within the view
	scrollViewMain.scrollEnabled = YES;
	scrollViewMain.userInteractionEnabled = YES;
	scrollViewMain.delaysContentTouches = NO;
	scrollViewMain.directionalLockEnabled = YES;
	
	imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"InfoBanner.jpg"]];
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth || UIViewAutoresizingFlexibleHeight );
	imageView.frame = CGRectMake(0, 0, 320, 950);
	
	[scrollViewMain addSubview:imageView];	
	[self.view addSubview:scrollViewMain];

}

- (void)dealloc {
	[scrollViewMain release];
	[imageView release];
	
    [super dealloc];
}

#pragma mark UIScrollViewDelegate methods
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
	return imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
	CGSize boundsSize = scrollViewMain.bounds.size;
	CGRect frameToCenter = imageView.frame;
	// center horizontally
	if (frameToCenter.size.width < boundsSize.width) {
		frameToCenter.origin.x = ((boundsSize.width-frameToCenter.size.width)/2);
	}
	else {
		frameToCenter.origin.x = 0;
	}
	// center vertically
	if (frameToCenter.size.height < boundsSize.height) {
		frameToCenter.origin.y = ((boundsSize.height-frameToCenter.size.height)/2);
	}
	else {
		frameToCenter.origin.y = 0;
	}
	
	imageView.frame = frameToCenter;
}


@end
