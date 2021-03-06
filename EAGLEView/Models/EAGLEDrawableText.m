//
//  EAGLEDrawableText.m
//  EAGLEView
//
//  Created by Jens Willy Johannsen on 23/11/13.
//  Copyright (c) 2013 Greener Pastures. All rights reserved.
//

#import "EAGLEDrawableText.h"
#import "DDXML.h"
#import "EAGLEFile.h"
#import "EAGLELayer.h"

const CGFloat kFontSizeFactor = 1.30;	// Font size is multiplied by this factor to get the point size
const CGFloat kTextYPadding = -0.8;		// Texts' Y coords will be adjusted by this much

@implementation EAGLEDrawableText

- (id)initFromXMLElement:(DDXMLElement *)element inFile:(EAGLEFile *)file
{
	if( (self = [super initFromXMLElement:element inFile:file]) )
	{
		_text = [element stringValue];

		CGFloat x = [[[element attributeForName:@"x"] stringValue] floatValue];
		CGFloat y = [[[element attributeForName:@"y"] stringValue] floatValue];
		_point = CGPointMake( x, y );

		CGFloat size = [[[element attributeForName:@"size"] stringValue] floatValue];
		_size = size;

		NSString *rotationString = [[element attributeForName:@"rot"] stringValue];
		_rotation = [EAGLEDrawableObject rotationForString:rotationString];
	}

	return self;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"Text '%@' - at %@", self.text, NSStringFromCGPoint( self.point )];
}

- (void)drawInContext:(CGContextRef)context flipText:(BOOL)flipText isMirrored:(BOOL)isMirrored
{
	RETURN_IF_NOT_LAYER_VISIBLE;

	// Flip and translate coordinate system for text drawing
	CGContextSaveGState( context );
	CGContextTranslateCTM( context, self.point.x, self.point.y );
	[EAGLEDrawableObject transformContext:context forRotation:self.rotation];

	// Set color
	EAGLELayer *currentLayer = self.file.layers[ self.layerNumber ];

	// Set font properties
	NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
	paragraphStyle.lineSpacing = 0;

	NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:self.size * kFontSizeFactor],
								  NSForegroundColorAttributeName: currentLayer.color,
								  NSParagraphStyleAttributeName: paragraphStyle };

	// Calculate text size and offset coordinate system
	NSString *stringToDraw = (self.valueText ? self.valueText : self.text);
	CGSize textSize = [stringToDraw sizeWithAttributes:attributes];
	CGContextTranslateCTM( context, 0, textSize.height + kTextYPadding );
	CGContextScaleCTM( context, 1, -1 );

	// Get current compound rotation angle
	CGAffineTransform transform = CGContextGetCTM( context );
	CGFloat rotation = atan2(transform.b, transform.a);
	BOOL rotationIs180 = (fabs( M_PI - rotation ) < 0.00001);	// Because rotation might not be exactly 3.14159265358979323846264338327950288

	// Perform other rotations and translations as necessary
	if( _rotation == Rotation_R180 || flipText || rotationIs180 )
	{
		CGContextTranslateCTM( context, textSize.width, textSize.height );
		CGContextScaleCTM( context, -1, -1 );
	}

	if( _rotation == Rotation_Mirror_MR270 )
	{
		CGContextTranslateCTM( context, -textSize.width, -kTextYPadding/2 );
	}

	if( isMirrored )
	{
		CGContextTranslateCTM( context, textSize.width, 0 );
		CGContextScaleCTM( context, -1, 1 );
	}

	// Draw string
	[stringToDraw drawAtPoint:CGPointZero withAttributes:attributes];

	CGContextRestoreGState( context );
}

- (void)drawInContext:(CGContextRef)context
{
	[self drawInContext:context flipText:NO isMirrored:NO];
}

- (CGFloat)maxX
{
	// Calculate size with same properties as when drawing
	NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
	paragraphStyle.lineSpacing = 0;

	NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:self.size * kFontSizeFactor],
								  NSParagraphStyleAttributeName: paragraphStyle };

	// Calculate text size and offset coordinate system
	NSString *stringToDraw = (self.valueText ? self.valueText : self.text);
	CGSize textSize = [stringToDraw sizeWithAttributes:attributes];

	return self.point.x + textSize.width;
}

- (CGFloat)maxY
{
	// Calculate size with same properties as when drawing
	NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
	paragraphStyle.lineSpacing = 0;

	NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:self.size * kFontSizeFactor],
								  NSParagraphStyleAttributeName: paragraphStyle };

	// Calculate text size and offset coordinate system
	NSString *stringToDraw = (self.valueText ? self.valueText : self.text);
	CGSize textSize = [stringToDraw sizeWithAttributes:attributes];

	return self.point.y + textSize.height;
}

- (CGFloat)minX
{
	return self.point.x;
}

- (CGFloat)minY
{
	return self.point.y;
}

- (CGPoint)origin
{
	return _point;
}

@end
