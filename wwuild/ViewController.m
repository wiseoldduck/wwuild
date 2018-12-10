//
//  ViewController.m
//  wwuild
//
//  Created by Kevin Smith on 8/8/18.
//  Copyright © 2018 Kevin Smith. All rights reserved.
//

#import "ViewController.h"

#import <YYText/YYText.h>
#import <YYText/NSAttributedString+YYText.h>
@interface ViewController ()

@end

@interface DemoConfig:NSObject
  @property (nonatomic, assign) NSUInteger numberOfLines;
  @property (nonatomic, assign) NSLineBreakMode lineBreakMode;

-(instancetype)initWithNumberOfLines:(NSUInteger)numberOfLines lineBreakMode:(NSLineBreakMode)lineBreakMode;
@end

@implementation DemoConfig
-(instancetype)initWithNumberOfLines:(NSUInteger)numberOfLines lineBreakMode:(NSLineBreakMode)lineBreakMode {
  if ((self = [super init]) != nil) {
    _numberOfLines = numberOfLines;
    _lineBreakMode = lineBreakMode;

    return self;
  }
  return nil;
}

-(NSString *)description {
  NSString *lineBreak = nil;
  switch(self.lineBreakMode) {
    case NSLineBreakByTruncatingHead:lineBreak = @"NSLineBreakByTruncatingHead"; break;
    case NSLineBreakByCharWrapping:lineBreak = @"NSLineBreakByCharWrapping"; break;
    case NSLineBreakByClipping:lineBreak = @"NSLineBreakByClipping"; break;
    case NSLineBreakByWordWrapping:lineBreak = @"NSLineBreakByWordWrapping"; break;
    case NSLineBreakByTruncatingTail:lineBreak = @"NSLineBreakByTruncatingTail"; break;
    case NSLineBreakByTruncatingMiddle:lineBreak = @"NSLineBreakByTruncatingMiddle"; break;
    default:lineBreak = @"Unknown?"; break;
  }
  return [NSString stringWithFormat:@"numberOfLines: %d\nlineBreakMode: %@", self.numberOfLines, lineBreak];
}
@end

@implementation ViewController {
  YYLabel *_testYYText;
  UILabel *_reference;

  UILabel *_yyLabelLabel;
  UILabel *_uiLabelLabel;
  UILabel *_description;

  NSUInteger _currentConfig;
  NSArray<DemoConfig *> *_demoConfigs;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  _yyLabelLabel = [[UILabel alloc] init];
  _uiLabelLabel = [[UILabel alloc] init];
  _description = [[UILabel alloc] init];
  _yyLabelLabel.text = @"YYLabel:";
  _yyLabelLabel.font = [UIFont boldSystemFontOfSize:16.0];
  _yyLabelLabel.textColor = [UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0];
  _uiLabelLabel.text = @"UILabel:";
  _uiLabelLabel.font = [UIFont boldSystemFontOfSize:16.0];
  _uiLabelLabel.textColor = [UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0];

  _description.text = @"<Description>";
  _description.font = [UIFont italicSystemFontOfSize:16.0];
  _description.numberOfLines = 0;

  _uiLabelLabel.textColor = [UIColor colorWithRed:0.0 green:0.7 blue:0.0 alpha:1.0];

  _reference = [[UILabel alloc] init];
  _reference.font = [UIFont systemFontOfSize:18.0];
  _testYYText = [[YYLabel alloc] init];

  NSMutableAttributedString *refString = [[NSMutableAttributedString alloc] initWithString:@"View Our Lawyer Directory. See lawyers by practice area. Choose an area of law to find top-rated attorneys near you. Get free legal advice from a Rocket Lawyer On Call Attorney. Real lawyers in your state, who specialize in your issue. Ask your legal question online today!"];
  NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
  ps.lineBreakMode = NSLineBreakByTruncatingHead;
//  ps.lineSpacing = 22; This is just a visually obvious attribute to sanity-check that we are setting a paragraphStyle successfully.
  NSRange psr = (NSRange){.location=0, .length=refString.string.length};
  [refString addAttribute:NSParagraphStyleAttributeName value:ps range:psr];
  NSMutableAttributedString *yyString = [refString mutableCopy];

  _reference.attributedText = refString;
  _testYYText.attributedText = yyString;

  _testYYText.font = [UIFont systemFontOfSize:18.0]; // NOTE this did not work when set on an earlier line (before setting text?)

  [self.view addSubview:_reference];
  [self.view addSubview:_testYYText];
  [self.view addSubview:_yyLabelLabel];
  [self.view addSubview:_uiLabelLabel];
  [self.view addSubview:_description];

  [self _setupConfigs];
  [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)]];
}

static dispatch_once_t init_predicate;

- (void)_setupConfigs {
  dispatch_once(&init_predicate, ^{
    NSMutableArray *setup = [NSMutableArray new];
    for (int i = 0; i <= 3; i++) {
      for (NSLineBreakMode j = NSLineBreakByWordWrapping; j <= NSLineBreakByTruncatingMiddle; j++) {
//        if (j == NSLineBreakByTruncatingHead && i == 2) { _currentConfig = setup.count; }
        if (j == NSLineBreakByClipping) continue;
        [setup addObject:[[DemoConfig alloc] initWithNumberOfLines:i lineBreakMode:j]];
      }

    self->_demoConfigs = [NSArray arrayWithArray:setup];
    }
  });

  [self viewTapped:nil];
}

- (void)viewTapped:(id) sender {
  if (_currentConfig == _demoConfigs.count) _currentConfig = 0;
  DemoConfig *newConfig = _demoConfigs[_currentConfig++];
//  _reference.lineBreakMode = _testYYText.lineBreakMode = newConfig.lineBreakMode; Experimentally trying to only set via attributedText / paragraphStyle.
  _reference.numberOfLines = _testYYText.numberOfLines = newConfig.numberOfLines;
  _description.text = newConfig.description;
  [self.view setNeedsLayout];
}

/** UILabel on top, YYText at center **/
- (void)viewDidLayoutSubviews {
  _testYYText.center = self.view.center;
  _testYYText.bounds = (CGRect) {CGPointZero, (CGSize) {self.view.bounds.size.width, 120.0}};
  _reference.center = (CGPoint) {_testYYText.center.x, _testYYText.center.y - 160.0};
  _reference.bounds = _testYYText.bounds;

  _yyLabelLabel.bounds = (CGRect) {CGPointZero, (CGSize) {self.view.bounds.size.width, _yyLabelLabel.font.lineHeight}};
  CGPoint origin = (CGPoint) {_testYYText.frame.origin.x, _testYYText.frame.origin.y - _yyLabelLabel.bounds.size.height};
  _yyLabelLabel.frame = (CGRect) {origin, _yyLabelLabel.bounds.size};

  _uiLabelLabel.bounds = (CGRect) {CGPointZero, (CGSize) {self.view.bounds.size.width, _uiLabelLabel.font.lineHeight}};
  origin = (CGPoint) {_reference.frame.origin.x, _reference.frame.origin.y - _uiLabelLabel.bounds.size.height};
  _uiLabelLabel.frame = (CGRect) {origin, _uiLabelLabel.bounds.size};

  _description.bounds = _testYYText.bounds;
  _description.frame = (CGRect) {(CGPoint){0, self.view.bounds.size.height*0.8}, _description.bounds.size };
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
