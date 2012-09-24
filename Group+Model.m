//
//  Group+Model.m
//  Lookup
//
//  Created by Wesley Smith on 9/24/12.
//  Copyright (c) 2012 Wesley Smith. All rights reserved.
//

#import "Group+Model.h"

@implementation Group (Model)
@end

@implementation ImageToDataTransformer

+ (BOOL)allowsReverseTransformation
{
	return YES;
}

+ (Class)transformedValueClass
{
	return [NSData class];
}

- (id)transformedValue:(id)value
{
	NSData *data = UIImagePNGRepresentation(value);
	return data;
}


- (id)reverseTransformedValue:(id)value
{
	UIImage *image = [[UIImage alloc] initWithData:value];
	return image;
}

@end