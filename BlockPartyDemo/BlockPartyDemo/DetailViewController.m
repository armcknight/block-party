//
//  DetailViewController.m
//  BlockPartyDemo
//
//  Created by Andrew McKnight (personal) on 2/11/15.
//  Copyright (c) 2015 Andrew McKnight. All rights reserved.
//

#import "DetailViewController.h"

#import "NavBlocksDemoViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UIViewController *demoVC;
  switch (self.demo) {
    case PRTDemoNavBlocks:
      demoVC = [[NavBlocksDemoViewController alloc] initWithNibName:nil bundle:nil];
      break;
      
    default:
      break;
  }
  [self addChildViewController:demoVC];
  [self.view addSubview:demoVC.view];
}

@end
