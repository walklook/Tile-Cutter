//
//  TileOperation.h
//  Tile Cutter
//
//  Created by jeff on 10/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TileOperation;

@protocol TileOperationDelegate
@optional
- (void)operationDidFinishTile:(TileOperation *)op;
- (void)operationDidFinishSuccessfully:(TileOperation *)op;
- (void)operation:(TileOperation *)op didFailWithMessage:(NSString *)message;
@end


@interface TileOperation : NSOperation 
{
	
}
@property (assign) NSObject <TileOperationDelegate> *delegate;
@property (retain) NSBitmapImageRep *imageRep;
@property NSUInteger row;
@property (retain) NSString *baseFilename;
@property NSUInteger tileHeight;
@property NSUInteger tileWidth;
@property TileCutterOutputPrefs outputFormat;

/* array of tiles info, 
 * each item = NSDictionary {
 *    NSString *name - output filename of tile
 *    NSString from CGRect of that tile in source Image
 */
@property (readwrite, retain)NSMutableArray *tilesInfo;


@end
