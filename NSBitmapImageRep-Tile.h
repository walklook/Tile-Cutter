//
//  NSBitmapImageRep-Tile.h
//  Tile Cutter
//
//  Created by jeff on 10/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSBitmapImageRep(Tile)

-(NSImage *)subImageWithTileWidth:(CGFloat)tileWidth 
					   tileHeight:(CGFloat)tileHeight 
						   column:(NSUInteger)column 
							  row:(NSUInteger)row;

// Same as previous, but if rigid = YES - adds black pixels to fill 
// all tileWidthxtileHeight zone, if there's no enough pixels in image
-(NSImage *)subImageWithTileWidth:(CGFloat)tileWidth 
					   tileHeight:(CGFloat)tileHeight 
						   column:(NSUInteger)column 
							  row:(NSUInteger)row
						rigidSize:(BOOL) rigid;

/** Designated method.
 *
 * @param potSize If YES - tile width & height will be rounded to nearest POT value, larger then existing. 
 * potSize have no effect if rigidSize is YES.
 *
 */
-(NSImage *)subImageWithTileWidth:(CGFloat)tileWidth 
					   tileHeight:(CGFloat)tileHeight 
						   column:(NSUInteger)column 
							  row:(NSUInteger)row
						rigidSize:(BOOL) rigid
						  POTSize:(BOOL) potSize;

-(NSUInteger)columnsWithTileWidth:(CGFloat)tileWidth;
-(NSUInteger)rowsWithTileHeight:(CGFloat)tileHeight;

@end
