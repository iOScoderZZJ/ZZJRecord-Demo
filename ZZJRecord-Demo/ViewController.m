//
//  ViewController.m
//  ZZJRecord-Demo
//
//  Created by chefuzzj on 16/12/26.
//  Copyright © 2016年 chefuzzj. All rights reserved.
//

/**
 *  代码还有很大的封装空间,可以根据自己的业务逻辑去编写,我测试了很多次,没什么大问题,如有问题望及时纠正
 *  github地址: https://github.com/iOScoderZZJ
 *  简书地址:   http://www.jianshu.com/users/12e0bbb7297b/latest_articles
 */


#import "ViewController.h"
#import "LVRecordTool.h"
#import "ZZJRecordButton.h"
#import "UIView+ZZJExtension.h"
#define LVRecordFielName @"lvRecord.wav"
#define ZZJScreenW [UIScreen mainScreen].bounds.size.width
#define ZZJScreenH [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<LVRecordToolDelegate>
@property (nonatomic,weak)ZZJRecordButton * recordButton;
//录音工具类
@property(nonatomic,strong)LVRecordTool * recordTool;
//音频时长
@property(nonatomic,assign)CGFloat currentRecordTime;

//录音时  提示的相关view
@property(nonatomic,weak)UIImageView * bgView;
@property(nonatomic,weak)UIImageView * stateImageView;
@property(nonatomic,weak)UILabel * textLabel;


//显示喇叭
@property (nonatomic,strong)UIButton * voiceButton;
//清除录音
@property (nonatomic,strong)UIButton * claerButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.recordTool = [LVRecordTool sharedRecordTool];
    self.recordTool.delegate = self;
    
    ZZJRecordButton * recordButton = [ZZJRecordButton buttonWithType:UIButtonTypeCustom];
    recordButton.frame = CGRectMake(0, ZZJScreenH - 49, ZZJScreenW, 49);
    recordButton.backgroundColor = [UIColor redColor];
    recordButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [recordButton setTitle:@"按住 说话" forState:UIControlStateNormal];
    
    [recordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:recordButton];
    self.recordButton = recordButton;
    //录音相关
    [self toDoRecord];
}

#pragma mark ---- 录音全部状态的监听 以及视图的构建 切换
-(void)toDoRecord
{
    __weak typeof(self) weak_self = self;
    //手指按下
    self.recordButton.recordTouchDownAction = ^(ZZJRecordButton *sender){

        //如果用户没有开启麦克风权限,不能让其录音
        if (![self canRecord]) return ;
        
        NSLog(@"开始录音");
        if (sender.highlighted) {
            sender.highlighted = YES;
            [sender setButtonStateWithRecording];
        }
        [weak_self.recordTool startRecording];
        
        [weak_self removeView];
        [weak_self voiceStateWithImage:@"shuohua" labelText:@"手指上滑 取消发送" isAnimation:YES];
        
    };
    
    //手指抬起
    self.recordButton.recordTouchUpInsideAction = ^(ZZJRecordButton *sender){
        NSLog(@"完成录音");
        [sender setButtonStateWithNormal];
        [self.voiceButton removeFromSuperview];
        [self.claerButton removeFromSuperview];
        weak_self.currentRecordTime = weak_self.recordTool.recorder.currentTime;
        [self setupPlayButton];
        
        [weak_self.recordTool stopRecording];
        [weak_self removeView];
        
    };
    
    //手指滑出按钮
    self.recordButton.recordTouchUpOutsideAction = ^(ZZJRecordButton *sender){
        NSLog(@"取消录音");
        
        [sender setButtonStateWithNormal];
        [weak_self removeView];
    };
    
    
    //中间状态  从 TouchDragInside ---> TouchDragOutside
    self.recordButton.recordTouchDragExitAction = ^(ZZJRecordButton *sender){

        [weak_self removeView];
        [weak_self voiceStateWithImage:@"quxiao" labelText:@"松开手指 取消发送" isAnimation:NO];
    };
    //中间状态  从 TouchDragOutside ---> TouchDragInside
    self.recordButton.recordTouchDragEnterAction = ^(ZZJRecordButton *sender){
        NSLog(@"继续录音");
        
        [weak_self removeView];
        [weak_self voiceStateWithImage:@"shuohua" labelText:@"手指上滑 取消发送" isAnimation:YES];
    };
}

#pragma mark ---- 录音完成后,创建播放的按钮
-(void)setupPlayButton
{
    self.voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.voiceButton setImage:[UIImage imageNamed:@"yuyin4"] forState:(UIControlStateNormal)];
    //播放完成时,按钮会一直持续高亮状态,按钮图片的颜色会被系统默认渲染,写了这句按钮的显示就会正常
    [self.voiceButton setImage:[UIImage imageNamed:@"yuyin4"] forState:UIControlStateHighlighted];
    [self.voiceButton setTitle:[NSString stringWithFormat:@" %.2lf ''",self.currentRecordTime] forState:(UIControlStateNormal)];
    [self.voiceButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.voiceButton.frame = CGRectMake(100, 200, 65, 25);
//    [self.voiceButton setImageEdgeInsets:UIEdgeInsetsMake(2, 0, 2, 20)];
    self.voiceButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.voiceButton addTarget:self action:@selector(voiceButtonPlay) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.voiceButton];
    
    self.claerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.claerButton setImage:[UIImage imageNamed:@"delete"] forState:(UIControlStateNormal)];
    self.claerButton.frame = CGRectMake(166, 200, 15, 15);
    [self.claerButton addTarget:self action:@selector(claerButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.claerButton];
}


#pragma mark ---- 发布语音的状态来创建提示视图
-(void)voiceStateWithImage:(NSString *)imageName labelText:(NSString *)text isAnimation:(BOOL)Animation
{
    UIImageView * bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voice_bg"]];
    bgView.center = [UIApplication sharedApplication].keyWindow.center;
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    self.bgView = bgView;
    
    
    UIImageView * stateImageView;
    if (!Animation) {
        stateImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    }else{
        stateImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
        stateImageView.animationImages = @[[UIImage imageNamed:imageName],
                                           [UIImage imageNamed:@"donghua_one"],
                                           [UIImage imageNamed:@"donghua_two"],
                                           ];
        stateImageView.animationDuration = 0.6;
        [stateImageView startAnimating];
    }
    stateImageView.y = 50;
    stateImageView.x = 80;
    stateImageView.contentMode = UIViewContentModeCenter;
    [self.bgView addSubview:stateImageView];
    self.stateImageView = stateImageView;
    
    
    UILabel * textLabel = [[UILabel alloc] init];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont systemFontOfSize:15];
    textLabel.text = text;
    textLabel.y = CGRectGetMaxY(self.stateImageView.frame) + 25;
    textLabel.x = 0;
    textLabel.width = self.bgView.width;
    textLabel.height = 20;
    [self.bgView addSubview:textLabel];
    self.textLabel = textLabel;
}

#pragma mark ---- 销毁录音提示的视图
-(void)removeView
{
    [self.bgView removeFromSuperview];
    [self.stateImageView removeFromSuperview];
    [self.textLabel removeFromSuperview];
}


#pragma mark --- <LVRecordToolDelegate> 判断语音播放完毕
-(void)recordToolDidFinishPlay:(LVRecordTool *)recordTool
{
    
    self.voiceButton.imageView.image = nil;
    [self.voiceButton setImage:[UIImage imageNamed:@"yuyin4"] forState:UIControlStateHighlighted];
    [self.voiceButton.imageView stopAnimating];
    
}
#pragma mark --- <LVRecordToolDelegate> 音量的回调
-(void)recordTool:(LVRecordTool *)recordTool didstartRecoring:(int)no
{
    //可在这里根据音量的大小进行相关操作
}

#pragma mark --- 播放录音
- (void)voiceButtonPlay {
    [self.recordTool playRecordingFile];
    
    self.voiceButton.imageView.animationImages = @[[UIImage imageNamed:@"yuyin4"],
                                                   [UIImage imageNamed:@"yuyin1"],
                                                   [UIImage imageNamed:@"yuyin2"],
                                                   [UIImage imageNamed:@"yuyin3"]
                                                   ];
    self.voiceButton.imageView.animationDuration = 0.6;
    [self.voiceButton.imageView startAnimating];
}

#pragma mark --- 删除录音
- (void)claerButtonClick{
    [self.recordTool destructionRecordingFile];
    [self.voiceButton removeFromSuperview];
    [self.claerButton removeFromSuperview];
}



//判断是否允许使用麦克风7.0新增的方法requestRecordPermission
-(BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                bCanRecord = YES;
            }
            else {
                bCanRecord = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc] initWithTitle:nil
                                                message:@"app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"
                                               delegate:nil
                                      cancelButtonTitle:@"关闭"
                                      otherButtonTitles:nil] show];
                });
            }
        }];
    }
    return bCanRecord;
}
@end
