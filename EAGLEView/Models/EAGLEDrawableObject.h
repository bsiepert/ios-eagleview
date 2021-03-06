//
//  EAGLEDrawable.h
//  EAGLEView
//
//  Created by Jens Willy Johannsen on 23/11/13.
//  Copyright (c) 2013 Greener Pastures. All rights reserved.
//

#import "EAGLEObject.h"
#import "EAGLELayer.h"
#import "EAGLEFile.h"

#define RETURN_IF_NOT_LAYER_VISIBLE
//if( !((EAGLELayer*)self.file.layers[ self.layerNumber ]).visible ) return

typedef void(*PatternFncPtr)(void*,CGContextRef);

typedef enum
{
	Rotation_0,
	Rotation_R30,
	Rotation_R35,
	Rotation_R45,
	Rotation_R90,
	Rotation_R180,
	Rotation_R225,
	Rotation_R270,
	Rotation_Mirror_MR0,
	Rotation_Mirror_MR90,
	Rotation_Mirror_MR180,
	Rotation_Mirror_MR270
} Rotation;

@protocol EAGLEDrawable <NSObject>

- (void)drawInContext:(CGContextRef)context;
- (CGFloat)maxX;
- (CGFloat)maxY;
- (CGFloat)minX;
- (CGFloat)minY;
- (CGPoint)origin;
- (CGRect)boundingRect;

@end

@interface EAGLEDrawableObject : EAGLEObject  <EAGLEDrawable>
{
	NSNumber *_layerNumber;
}

@property (nonatomic, readonly) NSNumber *layerNumber;

+ (EAGLEDrawableObject*)drawableFromXMLElement:(DDXMLElement*)element inFile:(EAGLEFile*)file;
- (void)drawInContext:(CGContextRef)context;
- (void)drawOnBottomInContext:(CGContextRef)context;
- (NSNumber*)mirroredLayerNumber;

- (void)setStrokeColorFromLayerInContext:(CGContextRef)context;
- (void)setFillColorFromLayerInContext:(CGContextRef)context;
- (PatternFncPtr)patternFunctionForLayer;

+ (CGFloat)radiansForRotation:(Rotation)rotation;
+ (Rotation)rotationForString:(NSString*)rotationString;
+ (BOOL)rotationIsMirrored:(Rotation)rotation;
+ (void)transformContext:(CGContextRef)context forRotation:(Rotation)rotation;

@end
