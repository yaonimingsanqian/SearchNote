//
//  MyPointSet.m
//  SearchNote
//
//  Created by gw zhao on 13-3-5.
//  Copyright (c) 2013年 hebust. All rights reserved.
//

#import "SingleNote.h"

@implementation SingleNote

-(void)setPosAverage:(int)w
{
    posAverage = w;
}
-(int)getPosAverage
{
    return posAverage;
}
-(void)changeTag:(int)t
{
    tag = t;
}

-(int)getTag
{
    return tag;
}

-(void)setPointSet:(NSMutableArray *)arr
{
    pointSet = arr;
}

-(NSMutableArray*)getPointSet
{
    return pointSet;
}
@end
