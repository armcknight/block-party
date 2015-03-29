//
//  DetailViewController.m
//  BlockPartyDemo
//
//  Created by Andrew McKnight on 2/11/15.
//  Copyright (c) 2015 Andrew McKnight. All rights reserved.
//

#import "DetailViewController.h"

#import "NavBlocksDemoViewController.h"
#import "AssertDemoViewController.h"
#import "BluetoothBlocksDemoViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (BOOL)extendedLayoutIncludesOpaqueBars {
  return NO;
}

- (UIRectEdge)edgesForExtendedLayout {
  return UIRectEdgeLeft | UIRectEdgeRight | UIRectEdgeBottom;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  UIViewController *demoVC;
  switch (self.demo) {
    case PRTDemoNavBlocks:
      demoVC =
          [[NavBlocksDemoViewController alloc] initWithNibName:nil bundle:nil];
      break;
    case PRTDemoAsserts:
      demoVC =
          [[AssertDemoViewController alloc] initWithNibName:nil bundle:nil];
    case PRTDemoBluetooth:
      demoVC = [[BluetoothBlocksDemoViewController alloc] initWithNibName:nil
                                                                   bundle:nil];
    default:
      break;
  }
  [self addChildViewController:demoVC];
  [self.view addSubview:demoVC.view];
  UIView *subview = demoVC.view;
  subview.translatesAutoresizingMaskIntoConstraints = NO;
  NSDictionary *dict = NSDictionaryOfVariableBindings(subview);
  [self.view addConstraints:[NSLayoutConstraint
                                constraintsWithVisualFormat:@"H:|-[subview]-|"
                                                    options:0
                                                    metrics:0
                                                      views:dict]];
  [self.view addConstraints:[NSLayoutConstraint
                                constraintsWithVisualFormat:@"V:|-[subview]-|"
                                                    options:0
                                                    metrics:0
                                                      views:dict]];
}

@end
