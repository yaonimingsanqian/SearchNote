//
//  SimplyBmp.h
//  simplyBmpPicture_
//
//  Created by gw zhao on 13-2-25.
//  Copyright (c) 2013年 hebust. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimplyBmp : NSObject


-(uint32_t*)mergePix:(uint32_t*)pOrgImageData
               :(int)imageWidth 
               :(int)imageHeight 
               :(int)destSquireWidth 
               :(int)destSquireHeight ;

@end
