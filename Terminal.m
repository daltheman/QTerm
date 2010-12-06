//
//  Terminal.m
//  piupiu
//
//  Created by Danilo Altheman on 03/12/10.
//  Copyright 2010 Quaddro. All rights reserved.
//

#import "Terminal.h"
#import <util.h>
#import <unistd.h>
#import <sys/ioctl.h>
#import <errno.h>

@implementation Terminal

@synthesize terminalName, master, slave;

-(id)init {
	if (self = [super init]) {
		int masterfd, slavefd;
		char devicename[128];
		
		struct termios tio;
		bzero(&tio, sizeof(tio));
		
		tio.c_iflag = ICRNL | IXON | IXANY | IMAXBEL | BRKINT;
		tio.c_oflag = OPOST | ONLCR;
		tio.c_cflag = CREAD | CS8 | HUPCL;
		tio.c_lflag = ICANON | ISIG | IEXTEN | ECHO | ECHOE | ECHOKE | ECHOCTL;
		
			// Backspace? Não funfou!
		tio.c_cc[VERASE] = 0x7f;
		tio.c_cc[VQUIT] = 0x1c;
		
		if (tcgetattr(masterfd, &tio) < 0) {
			perror("termios");
		}

		if (openpty(&masterfd, &slavefd, devicename, &tio, NULL) == -1) {
			perror("openpty");
		}
		
		terminalName = [[NSString alloc] initWithCString:devicename];
		master = [[NSFileHandle alloc] initWithFileDescriptor:masterfd closeOnDealloc:YES];
		slave = [[NSFileHandle alloc] initWithFileDescriptor:slavefd closeOnDealloc:YES];
		
		if (setsid() == -1) {
			perror("setsid");
		}
		if (ioctl(slavefd, TIOCSCTTY, NULL) == -1) {
			perror("ioctl");
		}
		

	}
	return self;
}

-(void)setTermType:(const char *)type {
	printf("new type: %s", type);
	setenv("TERM", type, 1);
}


-(void)dealloc {
	[terminalName release];
	[master release];
	[slave release];
	[super dealloc];
}

@end
