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
//#import "EPubSettings.h"
//#import "EPubSettingsController.h"
#import "PackageResourceServer.h"
#import "RDContainer.h"
#import "RDNavigationElement.h"
#import "RDPackage.h"
#import "RDPackageResource.h"
#import "RDSpineItem.h"

#include <assert.h>
#include <stdbool.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/sysctl.h>


@interface BREpubViewController ()

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



@end
