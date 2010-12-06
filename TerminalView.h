//
//  TerminalView.h
//  piupiu
//
//  Created by Danilo Altheman on 03/12/10.
//  Copyright 2010 Quaddro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Terminal.h"

@interface TerminalView : NSTextView <NSTextViewDelegate, NSTableViewDelegate, NSTableViewDataSource> {
	Terminal *terminal;
	NSMutableArray *historyArray;
	
	IBOutlet NSSlider *alphaSlider;
	IBOutlet NSWindow *mainWindow;
	IBOutlet NSTextView *textView;
	IBOutlet NSTableView *historyTableView;
	IBOutlet NSPanel *historyPanel;
	IBOutlet NSColorWell *backgroundColorWell, *textColorWell;
	IBOutlet NSPopUpButton *terminalTypePopup;

	BOOL isFirstTime;
	BOOL panelIsVisible;
}

@property (nonatomic, retain) NSPanel *historyPanel;
@property (nonatomic, retain) NSWindow *mainWindow;
@property (nonatomic, retain) NSSlider *alphaSlider;
@property (nonatomic, retain) NSTextView *textView;
@property (nonatomic, retain) NSTableView *historyTableView;
@property (nonatomic, retain) NSColorWell *backgroundColorWell, *textColorWell;
@property (nonatomic, retain) NSPopUpButton *terminalTypePopup;

-(IBAction)alphaChanged:(id)sender;
-(IBAction)showHistoryPanel:(id)sender;

-(IBAction)backgroundColorChanged:(id)sender;
-(IBAction)textColorChanged:(id)sender;
-(IBAction)textFontChanged:(id)sender;

-(IBAction)terminalTypeChanged:(id)sender;

-(void)runShell;
-(void)receivedResult:(NSNotification *)anNotification;
-(void)readHistoryFile;

@end
