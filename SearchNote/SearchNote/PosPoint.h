//
//  MyPoint.h
//  SearchNote
//
//  Created by gw zhao on 13-3-2.
//  Copyright (c) 2013年 hebust. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PosPoint : NSObject
{
    int posX;
    int posY;
    uint32_t colorSpace;
}
-(void)setPosX:(int)x;
-(void)setPosY:(int)y;
-(void)setColorSpace:(uint32_t)colorspace;

-(uint32_t)getColorSpace;
-(int)getPosX;
-(int)getPosY;
@end
