//
//  UIView-Color.m
//  MobileTwitterrific
//file://localhost/Users/jerry/ibbo/CustomTable.m
//  Created by Craig Hockenberry on 8/31/07.
//
//  Copyright (c) 2007, The Iconfactory. All rights reserved.
//

#import "CustomTable.h"

@implementation CustomTable : UITable
- (id)init
{
	self = [super init];
	return self;
}

- (int)customRowHeights{
	return _rowCount;
}

@end
