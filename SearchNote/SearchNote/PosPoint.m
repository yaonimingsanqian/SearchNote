//
//  MyPoint.m
//  SearchNote
//
//  Created by gw zhao on 13-3-2.
//  Copyright (c) 2013年 hebust. All rights reserved.
//

#import "PosPoint.h"

@implementation PosPoint

-(void)setPosX:(int)x
{
    posX = x;
}

-(void)setPosY:(int)y
{
    posY = y;
}

-(int)getPosX
{
    return posX;
}
-(int)getPosY
{
    return posY;
}
-(uint32_t)getColorSpace
{
    return colorSpace;
}
-(void)setColorSpace:(uint32_t)color
{
    colorSpace = color;
}

@end
