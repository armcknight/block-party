//
//  NavBlocksDemoViewController.m
//  BlockPartyDemo
//
//  Created by Andrew McKnight on 2/11/15.
//  Copyright (c) 2015 Andrew McKnight. All rights reserved.
//

#import "NavBlocksDemoViewController.h"

#import "UINavigationController+PRTBlocks.h"

static NSString *const kPRTUINavigationControllerBlockTestVC1Title =
    @"First VC";
static NSString *const kPRTUINavigationControllerBlockTestVC2Title =
    @"Second VC";
static NSString *const kPRTUINavigationControllerBlockTestVC3Title =
    @"Third VC";
static NSString *const kPRTUINavigationControllerBlockTestVC4Title =
    @"Fourth VC";

@interface NavBlocksDemoViewController () <UINavigationControllerDelegate>

@property(strong, nonatomic) UIViewController *vc1;
@property(strong, nonatomic) UIViewController *vc2;
@property(strong, nonatomic) UIViewController *vc3;
@property(strong, nonatomic) UIViewController *vc4;
@property(strong, nonatomic) NSArray *allVCs;

@end

@implementation NavBlocksDemoViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.vc1 = [[UIViewController alloc] initWithNibName:nil bundle:nil];
  self.vc1.title = kPRTUINavigationControllerBlockTestVC1Title;
  self.vc1.view.backgroundColor = [UIColor redColor];

  self.vc2 = [[UIViewController alloc] initWithNibName:nil bundle:nil];
  self.vc2.title = kPRTUINavigationControllerBlockTestVC2Title;
  self.vc2.view.backgroundColor = [UIColor greenColor];

  self.vc3 = [[UIViewController alloc] initWithNibName:nil bundle:nil];
  self.vc3.title = kPRTUINavigationControllerBlockTestVC3Title;
  self.vc3.view.backgroundColor = [UIColor blueColor];

  self.vc4 = [[UIViewController alloc] initWithNibName:nil bundle:nil];
  self.vc4.title = kPRTUINavigationControllerBlockTestVC4Title;
  self.vc4.view.backgroundColor = [UIColor yellowColor];

  self.allVCs = @[ self.vc1, self.vc2, self.vc3, self.vc4 ];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  self.navigationController.delegate = self;

  [self pushPopAnimated:YES];

  //  [self.navigationController popToRootViewControllerAnimated:NO];

  //  [self pushPopAnimated:NO];
}

- (void)pushPopAnimated:(BOOL)animated {
  PRTNavigationControllerCompletionBlock popToRootTestBlock =
      ^(UINavigationController *navigationController,
        UIViewController *presentedViewController,
        NSArray *poppedViewControllers) {

      [navigationController prt_popToRootViewControllerAnimated:animated
          preparation:^(UINavigationController *navigationController,
                        UIViewController *presentingViewController) {

          }
          completion:^(UINavigationController *navigationController,
                       UIViewController *presentedViewController,
                       NSArray *poppedViewControllers){

          }];
  };

  PRTNavigationControllerCompletionBlock popMultipleVCsTestBlock =
      ^(UINavigationController *navigationController,
        UIViewController *presentedViewController,
        NSArray *poppedViewControllers) {

      [navigationController prt_setViewControllers:self.allVCs
          animated:animated
          preparation:^(UINavigationController *navigationController,
                        UIViewController *presentingViewController) {

          }
          completion:^(UINavigationController *navigationController,
                       UIViewController *presentedViewController,
                       NSArray *poppedViewControllers) {

              [navigationController
                  prt_popToViewController:self.vc2
                                 animated:animated
                              preparation:^(UINavigationController *
                                                navigationController,
                                            UIViewController *
                                                presentingViewController) {

                              }
                               completion:popToRootTestBlock];

          }];
  };

  PRTNavigationControllerCompletionBlock popOneVCTestBlock =
      ^(UINavigationController *navigationController,
        UIViewController *presentedViewController,
        NSArray *poppedViewControllers) {

      [navigationController
          prt_popViewControllerAnimated:animated
                            preparation:
                                ^(UINavigationController *navigationController,
                                  UIViewController *presentingViewController) {

                                }
                             completion:popMultipleVCsTestBlock];

  };

  PRTNavigationControllerCompletionBlock pushRemainingVCsTestBlock =
      ^(UINavigationController *navigationController,
        UIViewController *presentedViewController,
        NSArray *poppedViewControllers) {

      [navigationController
          prt_setViewControllers:self.allVCs
                        animated:animated
                     preparation:^(UINavigationController *navigationController,
                                   UIViewController *presentingViewController) {

                     }
                      completion:popOneVCTestBlock];

  };

  PRTNavigationControllerCompletionBlock pushSecondVC =
      ^(UINavigationController *navigationController,
        UIViewController *presentedViewController,
        NSArray *poppedViewControllers) {
      [navigationController
          prt_pushViewController:self.vc2
                        animated:animated
                     preparation:^(UINavigationController *navigationController,
                                   UIViewController *presentingViewController) {

                     }
                      completion:pushRemainingVCsTestBlock];
  };

  [self.navigationController
      prt_pushViewController:self.vc1
                    animated:animated
                 preparation:^(UINavigationController *navigationController,
                               UIViewController *presentingViewController) {

                 }
                  completion:pushSecondVC];
}

@end
