//
//  TerminalView.m
//  piupiu
//
//  Created by Danilo Altheman on 03/12/10.
//  Copyright 2010 Quaddro. All rights reserved.
//

#import "TerminalView.h"

@implementation TerminalView
@synthesize alphaSlider, mainWindow, textView, historyPanel, historyTableView, backgroundColorWell, textColorWell, terminalTypePopup;

#pragma mark -
#pragma mark View Lifecycle

-(void)awakeFromNib {
	panelIsVisible = NO;
	
		// Customize NSTextView 
	[self setDelegate:self];
	[self setInsertionPointColor:[NSColor redColor]];
	[self setTextColor:[NSColor greenColor]];
	[self setBackgroundColor:[NSColor blackColor]];

	[[historyTableView cell] setTextColor:[NSColor whiteColor]];

	terminal = [[Terminal alloc] init];
	[self.mainWindow setTitle:terminal.terminalName];
	[self runShell];
	[self setFont:[NSFont fontWithName:@"Monaco" size:14.0]];
	
	isFirstTime = YES;
	
	[alphaSlider setContinuous:YES];
	historyArray = [[NSMutableArray alloc] initWithCapacity:10];

	[terminalTypePopup addItemsWithTitles:[NSArray arrayWithObjects:@"vt100", @"vt102", @"xterm", @"xterm-color", nil]];
	
}



-(void)readHistoryFile {
	NSString *homeDir = [@"~" stringByExpandingTildeInPath];
	NSString *historyFile = [NSString stringWithFormat:@"%@/.bash_history", homeDir];
	NSLog(@"hostiry: %@", historyFile);
	FILE *fd = fopen([historyFile cStringUsingEncoding:NSUTF8StringEncoding], "r");
	char line[512];
	while (!feof(fd)) {
		fgets(line, sizeof(line), fd);
		printf("%s", line);
		[historyArray addObject:[NSString stringWithCString:line encoding:NSUTF8StringEncoding]];
	}
	fclose(fd);

	[historyTableView reloadData];
}

#pragma mark -
#pragma mark Interface Builder Actions

-(IBAction)backgroundColorChanged:(id)sender {
	[self setBackgroundColor:[sender color]];
}

-(IBAction)textColorChanged:(id)sender {
	[self setTextColor:[sender color]];
}

-(IBAction)textFontChanged:(id)sender {
	
}

-(IBAction)terminalTypeChanged:(id)sender {
	NSLog(@"Tipo: %@", [[sender selectedItem] title]);
	NSString *termType = [[sender selectedItem] title];
	const char *type = [termType cStringUsingEncoding:NSUTF8StringEncoding];
	[terminal setTermType:type];
}

-(IBAction)alphaChanged:(id)sender {
	float alpha = [sender floatValue] / 100;
	NSLog(@"mudou: %f", alpha);
	[[mainWindow contentView] setAlphaValue:alpha];
	[self.textView setAlphaValue:alpha];
}

-(IBAction)showHistoryPanel:(id)sender {
	[self readHistoryFile];
	NSLog(@"Showing panel");
	if (panelIsVisible == NO) {
		[historyPanel orderFront:self];
		panelIsVisible = YES;
	}
	else {
		[historyPanel close];
		panelIsVisible = NO;
	}
}


#pragma mark -
#pragma mark Shell Control
-(void)runShell {
	NSLog(@"Running shell...");
	NSString *shell = @"/bin/bash";
	NSTask *task = [[NSTask alloc] init];
	[task setStandardInput:terminal.slave];
	[task setStandardOutput:terminal.slave];
	[task setStandardError:terminal.slave];
	[task setCurrentDirectoryPath:[@"~" stringByExpandingTildeInPath]];
	[task setLaunchPath:shell];
	[task setArguments:[NSArray arrayWithObjects:@"-i", nil]];
	[task launch];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedResult:) name:NSFileHandleReadCompletionNotification 
											   object:terminal.master];
	
	[[terminal master] readInBackgroundAndNotify];
	
	NSLog(@"PID: %i", [task processIdentifier]);
	
}

-(void)receivedResult:(NSNotification *)anNotification {
	NSData *data = [[anNotification userInfo] objectForKey:NSFileHandleNotificationDataItem];
	NSString *resultString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	if (resultString != NULL) {
		[self insertText:resultString];
	}

	[resultString release];
	[[anNotification object] readInBackgroundAndNotify];
}

	// Known Bug - Problemas com a impressão de caracters. Ex.: Apóstrofo, Delete,
-(void)keyDown:(NSEvent *)event {
	const char *typein = [[event characters] UTF8String];
	[terminal.master writeData:[NSData dataWithBytes:typein length:strlen(typein)]];
}

- (BOOL)textView:(NSTextView *)aTextView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString {
	if (*[replacementString cStringUsingEncoding:NSUTF8StringEncoding] == 13) {
//		[historyArray removeAllObjects];
		[self readHistoryFile];
	}
	return YES;
}

#pragma mark -
#pragma mark History Panel 

- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex {
	NSLog(@"Selecionou: %i", rowIndex);
	return YES;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
	return [historyArray count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
	if ([[aTableColumn identifier] isEqualToString:@"cmdnumber"]) {
		return [NSString stringWithFormat:@"%i", rowIndex + 1];
	}
	else if([[aTableColumn identifier] isEqualToString:@"command"]) {
		return [NSString stringWithFormat:@"%@", [historyArray objectAtIndex:rowIndex]];
	}
	//return [[historyArray objectAtIndex:rowIndex] objectForKey:[aTableColumn identifier]];;
	return nil;
}


@end
