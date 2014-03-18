//
//  BREpubSettingsController.m
//  BooklEpicReader
//
//  Created by CAwesome on 2014-03-18.
//  Copyright (c) 2014 CAwesome. All rights reserved.
//

#import "BREpubSettingsController.h"
#import "BREpubSettings.h"

@interface BREpubSettingsController ()

- (void)updateCells;

@property (retain) UITableViewCell *m_cellColumnGap;
@property (retain) UITableViewCell *m_cellFontScale;
@property (retain) UITableViewCell *m_cellIsSyntheticSpread;
@property (retain) NSArray *m_cells;
@property (retain) UITableView *m_table;


@end

@implementation BREpubSettingsController

- (void)cleanUp {
	self.m_table = nil;
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	self.m_cells = nil;
}


- (id)init {
    //	if (self = [super initWithTitle:LocStr(@"EPUB_SETTINGS_TITLE") navBarHidden:NO]) {
    if (self = [super initWithNibName:nil bundle:nil]) {
		if (!IS_IPAD) {
			self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                      target:self
                                                      action:@selector(onClickDone)];
		}
        
		// Synthetic spread
        
		UISwitch *sw = [[UISwitch alloc] init];
		sw.on = [BREpubSettings shared].isSyntheticSpread;
		[sw addTarget:self action:@selector(onIsSyntheticSpreadDidChange:)
     forControlEvents:UIControlEventValueChanged];
        
		self.m_cellIsSyntheticSpread = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                              reuseIdentifier:nil];
		self.m_cellIsSyntheticSpread.accessoryView = sw;
		self.m_cellIsSyntheticSpread.textLabel.text = BRLocStr(@"EPUB_SETTINGS_IS_SYNTHETIC_SPREAD");
        
		// Font scale
        
		UIStepper *stepper = [[UIStepper alloc] init];
		stepper.minimumValue = 0.2;
		stepper.maximumValue = 5;
		stepper.stepValue = 0.1;
		stepper.value = [BREpubSettings shared].fontScale;
		[stepper addTarget:self action:@selector(onFontScaleDidChange:)
          forControlEvents:UIControlEventValueChanged];
        
		self.m_cellFontScale = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                      reuseIdentifier:nil];
		self.m_cellFontScale.accessoryView = stepper;
        
		// Column gap
        
		int maxValue = MIN(SCREEN_SIZE.width, SCREEN_SIZE.height) / 3.0;
		int stepValue = 5;
        
		while (maxValue % stepValue != 0) {
			maxValue--;
		}
        
		stepper = [[UIStepper alloc] init];
		stepper.minimumValue = 0;
		stepper.maximumValue = maxValue;
		stepper.stepValue = stepValue;
		stepper.value = [BREpubSettings shared].columnGap;
		[stepper addTarget:self action:@selector(onColumnGapDidChange:)
          forControlEvents:UIControlEventValueChanged];
        
		self.m_cellColumnGap = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                      reuseIdentifier:nil];
		self.m_cellColumnGap.accessoryView = stepper;
        
		// Finish up
        
		self.m_cells = @[
                         self.m_cellIsSyntheticSpread,
                         self.m_cellFontScale,
                         self.m_cellColumnGap
                         ];
        
		[self updateCells];
        
		self.preferredContentSize = CGSizeMake(320, 44 * self.m_cells.count);
        
		[[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(updateCells)
         name:kBREpubSettingsDidChange
         object:nil];
	}
    
	return self;
}


- (void)loadView {
	self.view = [[UIView alloc] init];
    
	self.m_table = [[UITableView alloc] initWithFrame:CGRectZero
                                                 style:UITableViewStylePlain];
	self.m_table.dataSource = self;
	[self.view addSubview:self.m_table];
}


- (void)onClickDone {
	[self dismissViewControllerAnimated:YES completion:nil];
}


- (void)onColumnGapDidChange:(UIStepper *)stepper {
	[BREpubSettings shared].columnGap = stepper.value;
}


- (void)onFontScaleDidChange:(UIStepper *)stepper {
	[BREpubSettings shared].fontScale = stepper.value;
}


- (void)onIsSyntheticSpreadDidChange:(UISwitch *)sw {
	[BREpubSettings shared].isSyntheticSpread = sw.on;
}


- (UITableViewCell *)
tableView:(UITableView *)tableView
cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [self.m_cells objectAtIndex:indexPath.row];
}


- (NSInteger)
tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
	return self.m_cells.count;
}


- (void)updateCells {
	BREpubSettings *settings = [BREpubSettings shared];
    
	self.m_cellColumnGap.textLabel.text = [NSString stringWithFormat:@"ColG: %d", (int)round(settings.columnGap)];//LocStr(@"EPUB_SETTINGS_COLUMN_GAP",(int)round(settings.columnGap));
    
	self.m_cellFontScale.textLabel.text = [NSString stringWithFormat:@"FontSc: %d",(int)round(100.0 * settings.fontScale)];//LocStr(@"EPUB_SETTINGS_FONT_SCALE",(int)round(100.0 * settings.fontScale));
}


- (void)viewDidLayoutSubviews {
	self.m_table.frame = self.view.bounds;
}

@end
