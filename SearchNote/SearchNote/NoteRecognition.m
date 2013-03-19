//
//  ClearUpDash.m
//  SearchNote
//
//  Created by gw zhao on 13-3-1.
//  Copyright (c) 2013年 hebust. All rights reserved.
//

#import "NoteRecognition.h"
#import "PosPoint.h"
#import "SingleNote.h"

@implementation NoteRecognition

-(BOOL)isCenterPoint:(int)posX :(int)posY:(int)pointY :(int)pointX
{
    if(posY == pointY&&posX == pointX)
        return TRUE;
    return FALSE;
}

-(int)getTag:(uint32_t*)recordData:(int)posX :(int)posY :(int)imageWidth
{
    return recordData[posY*imageWidth+posX];
}

-(int)initStartPosX:(int)pointX
{
    int posX;
    if(pointX-1 <= 0)
    {
        posX = 0;
    }else
    {
        posX = pointX-1;
    }
    return posX;
}
-(int)initStartPosY:(int)pointY
{
    int posY;
    if(pointY-1 <= 0)
    {
        posY = 0;
    }else
    {
        posY = pointY-1;
    }
    return posY;
}
-(int)initEndPosX:(int)pointX :(int)imageWidth
{
    int endX;
    if(pointX+1 >= imageWidth)
    {
        endX = imageWidth;
    }else
    {
        endX = pointX+2;
    }
    return endX;
}
-(int)initEndPosY:(int)pointY :(int)imageHeight
{
    int endY;
    if(pointY+1 >= imageHeight)
    {
        endY = imageHeight;
    }else
    {
        endY = pointY+2;
    }
    return endY;
    
}
-(BOOL)isPointWhite:(uint32_t*)data :(int)imageWidth :(int)posX :(int)posY
{
    if(data[posY*imageWidth+posX]!=0xffffffff)
        return FALSE;
    return TRUE;
}
-(BOOL)isCurrentLineHasBlackPoint:(uint32_t*)pOrgImageData:(int)pointX :(int)pointY :(int)line :(int)imageWidth
{
    int startPosX = [self initStartPosX:pointX];
    int endPosX = [self initEndPosX:pointX :imageWidth];

    for(int j = startPosX;j != endPosX;j++)
    {
        if(![self isCenterPoint:j :line :pointX :pointY] &&
           ![self isPointWhite:pOrgImageData :imageWidth :j :line])
        {
            return FALSE;
            
        }
        
    }
    return TRUE;
}
-(BOOL)isAlone:(uint32_t*)pOrgImageData :(int)imageWidth :(int)imageHeight :(int)pointX :(int)pointY
{
    BOOL flag = TRUE;
    
    int startPosY = [self initStartPosY:pointY];
    int endPosY = [self initEndPosY:pointY :imageHeight];
    
    for(int i = startPosY;i != endPosY;i++)
    {
        flag = [self isCurrentLineHasBlackPoint:pOrgImageData  :pointX :pointY :i :imageWidth];
        if(!flag)
            break;
    }
    return flag;
}


-(SingleNote*)getPointSetBytag:(int)t :(NSMutableArray*)noteSet
{
    SingleNote *back;
    for (SingleNote *set in noteSet) 
    {
        if([set getTag] == t)
        {
            back = set;
            break;
        }
    }
    return back;
}

-(void)setPointColorAsItsUp:(uint32_t*)pOrgImageData :(int)pointY :(int)imageWidth :(int)pointX
{
    pOrgImageData[pointY*imageWidth+pointX] = pOrgImageData[(pointY-1)*imageWidth+pointX];
}
-(BOOL)isBelongNote:(uint32_t*)pOrgImageData:(int)pointX :(int)pointY :(int)imageWidth
{
    if(pointX >= 1&&pointY >= 1)
    {
        if([self isPointWhite:pOrgImageData :imageWidth :pointX :pointY-1])//白色
        {
            return FALSE;
        }else
        {
            [self setPointColorAsItsUp:pOrgImageData :pointY :imageWidth :pointX];
            return TRUE;
        }
        
    }else
    {
        return TRUE;
    }
}
-(void)removeCurrentLine:(uint32_t*)pOrgImageData :(int)lineCount :(int)imageWidth
{
    for(int j = 0;j != imageWidth;j++)
    {
        if(![self isBelongNote:pOrgImageData :j :lineCount :imageWidth])
        {
            pOrgImageData[lineCount*imageWidth+j] =
            0xffffffff;
        }
        
    }
}
-(int)getBlackPointCount:(uint32_t*)pOrgImageData:(int)imageWidth :(int)line :(int*)count
{
    for(int j=0;j != imageWidth;j++)
    {
        if(pOrgImageData[line*imageWidth+j] != 0xffffffff)
        {
            (*count)++;
        }
        
    }
    return *count;
}
-(BOOL)currentLineisSpectrum:(uint32_t*)pOrgImageData :(int)imageWidth :(int)line :(int*)count
{
    [self getBlackPointCount:pOrgImageData :imageWidth :line :count];
    if(*count > 7*imageWidth/8)
        return TRUE;
    return FALSE;
}

//这个函数以及内部函数正在修改中
-(uint32_t*)removeSpectrum:(uint32_t *)pOrgImageData :(int)imageWidth :(int)imageHeight
{
    int count = 0;
    for(int i = 0;i != imageHeight;i++)
    {
        if([self currentLineisSpectrum:pOrgImageData :imageWidth :i :&count])
        {
            [self removeCurrentLine:pOrgImageData :i :imageWidth];
        }
        count = 0;
    }
    return pOrgImageData;
}


-(BOOL)isCurrentPointVisited:(uint32_t*)recordData:(int)pointX :(int)pointY :(int)imageWidth
{
    if(recordData[pointY*imageWidth+pointX] == -1)
        return FALSE;
    return TRUE;
    
}

-(void)putPointToSingleNote:(uint32_t*)pOrgImageData:(uint32_t*)recordData :(SingleNote*)pointArray :(int)pointX :(int)pointY :(int)imageWidth
{
    uint32_t color = pOrgImageData[pointY*imageWidth+pointX];
    PosPoint *point = [[PosPoint alloc]init];
    [point setPosX:pointX];
    [point setPosY:pointY];
    [point setColorSpace:color];
    [[pointArray getPointSet] addObject:point];
    recordData[pointY*imageWidth+pointX] = [pointArray getTag];
}
-(BOOL)isPointInSingleNote :(uint32_t*)recordData :(int)pointX :(int)pointY :(int)imageWidth :(SingleNote*)pointArray
{
    if(recordData[pointY*imageWidth+pointX]==[pointArray getTag])
        return TRUE;
    return FALSE;
}
-(void)changeReordData:(uint32_t*)recordData :(int)posX :(int)posY :(int)imageWidth :(SingleNote*)destArray
{
    recordData[posY*imageWidth+posX] = [destArray getTag];
}
-(void)copyPoint:(SingleNote*)orgArray :(SingleNote*)destArray :(int)imageWidth:(uint32_t*)recordData :(NSMutableArray*)arraySet
{
    
    NSMutableArray *dest = [destArray getPointSet];
    for (PosPoint *point in [orgArray getPointSet]) 
    {
        [dest addObject:point];
        [self changeReordData:recordData :[point getPosX] :[point getPosY] :imageWidth :destArray];
        
    }
    [arraySet removeObject:orgArray];
}
-(SingleNote*)getSingleNoteByTag:(int)tag :(NSMutableArray*)noteSet
{
    SingleNote *singleNote;
    for (SingleNote *note in noteSet) 
    {
        if([note getTag]==tag)
        {
            singleNote = note;
            break;
        }
    }
    if(singleNote!=nil)
        return singleNote;
    return nil;
}
-(SingleNote*)getSingleNote:(uint32_t*)recordData:(int)posX :(int)posY :(int)imageWidth :(NSMutableArray*)noteSet
{
    int tag = [self getTag:recordData :posX :posY :imageWidth];
    return [self getSingleNoteByTag:tag :noteSet];
}

-(void)addPointToSingleNote:(uint32_t*)pOrgImageData:(SingleNote*)destSingleNote :(int)pointX :(int)pointY :(uint32_t*)recordData :(int)imageWidth :(NSMutableArray*)noteSet
{
    if(![self isCurrentPointVisited:recordData :pointX :pointY :imageWidth])
    {
        [self putPointToSingleNote:(uint32_t*)pOrgImageData:recordData :destSingleNote :pointX :pointY :imageWidth];
    }
    else
    {
        if(![self isPointInSingleNote:recordData :pointX :pointY :imageWidth :destSingleNote])
        {
            SingleNote *oriSingleNote = [self getSingleNote:recordData :pointX :pointY :imageWidth :noteSet];
            
            if(oriSingleNote!=nil)
                [self copyPoint:oriSingleNote :destSingleNote :imageWidth :recordData :noteSet];
        }
    }
    
    
}

-(void)pushCurrentLinePoints:(uint32_t*)pOrgImageData:(int)lineCount :(int)imageWidth :(NSMutableArray*)arr :(SingleNote*)pointArraySet :(int)pointX :(int)pointY :(uint32_t*)recordData
{
    int startPosX = [self initStartPosX:pointX];
    int endPosX = [self initEndPosX:pointX :imageWidth];
    for(int j = startPosX;j!= endPosX;j++)
    {
        if(![self isCenterPoint:j :lineCount :pointY :pointX] &&
           ![self isPointWhite:pOrgImageData :imageWidth :j :lineCount])
        {
            [self addPointToSingleNote:(uint32_t*)pOrgImageData:pointArraySet :j :lineCount :recordData :imageWidth :arr];
            
        }
    }

    
}
-(SingleNote*)createSingleNote:(int*)count
{
    SingleNote *singleNote = [[SingleNote alloc]init];
    NSMutableArray *pointSet = [[NSMutableArray alloc]init];
    [singleNote changeTag:*count];
    [singleNote setPointSet:pointSet];
    (*count)++;
    return singleNote;
}
-(void)pushNeighbourPoints:(uint32_t*)pOrgImageData :(int)imageWidth :(int)imageHeight :(NSMutableArray*)arr :(SingleNote*)singleNote :(int)pointX :(int)pointY:(uint32_t*)recordData
{
    int startPosY = [self initStartPosY:pointY];
    int endPosY = [self initEndPosY:pointY :imageHeight];
    
    for (int i = startPosY; i != endPosY; i++)
    {
        [self pushCurrentLinePoints:pOrgImageData :i :imageWidth :arr :singleNote :pointX :pointY :recordData];
    }
}

-(void)pushCurrentPointAndNeighbourPoints:(uint32_t*)pOrgImageData:(int*)count :(int)pointX :(int)pointY :(uint32_t*)recordData :(int)imageWidth :(int)imageHeight :(NSMutableArray*)noteSet
{
    SingleNote *singleNote = [self createSingleNote:count];
    
    [self addPointToSingleNote:(uint32_t*)pOrgImageData:singleNote :pointX :pointY :recordData :imageWidth :noteSet];
    
    [self pushNeighbourPoints:pOrgImageData :imageWidth :imageHeight :noteSet :singleNote :pointX :pointY :recordData];
    
    [noteSet addObject:singleNote]; 
}


-(void)push:(uint32_t*)pOrgImageData:(NSMutableArray*)noteSet :(int)pointX :(int)pointY :(int)imageWidth :(int)imageHeight :(int*)count :(uint32_t*)recordData
{
 
    if(![self isCurrentPointVisited:recordData :pointX :pointY :imageWidth])
    {
        [self pushCurrentPointAndNeighbourPoints:pOrgImageData :count :pointX :pointY :recordData :imageWidth :imageHeight :noteSet];
    }
    else
    { 
        
        SingleNote *singleNote = [self getSingleNote:recordData :pointX :pointY :imageWidth :noteSet];
        
        [self pushNeighbourPoints:pOrgImageData :imageWidth :imageHeight :noteSet :singleNote :pointX :pointY :recordData];
    }
}

-(BOOL)isPointWhiteAndAlone:(uint32_t*)data :(int)imageWidth :(int)imageHeight :(int)posX :(int)posY
{
    if(![self isPointWhite:data :imageWidth :posX :posY])
        return [self isAlone:data :imageWidth :imageHeight :posX :posY];
    
    return TRUE;
    
}
-(void)pushNotAlonePoint:(uint32_t*)data :(int)imageWidth :(int)imageHeight :(int)line :(int*)tag :(uint32_t*)recordData :(NSMutableArray*)noteSet
{
    for(int j=0;j<imageWidth;j++)
    {
        if(![self isPointWhiteAndAlone:data :imageWidth :imageHeight :j :line])
        {
            [self push:data :noteSet :j :line :imageWidth :imageHeight :tag :recordData];
        }
    }

}

-(uint32_t*)initRecordData:(int)imageWidth :(int)imageHeight
{
    uint32_t *recordData = malloc(imageWidth*imageHeight*sizeof(int));
    for(int i=0;i!=imageWidth*imageHeight;i++)
    {
        recordData[i] = -1;
    }
    return recordData;
}
-(void)calculateAverageXValue :(NSMutableArray*)noteSet
{
    int temp = 0;
    for (SingleNote *set in noteSet)
    {
        [set setPosAverage:0];
        for (PosPoint *p in [set getPointSet])
        {
            temp +=[p getPosX];
        }
        temp = temp / [[set getPointSet] count];
        [set setPosAverage:temp];
    } 
}
-(SingleNote*)getAverPosXMinSingleNote:(NSMutableArray*)noteSet
{
    SingleNote  *min = [noteSet objectAtIndex:0];
    for(int j = 1;j != [noteSet count];j++)
    { 
        if([[noteSet objectAtIndex:j] getPosAverage]<[min getPosAverage])
        {
            min = [noteSet objectAtIndex:j];
        }
    }
    return min;
}
-(NSMutableArray*)getOrderedNoteSet:(NSMutableArray*)noteSet
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    SingleNote *min;
    int count = [noteSet count];
    for(int i = 1;i != count;i++)
    {
        if([noteSet count]>0)
            min = [noteSet objectAtIndex:0];
        else
            break;
        min = [self getAverPosXMinSingleNote:noteSet];
        [arr addObject:min];
        [noteSet removeObject:min];
    }
    
    return arr;

}

-(NSMutableArray*)sequence:(NSMutableArray*)noteSet
{
    [self calculateAverageXValue:noteSet];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    SingleNote *min;
    int count = [noteSet count];
    for(int i = 1;i != count;i++)
    {
        if([noteSet count]>0)
            min = [noteSet objectAtIndex:0];
        else
            break;
        min = [self getAverPosXMinSingleNote:noteSet];
        [arr addObject:min];
        [noteSet removeObject:min];
    }

    noteSet = arr;
    return noteSet;
}
-(NSMutableArray*)getNoteSet:(uint32_t*)data :(int)imageWidth :(int)imageHeight :(int*)tag :(uint32_t*)recordData 
{
    NSMutableArray* noteSet = [[NSMutableArray alloc]init];
    for(int i = 0;i != imageHeight;i++)
    {
        [self pushNotAlonePoint:data :imageWidth :imageHeight :i :tag :recordData :noteSet];
        
    }
    return noteSet;
}
-(NoteSet*)getAllNote :(uint32_t*)pOrgImageData :(int)imageWidth :(int)imageHeight
{
    
    int tag = 0;
    uint32_t* data = [self removeSpectrum:pOrgImageData :imageWidth :imageHeight];
    
    uint32_t *recordData = [self initRecordData:imageWidth :imageHeight];
    
    NSMutableArray *noteSet = [self getNoteSet:data :imageWidth :imageHeight :&tag:recordData];
    NSMutableArray *noteSetFinal = [self sequence:noteSet];
    NoteSet *myNoteSet = [[NoteSet alloc]init];
    [myNoteSet add:noteSetFinal];
    return myNoteSet;
}
@end
