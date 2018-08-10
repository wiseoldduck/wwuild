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

@implementation ViewController {
  YYLabel *_testYYText;
  UILabel *_reference;


}

- (void)viewDidLoad {
  [super viewDidLoad];

  _reference = [[UILabel alloc] init];

  _reference.font = [UIFont systemFontOfSize:18.0];
  _testYYText = [[YYLabel alloc] init];

  NSMutableAttributedString *refString = [[NSMutableAttributedString alloc] initWithString:@"View Our Lawyer Directory. See lawyers by practice area. Choose an area of law to find top-rated attorneys near you. Get free legal advice from a Rocket Lawyer On Call Attorney. Real lawyers in your state, who specialize in your issue. Ask your legal question online today!"];
//  refString.yy_lineBreakMode = NSLineBreakByTruncatingMiddle; // NOTE this isn't doing jack for either - which is expected
  NSMutableAttributedString *yyString = [refString mutableCopy];

  _reference.attributedText = refString;
  _testYYText.attributedText = yyString;

  _testYYText.numberOfLines = _reference.numberOfLines = 0;
  _testYYText.font = [UIFont systemFontOfSize:18.0]; // NOTE this did not work when set on an earlier line (before setting text?)

  [self.view addSubview:_reference];
  [self.view addSubview:_testYYText];

  _testYYText.lineBreakMode = NSLineBreakByTruncatingHead;
  _reference.lineBreakMode = NSLineBreakByTruncatingHead;

  NSLog(@"%@", _reference.attributedText);
  NSLog(@"%@", _testYYText.attributedText);
}

/** UILabel on top, YYText at center **/
- (void)viewDidLayoutSubviews {
  _testYYText.center = self.view.center;
  _testYYText.bounds = (CGRect) {CGPointZero, (CGSize) {self.view.bounds.size.width, 120.0}};

  _reference.center = (CGPoint) {_testYYText.center.x, _testYYText.center.y - 160.0};
  _reference.bounds = _testYYText.bounds;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
