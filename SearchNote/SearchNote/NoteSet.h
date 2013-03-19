//
//  NoteSet.h
//  SearchNote
//
//  Created by gw zhao on 13-3-8.
//  Copyright (c) 2013年 hebust. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteSet : NSObject
{
    NSMutableArray *noteSet;
    int count;
}


-(NSMutableArray*)next;
-(void)reset;
-(void)add:(NSMutableArray*)pixPointData;
@end
