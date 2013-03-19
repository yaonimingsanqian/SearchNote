//
//  MyPointSet.h
//  SearchNote
//
//  Created by gw zhao on 13-3-5.
//  Copyright (c) 2013年 hebust. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleNote : NSObject
{
    int tag;
    int posAverage;
    NSMutableArray *pointSet;
}
-(void)changeTag:(int)t;
-(void)setPointSet:(NSMutableArray*)arr;
-(void)setPosAverage:(int)w;

-(int)getPosAverage;
-(int)getTag;
-(NSMutableArray*)getPointSet;
@end
