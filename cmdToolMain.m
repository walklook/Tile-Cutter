//
//  cmdToolMain.m
//  Tile Cutter
//
//  Created by Stepan Generalov on 28.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h> 

#import <stdio.h>
#import <stdlib.h>
#import <getopt.h>

#import "TileCutterCore.h"
#import "TileCutterSettings.h"

void printUsageAndExit()
{
	printf("\nUsage: tileCutter [--keepTransparentTiles] --tileWidth WIDTH --tileHeight HEIGHT \
--inputFile INPUT.PNG --outputFile OUTPUT [--outputSuffix SUFFIX]\n\
HEIGHT & WIDTH should be >= 1\n\
output tiles file names will be in this format:\n\
OUTPUT_X_Y-SUFFIX.png,\n\
where X & Y is tile number\n\
Output plist file will be: OUTPUT.plist\n");
	exit(0);
}

int main(int argc, char *argv[])
{
	// Options Storage
	int keepAllTiles = 0;
	NSUInteger tileWidth = 0;
	NSUInteger tileHeight = 0;
	NSString *inputFilename = nil;
	NSString *outputBaseFilename = nil;
	NSString *outputSuffix = nil;
	
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	
	int c;
	
	if (argc <= 1) 
	{
		[pool release];
		printUsageAndExit();
	}
	
	while (1)
	{
		struct option long_options[] =
		{
			/* These options set a flag. */
			{"skipTransparentTiles",   no_argument,       &keepAllTiles, 0},
			{"keepTransparentTiles",   no_argument,       &keepAllTiles, 1},
			/* These options don't set a flag.
			 We distinguish them by their indices. */
			{"tileWidth",    required_argument, 0, 'w'},
			{"tileHeight",   required_argument, 0, 'h'},
			{"inputFile",    required_argument, 0, 'i'},
			{"outputFile",   required_argument, 0, 'o'},
			{"outputSuffix", required_argument, 0, 's'},
			{0, 0, 0, 0}
		};
		/* getopt_long stores the option index here. */
		int option_index = 0;
		
		c = getopt_long (argc, argv, "w:h:i:o:s:",
						 long_options, &option_index);
		
		/* Detect the end of the options. */
		if (c == -1)
			break;
		
		switch (c)
		{
			case 0:
				/* If this option set a flag, do nothing else now. */
				if (long_options[option_index].flag != 0)
					break;
				
				// if this is unkown option - print usage and exit
				[pool release];
				printUsageAndExit();
				
				break;
				
			case 'w':
				tileWidth = (NSUInteger)[[NSString stringWithCString: optarg encoding: NSUTF8StringEncoding] intValue];
				if (!tileWidth)
				{
					[pool release];
					printUsageAndExit();
				}
				break;
				
			case 'h':
				tileHeight = (NSUInteger)[[NSString stringWithCString: optarg encoding: NSUTF8StringEncoding] intValue];
				if (!tileHeight)
				{
					[pool release];
					printUsageAndExit();
				}
				break;
				
			case 'i':
				inputFilename = [NSString stringWithCString: optarg encoding: NSUTF8StringEncoding];
				break;
				
			case 'o':
				outputBaseFilename = [NSString stringWithCString:optarg encoding: NSUTF8StringEncoding];
				break;
				
			case 's':
				outputSuffix = [NSString stringWithCString:optarg encoding: NSUTF8StringEncoding];
				break;
				
			case '?':
				/* getopt_long already printed an error message. */
				[pool release];
				printUsageAndExit();
				break;
				
			default:
				abort ();
		}
	}
	
	
	// We don't accept any nonOptions cmd line arguments
	if (optind < argc)
	{
		[pool release];
		printUsageAndExit();
	}
	
	// Prepare Tile Cutter
	TileCutterCore *tileCutterCore = [TileCutterCore new];
	tileCutterCore.inputFilename = inputFilename;
	tileCutterCore.outputBaseFilename = outputBaseFilename;
	tileCutterCore.outputSuffix = outputSuffix;
	tileCutterCore.tileWidth = tileWidth;
	tileCutterCore.tileHeight = tileWidth;
	tileCutterCore.keepAllTiles = (keepAllTiles != 0);
	
	// Start Cutting and Wait for it.
	[tileCutterCore startSavingTiles];
	[tileCutterCore.queue waitUntilAllOperationsAreFinished];
	
	[pool release];
	return 0;
}

