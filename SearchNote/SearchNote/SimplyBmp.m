//
//  SimplyBmp.m
//  simplyBmpPicture_
//
//  Created by gw zhao on 13-2-25.
//  Copyright (c) 2013年 hebust. All rights reserved.
//

#import "SimplyBmp.h"
#import "ShiftData.h"
@implementation SimplyBmp



-(void)writeRGBtoArr:(uint32_t *)destImageData :(int)squireCount :(uint32_t*)totalPixelsA :(uint32_t*)totalPixelsR :(uint32_t*)totalPixelsG :(uint32_t*)totalPixelsB :(int*)count
{
    int i = *count;
    *totalPixelsA /= squireCount;
    *totalPixelsR /= squireCount;
    *totalPixelsG /= squireCount;
    *totalPixelsB /= squireCount;
    
    *totalPixelsA = (*totalPixelsA) * SHIFTA;
    *totalPixelsR = (*totalPixelsR) * SHIFTR;
    *totalPixelsG = (*totalPixelsG) * SHIFTG;
    
    destImageData[i] = (*totalPixelsA)+(*totalPixelsB)+(*totalPixelsG)+(*totalPixelsR);
    (*count)++;
    
    *totalPixelsA = 0;
    *totalPixelsG = 0;
    *totalPixelsR = 0;
    *totalPixelsB = 0;
}

-(void)getRGBValue:(uint32_t)data :(uint32_t*)pTotalPixelsA :(uint32_t*)pTotalPixelsR :(uint32_t*)pTotalPixelsG :(uint32_t*)pTotalPixelsB 
{    
    *pTotalPixelsA += (MASKA & data) / SHIFTA;
    *pTotalPixelsR += (MASKR & data) / SHIFTR;                   
    *pTotalPixelsG += (MASKG & data) / SHIFTG;
    *pTotalPixelsB += MASKB & data; 
}

-(void)getSquireValue:(uint32_t*)pOrgImageData :(uint32_t*)totalPixelsA :(uint32_t*)totalPixelsR:(uint32_t*)totalPixelsG :(uint32_t*)totalPixelsB :(int)pointX :(int)pointY :(int)lineCount :(int)rowCount :(int*)squireCount :(int)imageWidth :(uint32_t)pixelsData
{
    for(int i = pointY;i < pointY+rowCount;i++)
    {
        for(int j = pointX;j < pointX+lineCount;j++)
        {
            (*squireCount)++;
            pixelsData = pOrgImageData[i*imageWidth+j];
            [self getRGBValue:pixelsData:totalPixelsA :totalPixelsR :totalPixelsG :totalPixelsB ];
        }
    }
}

-(void)calculateSquireAverage:(uint32_t*)pOrgImageData:(int)destSquireWidth :(int)destSquireHeigh :(int)pointX :(int)pointY :(int)imageWidth :(int)imageHeight :(uint32_t*)destImageData :(int*)count
{
    uint32_t pixelsData;
    int squireCount = 0;
    
    uint32_t totalPixelsA = 0;
    uint32_t totalPixelsR = 0;
    uint32_t totalPixelsG = 0;
    uint32_t totalPixelsB = 0;
    int rowCount = (pointY+destSquireHeigh > imageHeight)?(imageHeight-pointY):destSquireHeigh;
    
    int lineCount = (pointX+destSquireWidth>imageWidth)?(imageWidth-pointX):destSquireWidth;
    
    [self getSquireValue:pOrgImageData :&totalPixelsA :&totalPixelsR :&totalPixelsG :&totalPixelsB :pointX :pointY :lineCount :rowCount :&squireCount :imageWidth :pixelsData];
    
    [self writeRGBtoArr:destImageData :squireCount :&totalPixelsA :&totalPixelsR :&totalPixelsG :&totalPixelsB :count];
    squireCount = 0;
}

-(void)checkAllKeyPointOnCurrentLine:(uint32_t*)pOrgImageData :(int)destSquireWidth :(int)destSquireHeight :(int)imageHeight :(int)imageWidth :(uint32_t*)destImageData :(int)keyWidth :(int*)count
{
    for(int j = 0;j < imageWidth;j +=destSquireWidth)
    {
        [self calculateSquireAverage:pOrgImageData :destSquireWidth :destSquireHeight :j :keyWidth :imageWidth :imageHeight :destImageData :count];
    }
}
-(uint32_t*)createDestImageData:(int)imageWidth :(int)imageHeight :(int)destImageWidth :(int)destImageHeight
{
    uint32_t *destImageData;
    if(imageWidth%destImageWidth==0&&imageHeight%destImageHeight==0)
    {
        destImageData = malloc(imageWidth/destImageWidth*imageHeight/destImageHeight*sizeof(int));
    }else if(imageWidth%destImageWidth==0&&imageHeight%destImageHeight!=0)
    {
        destImageData = malloc(imageWidth/destImageWidth*(imageHeight/destImageHeight+1)*sizeof(int));
    }else if(imageWidth/destImageWidth!=0&&imageHeight/destImageHeight==0)
    {
        destImageData = malloc((imageWidth/destImageWidth+1)*imageHeight/destImageHeight*sizeof(int));
    }else
    {
        destImageData = malloc((imageWidth/destImageWidth+1)*(imageHeight/destImageHeight+1)*sizeof(int));
    }
    return destImageData;
}
-(uint32_t*)mergePix:(uint32_t*)pOrgImageData
               :(int)imageWidth 
               :(int)imageHeight 
               :(int)destSquireWidth 
               :(int)destSquireHeight 
{
    uint32_t *destImageData_ = [self createDestImageData:imageWidth :imageHeight :destSquireWidth :destSquireHeight];
    int count = 0;
    for(int i = 0;i < imageHeight;i += destSquireHeight)
    {
        [self checkAllKeyPointOnCurrentLine:pOrgImageData :destSquireWidth :destSquireHeight :imageHeight :imageWidth :destImageData_ :i :&count];
    }
    return destImageData_;
}
@end
