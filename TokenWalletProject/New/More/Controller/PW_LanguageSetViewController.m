//
//  PW_LanguageSetViewController.m
//  TokenWalletProject
//
//  Created by mnz on 2022/4/17.
//  Copyright © 2022 . All rights reserved.
//

#import "PW_LanguageSetViewController.h"
#import "PW_LanguageCell.h"

@interface PW_LanguageSetViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) PW_TableView *tableView;
@property (nonatomic, strong) NSMutableArray<PW_LanguageModel *> *dataArr;

@property (nonatomic, strong) LanguageModel *oldLanguageModel;

@end

@implementation PW_LanguageSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavNoLineTitle:LocalizedStr(@"text_multilingual") rightTitle:LocalizedStr(@"text_finish") rightAction:@selector(finishAction)];
    [self.rightBtn setTitleColor:[UIColor g_primaryColor] forState:UIControlStateNormal];
    [self makeViews];
    self.oldLanguageModel = [LanguageTool currentLanguage];
}
- (void)finishAction {
    PW_LanguageModel *model = nil;
    for (PW_LanguageModel *obj in self.dataArr) {
        if (obj.selected) {
            model = obj;
            break;
        }
    }
    if (model) {
        [LanguageTool setLanguageType:model.type];
        if (self.changeBlock) {
            self.changeBlock(model);
        }
        if(![self.oldLanguageModel.type isEqualToString:model.type]){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [TheAppDelegate resetApp];
            });
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)makeViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.naviBar.mas_bottom).offset(20);
        make.left.right.bottom.offset(0);
    }];
}
#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_LanguageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PW_LanguageCell"];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PW_LanguageModel *model = self.dataArr[indexPath.row];
    for (PW_LanguageModel *obj in self.dataArr) {
        obj.selected = NO;
    }
    model.selected = YES;
    [tableView reloadData];
}
#pragma mark - lazy
- (PW_TableView *)tableView {
    if (!_tableView) {
        _tableView = [[PW_TableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 72;
        [_tableView registerClass:[PW_LanguageCell class] forCellReuseIdentifier:@"PW_LanguageCell"];
    }
    return _tableView;
}
- (NSMutableArray<PW_LanguageModel *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        NSArray *array = [LanguageTool shared].languages;
        NSString *currentType = [LanguageTool currentLanguage].type;
        for (LanguageModel *obj in array) {
            PW_LanguageModel *model = [[PW_LanguageModel alloc] init];
            model.name = obj.name;
            model.type = obj.type;
            model.languageCode = obj.languageCode;
            model.selected = [currentType isEqualToString:obj.type];
            [_dataArr addObject:model];
        }
    }
    return _dataArr;
}

@end
