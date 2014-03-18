//
//  BREpubViewController.h
//  BooklEpicReader
//
//  Created by CAwesome on 2014-03-18.
//  Copyright (c) 2014 CAwesome. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Bookmark;
@class PackageResourceServer;
@class RDContainer;
@class RDNavigationElement;
@class RDPackage;
@class RDSpineItem;

@interface BREpubViewController : UIViewController <UIAlertViewDelegate, UIPopoverControllerDelegate, UIWebViewDelegate>
{

}

- (id)initWithContainer:(RDContainer *)container package:(RDPackage *)package;

//- (id)initWithContainer:(RDContainer *)container package:(RDPackage *)package bookmark:(Bookmark *)bookmark;

- (id)initWithContainer:(RDContainer *)container package:(RDPackage *)package navElement:(RDNavigationElement *)navElement;

- (id)initWithContainer:(RDContainer *)container package:(RDPackage *)package spineItem:(RDSpineItem *)spineItem cfi:(NSString *)cfi;

@end
