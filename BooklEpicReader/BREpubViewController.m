//
//  BREpubViewController.m
//  BooklEpicReader
//
//  Created by CAwesome on 2014-03-18.
//  Copyright (c) 2014 CAwesome. All rights reserved.
//

#import "BREpubViewController.h"
//#import "Bookmark.h"
//#import "BookmarkDatabase.h"
#import "BREPubSettings.h"
#import "BREPubSettingsController.h"
#import "PackageResourceServer.h"
#import "RDContainer.h"
#import "RDNavigationElement.h"
#import "RDPackage.h"
#import "RDPackageResource.h"
#import "RDSpineItem.h"

#import "NSData+toHTML.h"

#include <assert.h>
#include <stdbool.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/sysctl.h>


@interface BREpubViewController ()

- (void)passSettingsToJavaScript;
- (void)updateNavigationItems;
- (void)updateToolbar;


@property (strong) UIAlertView *m_alertAddBookmark;
@property (strong) RDContainer *m_container;
@property (assign) int m_currentOpenPageCount;
@property (assign) int m_currentPageCount;
@property (assign) int m_currentPageIndex;
@property (assign) BOOL m_currentPageProgressionIsLTR;
@property (assign) int m_currentSpineItemIndex;
@property (strong) NSString *m_initialCFI;
@property (assign) BOOL m_moIsPlaying;
@property (strong) RDNavigationElement *m_navElement;
@property (strong) RDPackage *m_package;
@property (strong) UIPopoverController *m_popover;
@property (strong) PackageResourceServer *m_resourceServer;
@property (strong) RDSpineItem *m_spineItem;
@property (strong) UIWebView *m_webView;

@end

@implementation BREpubViewController


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    //	[m_alertAddBookmark ;
    //	m_alertAddBookmark = nil;
    //
    //	if (buttonIndex == 1) {
    //		UITextField *textField = [alertView textFieldAtIndex:0];
    //
    //		NSString *title = [textField.text stringByTrimmingCharactersInSet:
    //                           [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //
    //		NSString *response = [self.m_webView stringByEvaluatingJavaScriptFromString:
    //                              @"ReadiumSDK.reader.bookmarkCurrentPage()"];
    //
    //		if (response != nil && response.length > 0) {
    //			NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
    //			NSError *error;
    //
    //			NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
    //                                                                 options:0 error:&error];
    //
    //			Bookmark *bookmark = [[Bookmark alloc]
    //                                   initWithCFI:[dict objectForKey:@"contentCFI"]
    //                                   containerPath:m_container.path
    //                                   idref:[dict objectForKey:@"idref"]
    //                                   title:title] ;
    //
    //			if (bookmark == nil) {
    //				NSLog(@"The bookmark is nil!");
    //			}
    //			else {
    //				[[BookmarkDatabase shared] addBookmark:bookmark];
    //			}
    //		}
    //	}
    NSLog(@"BOOKMARK STUFF HAPPENED");
}


- (void)cleanUp {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
	self.m_moIsPlaying = NO;
	self.m_webView = nil;
    
    //	if (self.m_alertAddBookmark != nil) {
    //		self.m_alertAddBookmark.delegate = nil;
    //		[self.m_alertAddBookmark dismissWithClickedButtonIndex:999 animated:NO];
    //		self.m_alertAddBookmark = nil;
    //	}
    
	if (self.m_popover != nil) {
		[self.m_popover dismissPopoverAnimated:NO];
		self.m_popover = nil;
	}
}


- (void)dealloc {
    NSLog(@"BREPUB is deallocated. Should we call cleanup?");
}

- (id)
initWithContainer:(RDContainer *)container
package:(RDPackage *)package
{
	return [self initWithContainer:container package:package spineItem:nil cfi:nil];
}


//- (id)
//initWithContainer:(RDContainer *)container
//package:(RDPackage *)package
//bookmark:(Bookmark *)bookmark
//{
//	RDSpineItem *spineItem = nil;
//
//	for (RDSpineItem *currSpineItem in package.spineItems) {
//		if ([currSpineItem.idref isEqualToString:bookmark.idref]) {
//			spineItem = currSpineItem;
//			break;
//		}
//	}
//
//	return [self
//            initWithContainer:container
//            package:package
//            spineItem:spineItem
//            cfi:bookmark.cfi];
//}


- (id)
initWithContainer:(RDContainer *)container
package:(RDPackage *)package
navElement:(RDNavigationElement *)navElement
{
	if (container == nil || package == nil) {
		return nil;
	}
    
	RDSpineItem *spineItem = nil;
    
	if (package.spineItems.count > 0) {
		spineItem = [package.spineItems objectAtIndex:0];
	}
    
	if (spineItem == nil) {
		return nil;
	}
    
	if (self = [super initWithNibName:nil bundle:nil]) {
		self.m_container = container;
		self.m_navElement = navElement;
		self.m_package = package;
        self.m_spineItem = spineItem;
		self.m_resourceServer = [[PackageResourceServer alloc] initWithPackage:package];
		[self updateNavigationItems];
	}
    
	return self;
}


- (id)
initWithContainer:(RDContainer *)container
package:(RDPackage *)package
spineItem:(RDSpineItem *)spineItem
cfi:(NSString *)cfi
{
	if (container == nil || package == nil) {
		return nil;
	}
    
	if (spineItem == nil && package.spineItems.count > 0) {
		spineItem = [package.spineItems objectAtIndex:0];
	}
    
	if (spineItem == nil) {
		return nil;
	}
    
	if (self = [super initWithNibName:nil bundle:nil]) {
        
        self.m_container = container;
		
		self.m_package = package;
        self.m_spineItem = spineItem;
		self.m_resourceServer = [[PackageResourceServer alloc] initWithPackage:package];
		self.m_initialCFI = cfi;
		[self updateNavigationItems];
	}
    
	return self;
}


- (void)loadView {
	self.view = [[UIView alloc] init];
	self.view.backgroundColor = [UIColor whiteColor];
    
	// Notifications
    
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
	[nc addObserver:self selector:@selector(onEPubSettingsDidChange:)
               name:kBREpubSettingsDidChange object:nil];
    
	// Web view
	self.m_webView = [[UIWebView alloc] init];
	self.m_webView.delegate = self;
	self.m_webView.hidden = YES;
	self.m_webView.scalesPageToFit = YES;
	self.m_webView.scrollView.bounces = NO;
	[self.view addSubview:self.m_webView];
    
	NSString *url = [NSString stringWithFormat:
                     @"http://localhost:%d/reader.html", self.m_resourceServer.port];
	[self.m_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}


//- (void)onClickAddBookmark {
//	if (m_alertAddBookmark == nil) {
//		m_alertAddBookmark = [[UIAlertView alloc]
//                              initWithTitle:LocStr(@"ADD_BOOKMARK_PROMPT_TITLE")
//                              message:nil
//                              delegate:self
//                              cancelButtonTitle:LocStr(@"GENERIC_CANCEL")
//                              otherButtonTitles:LocStr(@"GENERIC_OK"), nil];
//		m_alertAddBookmark.alertViewStyle = UIAlertViewStylePlainTextInput;
//		UITextField *textField = [m_alertAddBookmark textFieldAtIndex:0];
//		textField.placeholder = LocStr(@"ADD_BOOKMARK_PROMPT_PLACEHOLDER");
//		[m_alertAddBookmark show];
//	}
//}
//

- (void)onClickMOPause {
	[self.m_webView stringByEvaluatingJavaScriptFromString:@"ReadiumSDK.reader.toggleMediaOverlay()"];
}


- (void)onClickMOPlay {
	[self.m_webView stringByEvaluatingJavaScriptFromString:@"ReadiumSDK.reader.toggleMediaOverlay()"];
}


- (void)onClickNext {
	[self.m_webView stringByEvaluatingJavaScriptFromString:@"ReadiumSDK.reader.openPageNext()"];
}


- (void)onClickPrev {
	[self.m_webView stringByEvaluatingJavaScriptFromString:@"ReadiumSDK.reader.openPagePrev()"];
}


- (void)onClickSettings {
	BREpubSettingsController *c = [[BREpubSettingsController alloc] init] ;
    
	UINavigationController *nav = [[UINavigationController alloc]
                                    initWithRootViewController:c] ;
    
	if (IS_IPAD) {
		if (self.m_popover == nil) {
			self.m_popover = [[UIPopoverController alloc] initWithContentViewController:nav];
			self.m_popover.delegate = self;
			[self.m_popover presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem
                              permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
		}
	}
	else {
		[self presentViewController:nav animated:YES completion:nil];
	}
}


- (void)onEPubSettingsDidChange:(NSNotification *)notification {
	[self passSettingsToJavaScript];
}


- (void)passSettingsToJavaScript {
	NSData *data = [NSJSONSerialization dataWithJSONObject:[BREpubSettings shared].dictionary
                                                   options:0 error:nil];
    
	if (data == nil) {
		return;
	}
    
	NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
    
	if (s == nil || s.length == 0) {
		return;
	}
    
	[self.m_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:
                                                       @"ReadiumSDK.reader.updateSettings(%@)", s]];
}


- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
	self.m_popover = nil;
}


- (void)updateNavigationItems {
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                               target:self
                                               action:@selector(onClickSettings)] ;
}


- (void)updateToolbar {
	if (self.m_webView.hidden) {
		self.toolbarItems = nil;
		return;
	}
    
	NSMutableArray *items = [NSMutableArray arrayWithCapacity:8];
    
	UIBarButtonItem *itemFixed = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                   target:nil
                                   action:nil] ;
	itemFixed.width = 12;
    
	static NSString *arrowL = @"\u2190";
	static NSString *arrowR = @"\u2192";
    
	UIBarButtonItem *itemNext = [[UIBarButtonItem alloc]
                                  initWithTitle:self.m_currentPageProgressionIsLTR ? arrowR : arrowL
                                  style:UIBarButtonItemStylePlain
                                  target:self
                                  action:@selector(onClickNext)] ;
    
	UIBarButtonItem *itemPrev = [[UIBarButtonItem alloc]
                                  initWithTitle:self.m_currentPageProgressionIsLTR ? arrowL : arrowR
                                  style:UIBarButtonItemStylePlain
                                  target:self
                                  action:@selector(onClickPrev)] ;
    
	if (self.m_currentPageProgressionIsLTR) {
		[items addObject:itemPrev];
		[items addObject:itemFixed];
		[items addObject:itemNext];
	}
	else {
		[items addObject:itemNext];
		[items addObject:itemFixed];
		[items addObject:itemPrev];
	}
    
	[items addObject:itemFixed];
    
	UILabel *label = [[UILabel alloc] init] ;
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont systemFontOfSize:16];
	label.textColor = [UIColor blackColor];
    
	if (self.self.m_currentPageCount == 0) {
		label.text = @"";
		itemNext.enabled = NO;
		itemPrev.enabled = NO;
	}
	else {
		label.text = @"PAGE X OF Y";//LocStr(@"PAGE_X_OF_Y", self.m_currentPageIndex + 1, self.m_currentPageCount);
        
		itemNext.enabled = !(
                             (self.m_currentSpineItemIndex + 1 == self.m_package.spineItems.count) &&
                             (self.m_currentPageIndex + self.m_currentOpenPageCount + 1 >= self.m_currentPageCount)
                             );
        
		itemPrev.enabled = !(self.m_currentSpineItemIndex == 0 && self.m_currentPageIndex == 0);
	}
    
	[label sizeToFit];
    
	[items addObject:[[UIBarButtonItem alloc] initWithCustomView:label] ];
    
	[items addObject:[[UIBarButtonItem alloc]
                       initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                       target:nil
                       action:nil] 
     ];
    
	NSString *response = [self.m_webView stringByEvaluatingJavaScriptFromString:
                          @"ReadiumSDK.reader.isMediaOverlayAvailable()"];
    
	if (response != nil && [response isEqualToString:@"true"]) {
		if (self.m_moIsPlaying) {
			[items addObject:[[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemPause
                               target:self
                               action:@selector(onClickMOPause)] 
             ];
		}
		else {
			[items addObject:[[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
                               target:self
                               action:@selector(onClickMOPlay)] 
             ];
		}
        
		[items addObject:itemFixed];
	}
    
//	[items addObject:[[UIBarButtonItem alloc]
//                       initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
//                       target:self
//                       action:@selector(onClickAddBookmark)] 
//     ];
//    
	self.toolbarItems = items;
}


- (void)viewDidLayoutSubviews {
	self.m_webView.frame = self.view.bounds;
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
	if (self.navigationController != nil) {
		[self.navigationController setToolbarHidden:NO animated:YES];
	}
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    
	if (self.navigationController != nil) {
		[self.navigationController setToolbarHidden:YES animated:YES];
	}
}


- (BOOL)
webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
navigationType:(UIWebViewNavigationType)navigationType
{
	BOOL shouldLoad = YES;
	NSString *url = request.URL.absoluteString;
	NSString *s = @"epubobjc:";
    
	if ([url hasPrefix:s]) {
		url = [url substringFromIndex:s.length];
		shouldLoad = NO;
        
		if ([url isEqualToString:@"readerDidInitialize"]) {
			NSMutableDictionary *dict = [NSMutableDictionary dictionary];
			[dict setObject:self.m_package.dictionary forKey:@"package"];
			[dict setObject:[BREpubSettings shared].dictionary forKey:@"settings"];
            
			NSDictionary *pageDict = nil;
            
			if (self.m_spineItem == nil) {
			}
			else if (self.m_initialCFI != nil && self.m_initialCFI.length > 0) {
				pageDict = @{
                             @"idref" : self.m_spineItem.idref,
                             @"elementCfi" : self.m_initialCFI
                             };
			}
			else if (self.m_navElement.content != nil && self.m_navElement.content.length > 0) {
				pageDict = @{
                             @"contentRefUrl" : self.m_navElement.content,
                             @"sourceFileHref" : (self.m_navElement.sourceHref == nil ?
                                                  @"" : self.m_navElement.sourceHref)
                             };
			}
			else {
				pageDict = @{
                             @"idref" : self.m_spineItem.idref
                             };
			}
            
			if (pageDict != nil) {
				[dict setObject:pageDict forKey:@"openPageRequest"];
			}
            
			NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
            
			if (data != nil) {
				NSString *arg = [[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding] ;
				[self.m_webView stringByEvaluatingJavaScriptFromString:[NSString
                                                                   stringWithFormat:@"ReadiumSDK.reader.openBook(%@)", arg]];
			}
            
			return shouldLoad;
		}
        
		s = @"pageDidChange?q=";
        
		if ([url hasPrefix:s]) {
			s = [url substringFromIndex:s.length];
			s = [s stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
			NSData *data = [s dataUsingEncoding:NSUTF8StringEncoding];
			NSError *error;
            
			NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0 error:&error];
            
			NSString *direction = [dict objectForKey:@"pageProgressionDirection"];
            
			if ([direction isKindOfClass:[NSString class]]) {
				self.m_currentPageProgressionIsLTR = ![direction isEqualToString:@"rtl"];
			}
			else {
				self.m_currentPageProgressionIsLTR = YES;
			}
            
			self.m_currentOpenPageCount = 0;
            
			for (NSDictionary *pageDict in [dict objectForKey:@"openPages"]) {
				self.m_currentOpenPageCount++;
                
				NSNumber *number = [pageDict objectForKey:@"spineItemPageCount"];
				self.m_currentPageCount = number.intValue;
                
				number = [pageDict objectForKey:@"spineItemPageIndex"];
				self.m_currentPageIndex = number.intValue;
                
				number = [pageDict objectForKey:@"spineItemIndex"];
				self.m_currentSpineItemIndex = number.intValue;
                
				break;
			}
            
			self.m_webView.hidden = NO;
			[self updateToolbar];
			return shouldLoad;
		}
        
		s = @"mediaOverlayStatusDidChange?q=";
        
		if ([url hasPrefix:s]) {
			s = [url substringFromIndex:s.length];
			s = [s stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
			NSData *data = [s dataUsingEncoding:NSUTF8StringEncoding];
			NSError *error;
            
			NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0 error:&error];
            
			NSNumber *number = [dict objectForKey:@"isPlaying"];
            
			if (number != nil) {
				self.m_moIsPlaying = number.boolValue;
			}
            
			[self updateToolbar];
			return shouldLoad;
		}
	}
    
	return shouldLoad;
}


@end
