//
//  NoteSet.m
//  SearchNote
//
//  Created by gw zhao on 13-3-8.
//  Copyright (c) 2013年 hebust. All rights reserved.
//

#import "NoteSet.h"
#import "PosPoint.h"
#import "SingleNote.h"

@implementation NoteSet

-(NSMutableArray*)currentNote
{
    return [[noteSet objectAtIndex:++count] getPointSet];
}
-(id)init
{
    self = [super init];
    if(self)
    {
        count = -1;
        noteSet = [[NSMutableArray alloc]init];
    }
    return self;
}


-(NSMutableArray*)next
{
    int c = [noteSet count];
    
    if (c > 0 && count < c)
    {
        return [self currentNote];
    }else
    {
        return nil;
    }
    

    
    
}
-(void)reset
{
    count = -1;
}
-(void)add:(NSMutableArray *)pixPointData
{
    for (SingleNote *arr in pixPointData)
    {
        [noteSet addObject:arr];
    }
}
@end
