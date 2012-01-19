//
//  uploadFlyersViewController.m
//  ITCrowd
//
//  Created by Sanchit Bareja on 2/17/11.
//  Copyright 2011 Nus High. All rights reserved.
//

#import "UploadFlyersViewController.h"

@implementation UploadFlyersViewController

- (id)init{
    if (self = [super init]) {
        // Custom initialization
		self.tabBarItem.title = @"Flyers";
        self.tabBarItem.image = [UIImage imageNamed:@"flyers.png"];
		
    }
	
	// Obtain Data for NSArray	
	photoURLs = [[NSMutableArray alloc] init];
	photoNames = [[NSMutableArray alloc] init];
	dataSourcePhotoNames = [[NSMutableArray alloc] init];
	dataSourcePhotoURLs = [[NSMutableArray alloc] init];
	photoURLsIcons = [[NSMutableArray alloc] init];
	dataSourcePhotoURLsIcons = [[NSMutableArray alloc] init];
	
	urlBaseString = [NSString stringWithFormat:@"http://www.flypn.com/itcrowd/app/webroot/uploadedstuff/"];
	urlBaseStringIcons = [NSString stringWithFormat:@"http://www.flypn.com/itcrowd/app/webroot/uploadedstuff/"];
	
	//add photo names and formuate URLs to fetch photo from
	
	//parse XML file to get photoNames and photoURLs
	MyXMLParser *parser = [[MyXMLParser alloc] init];
	[parser parse:@"http://www.flypn.com/itcrowd/app/webroot/uploadedstuff/ITShowData/flyers.xml"];
	
	//loop to add parser results to photoNames and photoURLs
	for (int x=0; x<[parser.results count]; x++) {
		[photoNames addObject:[parser.results objectAtIndex:x]];
		[dataSourcePhotoNames addObject:[parser.results objectAtIndex:x]];
		[photoURLs addObject:[urlBaseString stringByAppendingString:[[[photoNames objectAtIndex:x] stringByReplacingOccurrencesOfString:@" " withString:@"%20"] stringByAppendingString:@".jpg"]]];
		[dataSourcePhotoURLs addObject:[urlBaseString stringByAppendingString:[[[photoNames objectAtIndex:x] stringByReplacingOccurrencesOfString:@" " withString:@"%20"] stringByAppendingString:@".jpg"]]];
		[photoURLsIcons addObject:[urlBaseStringIcons stringByAppendingString:[[[photoNames objectAtIndex:x] stringByReplacingOccurrencesOfString:@" " withString:@"%20"] stringByAppendingString:@"_tn.jpg"]]];
		[dataSourcePhotoURLsIcons addObject:[urlBaseStringIcons stringByAppendingString:[[[photoNames objectAtIndex:x] stringByReplacingOccurrencesOfString:@" " withString:@"%20"] stringByAppendingString:@"_tn.jpg"]]];
	}
	
	[parser release];
	
    return self;
}

- (void)viewDidLoad{
	[super viewDidLoad];
	
	//title of Navigation Bar	
	self.navigationItem.title = @"Flyers";
	self.navigationController.navigationBar.tintColor = [UIColor grayColor];
	
	//UITabBarButton left and right set up
	
	//right
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(showCameraViewController)];
		self.navigationItem.rightBarButtonItem = cameraButton;
		[cameraButton release];		
	}
	
	//left
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
		UIBarButtonItem *uploadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showLibrary)];
		self.navigationItem.leftBarButtonItem = uploadButton;
		[uploadButton release];
	}
	
	//tableOfFlyers set up	
	tableOfFlyers = [[UITableView alloc] initWithFrame:CGRectMake(0,0,320,367) style:UITableViewStylePlain];
	tableOfFlyers.delegate = self;
	tableOfFlyers.dataSource = self;
	tableOfFlyers.rowHeight = 100; 
	
	[self.view addSubview:tableOfFlyers];
	
	//search bar set up
	
	sBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0,320,30)];
	sBar.delegate = self;
	sBar.placeholder = @"Search here (e.g. Laptops)";
	sBar.tintColor = [UIColor grayColor];
	tableOfFlyers.tableHeaderView = sBar;
	
	//hide search bar underneath navigation bar initially.
	tableOfFlyers.contentOffset = CGPointMake(0, sBar.frame.size.height);
	
}

- (void)dealloc {
	[tableOfFlyers release];
	[dataSourcePhotoURLs release];
	[dataSourcePhotoNames release];
	[photoURLs release];
    [photoNames release];
	[photoURLsIcons release];
	[dataSourcePhotoURLsIcons release];
	
	//dont need to release progressView and trackUploadPogress as they are handled below
	
	[imageTitle release];
	[imageToBeUploaded release];
	
    [super dealloc];
}

#pragma mark UISearchBar delegate methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	// only show the status bar's cancel button while in edit mode
	[sBar setShowsCancelButton:YES animated:YES];
	sBar.autocorrectionType = UITextAutocorrectionTypeNo;
	// flush the previous search content
	sBar.text = @"";
	//	[photoNames removeAllObjects];
	//	[photoURLs removeAllObjects];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	sBar.showsCancelButton = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	[photoNames removeAllObjects];// remove all data that belongs to previous search
	[photoURLs removeAllObjects];// remove all data that belongs to previous search
	[photoURLsIcons removeAllObjects];// remove all data that belongs to previous search 
	if([searchText isEqualToString:@""]||searchText==nil){
		[tableOfFlyers reloadData];
		//		return;
	}
	NSInteger counter = 0;
	NSInteger counter2 = 0;
	for(NSString *name in dataSourcePhotoNames)
	{
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
		NSRange r = [[name lowercaseString] rangeOfString:[searchText lowercaseString]];
		if(r.location != NSNotFound){
			[photoNames addObject:[dataSourcePhotoNames objectAtIndex:counter]];
			[photoURLs addObject:[dataSourcePhotoURLs objectAtIndex:counter]];
			[photoURLsIcons addObject:[dataSourcePhotoURLsIcons objectAtIndex:counter]];
			
			counter2++;
		}
		counter++;
		
		[pool release];
		
		[tableOfFlyers reloadData];
	}
	
	[tableOfFlyers reloadData];
	
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
	// if a valid search was entered but the user wanted to cancel, bring back the main list content
	[photoNames removeAllObjects];
	[photoNames addObjectsFromArray:dataSourcePhotoNames];
	[photoURLs removeAllObjects];
	[photoURLs addObjectsFromArray:dataSourcePhotoURLs];
	[photoURLsIcons removeAllObjects];
	[photoURLsIcons addObjectsFromArray:dataSourcePhotoURLsIcons];
	@try{
		[tableOfFlyers reloadData];
	}
	@catch(NSException *e){
		
	}
	[sBar setShowsCancelButton:NO animated:YES];
	[sBar resignFirstResponder];
}

// called when Search (in our case "Done") button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
	[searchBar resignFirstResponder];
}

#pragma mark Selector Methods for camera and photo library

-(void) showCameraViewController
{
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	picker.delegate = self;
	[self presentModalViewController:picker animated:YES];
}

-(void) showLibrary
{
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	picker.delegate = self;
	[self presentModalViewController:picker animated:YES];
}

#pragma mark methods to upload images on seperate thread

- (void)uploadImage:(UIImage *)imageToUpload {
	[self doUploadOfImage:imageToUpload];
	//	[NSThread detachNewThreadSelector:@selector(doUploadOfImage:) toTarget:self withObject:(UIImage *)imageToUpload];
}

- (void)doUploadOfImage:(UIImage *)imageToUpload {
	//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	/*
	 turning the image into a NSData object
	 getting the image back out of the UIImageView
	 setting the quality to 0.9
	 */
	NSData *imageData = UIImageJPEGRepresentation(imageToUpload, 0.9);
	// setting up the URL to post to
	NSString *urlString = @"http://www.flypn.com/itcrowd/app/webroot/uploadedstuff/iphoneuploads/upload.php";
	
	// setting up the request object now
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
	/*
	 add some header info now
	 we always need a boundary when we post a file
	 also we need to set the content type
	 
	 You might want to generate a random boundary.. this is just the same
	 as my output from wireshark on a valid html post
	 */
	NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	/*
	 now lets create the body of the post
	 */
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@.jpg\"\r\n",imageTitle.text] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:imageData]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
	
	// now lets make the connection to the web
	//	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	//	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
	trackUploadProgress = [[UIAlertView alloc] initWithTitle:@"Upload in progress" 
													 message:nil 
													delegate:nil 
										   cancelButtonTitle:nil 
										   otherButtonTitles:nil];
	progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
	progressView.frame = CGRectMake(12.0, 60.0, 260.0, 25.0);
	progressView.progress = 0.00;
	[trackUploadProgress addSubview:progressView];
	
	
	[trackUploadProgress show];
	[trackUploadProgress release];
	[progressView release];
	
	//	NSLog(@"%@",returnString);
	
	//	[pool release];
}

#pragma mark NSURLConnection delegate methods (using NSURLConnection means we are bound to to delegate methods)

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
	float progressValue = [[NSNumber numberWithInteger:totalBytesWritten] floatValue]/[[NSNumber numberWithInteger:totalBytesExpectedToWrite] floatValue];
	
	progressView.progress = progressValue;
	
	if (progressValue == 1.0) {
		
		//dismiss the trackUploadProgress alert that was initiated after NSURLConnection was called
		[trackUploadProgress dismissWithClickedButtonIndex:0 animated:YES];
		
		UIAlertView *uploadSuccess = [[UIAlertView alloc] initWithTitle:@"Upload Successful!" 
																message:@"Your image has been uploaded successfully!"
															   delegate:nil 
													  cancelButtonTitle:@"Done" 
													  otherButtonTitles:nil];
		[uploadSuccess show];
		[uploadSuccess release];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		
	}
}

#pragma mark UITextFieldDelegate methods
/*
 - (void)textFieldDidBeginEditing:(UITextField *)textField{
 //show keyboard as soon as textfield is pressed
 [imageTitle becomeFirstResponder];
 }
 */
- (void)textFieldDidEndEditing:(UITextField *)textField{
	[textField resignFirstResponder];
}

#pragma mark UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (buttonIndex == 1) {
		[self uploadImage:imageToBeUploaded];
	}
}

#pragma mark Image Picker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	//Do whatever you want to do with the image here
	//The image can be accessed like this:
	imageToBeUploaded = nil;
	imageToBeUploaded = (UIImage*) [info valueForKey:UIImagePickerControllerOriginalImage];
	[imageToBeUploaded retain];
	
	//show alert view to get title of picture to be uploaded
	UIAlertView *prompt = [[UIAlertView alloc] initWithTitle:@"Image Title" 
													 message:@"\n\n\n" // IMPORTANT
													delegate:self 
										   cancelButtonTitle:@"Cancel" 
										   otherButtonTitles:@"Upload", nil];
	
	imageTitle = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 50.0, 260.0, 40.0)];
	imageTitle.delegate = self;
	imageTitle.backgroundColor = [UIColor whiteColor];
	imageTitle.placeholder = @"Image Title";
	imageTitle.font = [UIFont systemFontOfSize:24];
	imageTitle.autocorrectionType = UITextAutocorrectionTypeNo;
	[prompt addSubview:imageTitle];
	
	//You said, you also wanted to write the photo to your camera roll
	//That can be done by using UIImageWriteToSavedPhotosAlbum.
	//Like this:
	if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
		UIImageWriteToSavedPhotosAlbum(imageToBeUploaded, nil, nil, nil);
	}
	
	//Do whatever image processing you want
	//Then properly release your image picker views
	[picker dismissModalViewControllerAnimated:YES];	
	[picker autorelease];
	
	// set cursor and show keyboard
	[imageTitle becomeFirstResponder];
	
	[prompt show];
	[prompt release];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // Dismiss the image selection
    [picker dismissModalViewControllerAnimated:YES];	
	[picker autorelease];
}

#pragma mark - UITableView Delegate methods implementation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [photoNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	static NSString *CellIdentifier = @"ImageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]
				 initWithFrame:CGRectZero reuseIdentifier:CellIdentifier]
				autorelease];
    } else {
		AsyncImageView* oldImage = (AsyncImageView*)[cell.contentView viewWithTag:999];
		UILabel* oldText = (UILabel*)[cell.contentView viewWithTag:998];
		//remove old subviews from cell if not the subviews will overlap!
		[oldImage removeFromSuperview];
		[oldText removeFromSuperview];
    }
	
	
	//Handle image	
	
	CGRect frame;
	frame.size.width=45; frame.size.height=tableOfFlyers.rowHeight;
	frame.origin.x=0; frame.origin.y=0;
	AsyncImageView* asyncImage = [[[AsyncImageView alloc] initWithFrame:frame] autorelease];
	asyncImage.tag = 999;
	
	NSURL* url = [NSURL URLWithString:[photoURLsIcons objectAtIndex:indexPath.row]];
	[asyncImage loadImageFromURL:url];
	
	[cell.contentView addSubview:asyncImage]; //add subview for picture to cell
	
	//Handle text	
	CGRect frame2;
	frame2.size.width=245; frame2.size.height=tableOfFlyers.rowHeight;
	frame2.origin.x=50; frame2.origin.y=0;	
	UILabel *textDisplay = [[[UILabel alloc] initWithFrame:frame2] autorelease];
	textDisplay.tag = 998;
	
	textDisplay.numberOfLines = 0;
	textDisplay.adjustsFontSizeToFitWidth = YES;
	textDisplay.text = [photoNames objectAtIndex:indexPath.row];
	[cell.contentView addSubview:textDisplay]; //add subview for text to cell
	
	//Handle accessory	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	DetailViewController *detailView = [[DetailViewController alloc] init];
	detailView.imageURL =[NSURL URLWithString:[photoURLs objectAtIndex:indexPath.row]];
	[self.navigationController pushViewController:detailView animated:YES];
}

@end
