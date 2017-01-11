//
//  chatViewController.m
//  sticker
//
//  Created by ichiban on 16/12/28.
//  Copyright © 2016年 ichiban. All rights reserved.
//

#define stikerTag    19991001

#import "chatViewController.h"
#import "UIViewController+YTPAccessoryInputView.h"

typedef NS_ENUM(NSInteger, CHATVIEWTYPE) {
    CHATVIEWTYPE_NONE,
    CHATVIEWTYPE_FACE,
    CHATVIEWTYPE_KEYBOARD
};


@interface chatViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *faceButton;
@property (weak, nonatomic) IBOutlet UIView *chatView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatViewBottomConstains;
@property (weak, nonatomic) IBOutlet UITextField *chatTextField;
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;

@property(nonatomic,strong) NSLayoutConstraint *stickerViewConstraisHeight;

@property (nonatomic,strong) NSArray *stickers;
@end

@implementation chatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _configDelegate];
    //    [self _addKeyBoardNotifactionCenter];
    //    [self _configStikerView];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)faceButton:(UIButton *)sender {
    [self ytp_toggleAccessoryInputViewWithButton:self.faceButton];
}
-(void) _configDelegate{
    self.chatTextField.delegate = self;
    self.chatTableView.delegate =self;
    self.chatTableView.dataSource = self;
    
}

#pragma mark -config stikerView
-(NSArray *)stickers{
    if (!_stickers) {
        NSMutableArray *result = [NSMutableArray array];
        for (int i = 0; i <100; i++) {
            NSString *stikerName = [NSString stringWithFormat:@"图形1_%02d",i+1];
            if ([UIImage imageNamed:stikerName]) {
                [result addObject:stikerName];
            }
        }
        _stickers = result;
    }
    return _stickers;
}
-(void)updateViewConstraints{
    [super updateViewConstraints];
    [self _configStikerView];
}
-(void) _configStikerView {
    CGFloat screenWidth = CGRectGetWidth(self.view.bounds);
    NSLog(@"%f",screenWidth);
    UIScrollView *stickerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds)*0.5)];
    int numberOfViews = (int)self.stickers.count/18+1;
    stickerView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds)*numberOfViews, CGRectGetWidth(self.view.bounds)*0.5);
    for (int i= 0; i < self.stickers.count; ++i) {
        int x = (i/18) * 6 + i%6;
        int y = (i%18)/6;
        NSInteger stikerWidth = CGRectGetWidth(self.view.bounds)/6;
        NSInteger stikerHeight = CGRectGetWidth(self.view.bounds)/6;
        UIButton *stickerButton = [[UIButton alloc]initWithFrame:CGRectMake(x*stikerWidth, y*stikerHeight,stikerWidth , stikerHeight)];
        stickerButton.tag = stikerTag + i;
        [stickerButton setImage:[UIImage imageNamed:self.stickers[i]] forState:UIControlStateNormal];
        [stickerButton addTarget:self action:@selector(stikerClicked:) forControlEvents:UIControlEventTouchUpInside];
        stickerButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [stickerView addSubview:stickerButton];
    }
    self.accessoryInputView = stickerView;
    self.inputToolBar = self.chatView;
    self.inputToolBarBottomSpace = self.chatViewBottomConstains;
    [self ytp_configureAccessoryInputView];
    
    //    self.stickerView.scrollEnabled = true;
}
-(void)stikerClicked:(UIButton *) button{
    NSString *str = [NSString stringWithFormat:@"%@ [%ld] ",self.chatTextField.text,button.tag-stikerTag];
    self.chatTextField.text = str;
    NSLog(@"the %ldth clicker has been clicked",button.tag-stikerTag);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"stickerCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"stickerCell"];
    }
    cell.backgroundColor = [UIColor colorWithRed:255/self.stickers.count*indexPath.row green:255/self.stickers.count*indexPath.row blue:255 alpha:0.7];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.stickers.count;
}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self ytp_dismissKeyboardOrAccessoryInputView];
}


@end
