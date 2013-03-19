//
//  ClearUpDash.h
//  SearchNote
//
//  Created by gw zhao on 13-3-1.
//  Copyright (c) 2013年 hebust. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteSet.h"
@interface NoteRecognition : NSObject

-(NoteSet*)getAllNote
            :(uint32_t*)pOrgImageData 
            :(int)imageWidth 
            :(int)imageHeight;
@end

