//
//  ZZJRecordButton.m
//  ZZJRecord-Demo
//
//  Created by chefuzzj on 16/12/26.
//  Copyright © 2016年 chefuzzj. All rights reserved.
//

#import "ZZJRecordButton.h"
#define ZZJRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
@implementation ZZJRecordButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self addTarget:self action:@selector(recordTouchDown) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(recordTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
        [self addTarget:self action:@selector(recordTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(recordTouchDragEnter) forControlEvents:UIControlEventTouchDragEnter];
        [self addTarget:self action:@selector(recordTouchDragInside) forControlEvents:UIControlEventTouchDragInside];
        [self addTarget:self action:@selector(recordTouchDragOutside) forControlEvents:UIControlEventTouchDragOutside];
        [self addTarget:self action:@selector(recordTouchDragExit) forControlEvents:UIControlEventTouchDragExit];
    }
    return self;
}

- (void)setButtonStateWithRecording
{
    self.backgroundColor = ZZJRGBColor(181, 14, 30);
    [self setTitle:@"松开 结束" forState:UIControlStateNormal];
}

- (void)setButtonStateWithNormal
{
    self.backgroundColor = [UIColor redColor];
    [self setTitle:@"按住 说话" forState:UIControlStateNormal];
}


#pragma mark -- 事件方法回调
- (void)recordTouchDown
{
    if (self.recordTouchDownAction) {
        self.recordTouchDownAction(self);
    }
}

- (void)recordTouchUpOutside
{
    if (self.recordTouchUpOutsideAction) {
        self.recordTouchUpOutsideAction(self);
    }
}

- (void)recordTouchUpInside
{
    if (self.recordTouchUpInsideAction) {
        self.recordTouchUpInsideAction(self);
    }
}

- (void)recordTouchDragEnter
{
    if (self.recordTouchDragEnterAction) {
        self.recordTouchDragEnterAction(self);
    }
}

- (void)recordTouchDragInside
{
    if (self.recordTouchDragInsideAction) {
        self.recordTouchDragInsideAction(self);
    }
}

- (void)recordTouchDragOutside
{
    if (self.recordTouchDragOutsideAction) {
        self.recordTouchDragOutsideAction(self);
    }
}

- (void)recordTouchDragExit
{
    if (self.recordTouchDragExitAction) {
        self.recordTouchDragExitAction(self);
    }
}

@end
