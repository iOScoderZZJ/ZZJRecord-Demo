//
//  ZZJRecordButton.h
//  ZZJRecord-Demo
//
//  Created by chefuzzj on 16/12/26.
//  Copyright © 2016年 chefuzzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZJRecordButton;

typedef void (^RecordTouchDown)         (ZZJRecordButton *recordButton);
typedef void (^RecordTouchUpOutside)    (ZZJRecordButton *recordButton);
typedef void (^RecordTouchUpInside)     (ZZJRecordButton *recordButton);
typedef void (^RecordTouchDragEnter)    (ZZJRecordButton *recordButton);
typedef void (^RecordTouchDragInside)   (ZZJRecordButton *recordButton);
typedef void (^RecordTouchDragOutside)  (ZZJRecordButton *recordButton);
typedef void (^RecordTouchDragExit)     (ZZJRecordButton *recordButton);

@interface ZZJRecordButton : UIButton

@property (nonatomic, copy) RecordTouchDown         recordTouchDownAction;
@property (nonatomic, copy) RecordTouchUpOutside    recordTouchUpOutsideAction;
@property (nonatomic, copy) RecordTouchUpInside     recordTouchUpInsideAction;
@property (nonatomic, copy) RecordTouchDragEnter    recordTouchDragEnterAction;
@property (nonatomic, copy) RecordTouchDragInside   recordTouchDragInsideAction;
@property (nonatomic, copy) RecordTouchDragOutside  recordTouchDragOutsideAction;
@property (nonatomic, copy) RecordTouchDragExit     recordTouchDragExitAction;

- (void)setButtonStateWithRecording;
- (void)setButtonStateWithNormal;

@end
