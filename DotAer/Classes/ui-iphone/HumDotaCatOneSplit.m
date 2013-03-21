//
//  HumDotaCatOneSplit.m
//  DotAer
//
//  Created by Kyle on 13-1-25.
//  Copyright (c) 2013年 KyleYang. All rights reserved.
//

#import "HumDotaCatOneSplit.h"
#import "BqsUtils.h"

#define kCatScrollX 3
#define kCatScrollH 50
#define kCatScrollPaddY 0


@interface HumDotaCatOneSplit()<HumDotaCatTwoSelViewDelegate>

@end

@implementation HumDotaCatOneSplit
@synthesize cateScroll;
@synthesize arrCateOne;
@synthesize arrCateTwo;


- (void)dealloc{
    self.cateScroll = nil;
    self.arrCateOne = nil;
    self.arrCateTwo = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithDotaCatFrameViewCtl:(HumDotaBaseViewController *)ctl Frame:(CGRect)frame{
    self = [super initWithDotaCatFrameViewCtl:ctl Frame:frame];
    if (self) {
        
        _nOneCurIdx = -1;
        _nTwoCurIdx = -1;
        
        // category scroll view
        self.cateScroll = [[[HumDotaCatTwoSelView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topNav.frame), CGRectGetWidth(frame), kCatScrollH)] autorelease];
        self.cateScroll.delegate = self;
        
        CGRect cframe = CGRectMake(0, kTopNavHeigh+kCatScrollH, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - kTopNavHeigh-kCatScrollPaddY-kCatScrollH);
        self.contentView.frame = cframe;
        
        [self addSubview:cateScroll];
    }
    
    return self;
}

-(HumDotaCateTowBaseView *)createCatTwoViewCatOneIdx:(int)oneIdx TwoInx:(int)twoIdx {
    return [self viewForCatOneIdx:_nOneCurIdx TwoIdx:twoIdx VCtl:self.parCtl Frame:CGRectMake(0, kTopNavHeigh+kCatScrollPaddY+kCatScrollH, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - kTopNavHeigh-kCatScrollPaddY-kCatScrollH)];
}

#pragma mark
#pragma mark HumDotaCatTwoSelViewDelegate

- (void)humDotaCatTwoSelectView:(HumDotaCatTwoSelView *)v DidSelectCatOne:(int)onIdx CatTwo:(int)twoIdx PrevSelect:(int)prevIdx{
    if(_nOneCurIdx == onIdx && _nTwoCurIdx == twoIdx && prevIdx !=-1 ) {
        BqsLog(@"already select _nOneCurIdx: %d _nTwoCurIdx: %d", onIdx,twoIdx);
        return;
    }
    
    _nOneCurIdx = onIdx;
    _nTwoCurIdx = twoIdx;
    [self.contentView viewWillDisappear];
    
    HumDotaCateTowBaseView *av = [self createCatTwoViewCatOneIdx:_nOneCurIdx TwoInx:_nTwoCurIdx];
    [av viewWillAppear];

    if(prevIdx < 0) {
        
        [self insertSubview:av belowSubview:self.topNav];
        
        [av viewDidAppear];
        
        [self.contentView viewDidDisappear];
        [self.contentView removeFromSuperview];
        
        self.contentView = av;
        
        [self setNeedsLayout];
    } else {
        
        int direct = 1;
        if(prevIdx > _nTwoCurIdx) direct = -1;
        
        CGRect rc = av.frame;
        av.frame = CGRectOffset(rc, direct * CGRectGetWidth(self.bounds), 0);
        [self insertSubview:av belowSubview:self.topNav];
        [av performSelector:@selector(viewDidAppear) withObject:nil afterDelay:.3];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.3];
        
        
        av.frame = rc;
        self.contentView.frame = CGRectOffset(self.contentView.frame, - (direct * CGRectGetWidth(self.contentView.frame)), 0);
        
        [self.contentView performSelector:@selector(viewDidDisappear) withObject:nil afterDelay:.4];
        [self.contentView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:.5];
        
        self.contentView = av;
        
        [UIView commitAnimations];
    }

    
}



#pragma mark - ifc methods
// view show/hide
-(void)viewWillAppear {
    [self.contentView viewWillAppear];
    
    if(_nTwoCurIdx < 0) {
        [self humDotaCatTwoSelectView:self.cateScroll DidSelectCatOne:0 CatTwo:0 PrevSelect:-1];
    }
}

-(void)viewDidAppear {
    [self.contentView viewDidAppear];
}

-(void)viewWillDisappear {
    [self.contentView viewWillDisappear];
}

-(void)viewDidDisappear {
    [self.contentView viewDidDisappear];
}

-(HumDotaCateTowBaseView *)viewForCatOneIdx:(int)oneIdx TwoIdx:(int)twoIdx VCtl:(HumDotaBaseViewController *)vctl Frame:(CGRect)frm {
    return nil;
}




@end