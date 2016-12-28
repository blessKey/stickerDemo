//
//  chatViewController.m
//  sticker
//
//  Created by ichiban on 16/12/28.
//  Copyright © 2016年 ichiban. All rights reserved.
//

#define stikerTag    19991001

#import "chatViewController.h"

@interface chatViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *faceButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatViewBottomConstains;
@property (weak, nonatomic) IBOutlet UITextField *chatTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *stickerView;
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;

@property (nonatomic,strong) NSArray *stickers;
@end

@implementation chatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _configDelegate];
    [self _addKeyBoardNotifactionCenter];
    [self _configStikerView];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)faceButton:(UIButton *)sender {
    NSLog(@"faceButtonClicked");
    if (sender.selected) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.chatTextField becomeFirstResponder];
        }];
    }
    else{
        [UIView animateWithDuration:0.5 animations:^{
            [self.chatTextField resignFirstResponder];
            self.chatViewBottomConstains.constant = CGRectGetWidth(self.view.bounds)*0.5;
        }];
        
    }
    sender.selected = !sender.selected;
}
-(void) _configDelegate{
    self.chatTextField.delegate = self;
    self.chatTableView.delegate =self;
    self.chatTableView.dataSource = self;
    self.stickerView.delegate = self;
}
#pragma mark-add notifactioncenter for keyboard
-(void) _addKeyBoardNotifactionCenter{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
}
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSLog(@"keyboardWillShow,%@",self.chatTextField.isFirstResponder?@"yes":@"no");
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    [UIView animateWithDuration:0.5 animations:^{
        self.chatViewBottomConstains.constant = height;
    }];
}
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSLog(@"keyboardWillHide");
    
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
-(void) _configStikerView {
    int numberOfViews = (int)self.stickers.count/18+1;
    self.stickerView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds)*numberOfViews, CGRectGetWidth(self.view.bounds)*0.5);
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
        [self.stickerView addSubview:stickerButton];
    }
    self.stickerView.scrollEnabled = true;
}
-(void)stikerClicked:(UIButton *) button{
    NSLog(@"the %ldth clicker has been clicked",button.tag-stikerTag);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"chatCell"];
    }
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44)];
    [button setTitle:[NSString stringWithFormat:@"%@",indexPath] forState:UIControlStateNormal];
    [cell addSubview:button];
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.chatTextField resignFirstResponder];
    self.chatViewBottomConstains.constant = 0;
    self.faceButton.selected = false;
}

#pragma mark -scrollViewDelegate
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [UIView animateWithDuration:0.1 animations:^{
        NSInteger screenWidth = CGRectGetWidth(self.view.bounds);
        NSInteger x = scrollView.contentOffset.x;
        int num = (int)(x+0.5*screenWidth)/screenWidth;
        x = num * screenWidth;
        scrollView.contentOffset = CGPointMake(x, 0);
    }];
}

@end
