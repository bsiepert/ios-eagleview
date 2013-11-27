//
//  EAGLEAttribute.m
//  EAGLEView
//
//  Created by Jens Willy Johannsen on 26/11/13.
//  Copyright (c) 2013 Greener Pastures. All rights reserved.
//

#import "EAGLEAttribute.h"
#import "DDXML.h"
#import "EAGLEDrawableText.h"	// For kFontSizeFactor
#import "EAGLELayer.h"
#import "EAGLESchematic.h"

@implementation EAGLEAttribute

- (id)initFromXMLElement:(DDXMLElement *)element inSchematic:(EAGLESchematic *)schematic
{
	if( (self = [super initFromXMLElement:element inSchematic:schematic]) )
	{
		_name = [[element attributeForName:@"name"] stringValue];

		CGFloat x = [[[element attributeForName:@"x"] stringValue] floatValue];
		CGFloat y = [[[element attributeForName:@"y"] stringValue] floatValue];
		_point = CGPointMake( x, y );

		_size = [[[element attributeForName:@"size"] stringValue] floatValue];

		NSString *rotString = [[element attributeForName:@"rot"] stringValue];
		if( rotString == nil )
			_rotation = 0;
		else if( [rotString isEqualToString:@"R90"] )
			_rotation = M_PI_2;
		else if( [rotString isEqualToString:@"R270"] )
			_rotation = M_PI_2 * 3;
		else if( [rotString isEqualToString:@"R180"] )
			_rotation = M_PI;
		else
			[NSException raise:@"Unknown rotation string" format:@"Unknown rotation: %@", rotString];
}

	return self;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"Attribute %@ – at %@, size %.2f", self.name, NSStringFromCGPoint( self.point ), self.size];
}

- (void)drawInContext:(CGContextRef)context
{
	// Flip and translate coordinate system for text drawing
	CGContextSaveGState( context );
	CGContextTranslateCTM( context, self.point.x, self.point.y );
	CGContextRotateCTM( context, self.rotation );
	CGContextTranslateCTM( context, 0, self.size * kFontSizeFactor );
	CGContextScaleCTM( context, 1, -1 );

	// Set font and color
	EAGLELayer *currentLayer = self.schematic.layers[ self.layerNumber ];
	NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:self.size * kFontSizeFactor],
								  NSForegroundColorAttributeName: currentLayer.color };

	[self.text drawAtPoint:CGPointZero withAttributes:attributes];

	CGContextRestoreGState( context );
}

@end