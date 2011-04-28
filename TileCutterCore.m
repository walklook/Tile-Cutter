//
//  TileCutterCore.m
//  Tile Cutter
//
//  Created by Stepan Generalov on 28.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TileCutterCore.h"
#import "NSImage-Tile.h"

@implementation TileCutterCore

@synthesize keepAllTiles, tileWidth, tileHeight, inputFilename, 
			outputBaseFilename, outputSuffix, operationsDelegate, 
			queue, allTilesInfo, imageInfo, outputFormat;

#pragma mark Public Methods

- (id) init
{
	if ( (self == [super init]) )
	{
		self.queue = [[[NSOperationQueue alloc] init] autorelease];
		self.outputFormat = NSPNGFileType;
		self.outputSuffix = @"";
		self.keepAllTiles = NO;
	}
	
	return self;
}

- (void) dealloc
{
	self.queue = nil;
	self.allTilesInfo = nil;
	self.imageInfo = nil;
	
	[super dealloc];
}

- (void) startSavingTiles
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; 
    
    NSImage *image = [[[NSImage alloc] initWithContentsOfFile: self.inputFilename] autorelease];
        
    progressCol = 0;
    progressRow = 0;
    
    tileRowCount = [image rowsWithTileHeight: self.tileHeight];
    tileColCount = [image columnsWithTileWidth: self.tileWidth];
	
	self.imageInfo = [NSDictionary dictionaryWithObjectsAndKeys: 
					  [self.inputFilename lastPathComponent], @"Filename",
					  NSStringFromSize([image size]), @"Size", nil];
	
	self.allTilesInfo = [NSMutableArray arrayWithCapacity: tileRowCount * tileColCount];
    
    for (int row = 0; row < tileRowCount; row++)
    {
        // Each row operation gets its own ImageRep to avoid contention
        NSBitmapImageRep *imageRep = [[[NSBitmapImageRep alloc] initWithCGImage:[image CGImageForProposedRect:NULL context:NULL hints:nil]] autorelease];
        TileOperation *op = [[TileOperation alloc] init];
        op.row = row;
        op.tileWidth = self.tileWidth;
        op.tileHeight = self.tileHeight;
        op.imageRep = imageRep;
        op.baseFilename = outputBaseFilename;
        op.delegate = self;
        op.outputFormat = self.outputFormat;
		op.skipTransparentTiles = (! self.keepAllTiles );
        [queue addOperation:op];
        [op release];
    }
    
    [pool drain];
}

- (void)operationDidFinishTile:(TileOperation *)op
{
	progressCol++;
    if (progressCol >= tileColCount)
    {
        progressCol = 0;
        progressRow++;
    }
	
	if (progressRow >= tileRowCount)
	{
		NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
						  self.imageInfo, @"Source",
						  self.allTilesInfo, @"Tiles", nil];
	
		[dict writeToFile:[NSString stringWithFormat:@"%@.plist", self.outputBaseFilename]  atomically:YES];
	}
	
    [self.operationsDelegate performSelector: _cmd withObject: op];
}

- (void)operationDidFinishSuccessfully:(TileOperation *)op
{
	
	[(NSMutableArray *)self.allTilesInfo addObjectsFromArray: op.tilesInfo];
	op.tilesInfo = nil;
	
	[self.operationsDelegate performSelector: _cmd withObject: op];
}


- (void)operation:(TileOperation *)op didFailWithMessage:(NSString *)message
{
	[self.operationsDelegate performSelector: _cmd withObject: op];
}


@end
