//
//  ViewController.m
//  SearchNoteFinally
//
//  Created by gw zhao on 13-3-8.
//  Copyright (c) 2013年 hebust. All rights reserved.
//

#import "ViewController.h"
#import "SimplyBmp.h"
#import "SingleNote.h"
#import "PosPoint.h"

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	UIImage *image = [UIImage imageNamed:@"danhang.bmp"]
    ;
    CGImageRef imageRef = [image CGImage];
    uint32_t *pOrgImageData = malloc(image.size.width*image.size.height*sizeof(int));
    
    int imageWidth = image.size.width;
    int imageHeight = image.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pOrgImageData, imageWidth, imageHeight, 8, 4*imageWidth,colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big );
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), imageRef);
    CGContextRelease(context);
    
    simply = [[SimplyBmp alloc]init];
    
    int destSquireWidth = 10;
    int destSquireHeight = 2;
    uint32_t *destImageData;
    
    destImageData = [simply mergePix:pOrgImageData :imageWidth :imageHeight :destSquireWidth :destSquireHeight];
    
    CGContextRef context1 = CGBitmapContextCreate(destImageData, imageWidth/10+1, imageHeight/2, 8, 4*(imageWidth/10+1),colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big );
    
    CGImageRef imageRef1 = CGBitmapContextCreateImage(context1);
    UIImage *image1 = [[UIImage alloc]initWithCGImage:imageRef1];
    UIImageView *view1 = [[UIImageView alloc]initWithImage:image1];
    view1.frame = CGRectMake(0, 200, image1.size.width, image1.size.height);
    [self.view addSubview:view1];
    
    
    
    
    
    
    clear = [[NoteRecognition alloc]init];
    
    NoteSet *t =  [clear getAllNote :destImageData :imageWidth/10+1 :imageHeight/2];
    uint32_t *d = malloc((imageWidth/10+1)*imageHeight/2*sizeof(int));
    for (int i=0; i<(imageWidth/10+1)*imageHeight/2; i++)
    {
        d[i] = 0xffffffff;
    }
    NSMutableArray *arr = [t next];
    arr = [t next];
    arr = [t next];
    arr = [t next];
    arr = [t next];
    //arr = [t next];
    //arr = [t next];
    //arr = [t next];
   // arr = [t next];
   // arr = [t next];
       
   
    
    for (PosPoint *p in arr) 
    {
        d[[p getPosY]*(imageWidth/10+1)+[p getPosX]] = [p getColorSpace];
    }
    
    CGContextRef context_ = CGBitmapContextCreate(d, imageWidth/10+1, imageHeight/2, 8, 4*(imageWidth/10+1),colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big );

    CGImageRef imageRef_ = CGBitmapContextCreateImage(context_);
    UIImage *image_ = [[UIImage alloc]initWithCGImage:imageRef_];
    UIImageView *view = [[UIImageView alloc]initWithImage:image_];
    [self.view addSubview:view];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
