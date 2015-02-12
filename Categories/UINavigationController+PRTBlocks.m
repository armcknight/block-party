//
//  UINavigationController+PRTBlocks.m
//
//  Created by Andrew McKnight on 5/28/14.
//
//  Copyright (c) 2015 Andrew McKnight.
//  http://armcknight.com
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "UINavigationController+PRTBlocks.h"

#import <objc/runtime.h>

static const void * kPRTNavigationControllerCompletionBlockHelperKey = &kPRTNavigationControllerCompletionBlockHelperKey;

@interface PRTUINavigationControllerCompletionBlockHelper : NSObject <UINavigationControllerDelegate>

@property (copy, nonatomic) PRTNavigationControllerCompletionBlock completionBlock;
@property (copy, nonatomic) PRTNavigationControllerPreparationBlock preparationBlock;
@property (strong, nonatomic) NSArray *poppedViewControllers;
@property (weak, nonatomic) id<UINavigationControllerDelegate> previousDelegate;

@end

@implementation PRTUINavigationControllerCompletionBlockHelper

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
  dispatch_async(dispatch_get_main_queue(), ^{
    if ( self.preparationBlock != nil ) {
      PRTNavigationControllerPreparationBlock preparation = self.preparationBlock;
      self.preparationBlock = nil;
      preparation(navigationController, viewController);
    }
    
    if ( [self.previousDelegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)] ) {
      [self.previousDelegate navigationController:navigationController willShowViewController:viewController animated:animated];
    }
  });
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
  // call previous delegate's callback implementation, if any
  
  dispatch_async(dispatch_get_main_queue(), ^{
    if ( [self.previousDelegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)] ) {
      [self.previousDelegate navigationController:navigationController didShowViewController:viewController animated:animated];
    }
    
    // reset the delegates to the way they were before calling the block-based method
    navigationController.delegate = self.previousDelegate;
    self.previousDelegate = nil;
    
    // call the completion block
    if ( self.completionBlock != nil ) {
      PRTNavigationControllerCompletionBlock completion = self.completionBlock;
      self.completionBlock = nil;
      completion(navigationController, viewController, self.poppedViewControllers);
    }
    
    objc_setAssociatedObject(self, kPRTNavigationControllerCompletionBlockHelperKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  });
}

@end

@implementation UINavigationController (PRTBlocks)

#pragma mark - Private

- (PRTUINavigationControllerCompletionBlockHelper *)prt_setupDelegateWithPreparation:(PRTNavigationControllerPreparationBlock)preparation completion:(PRTNavigationControllerCompletionBlock)completion
{
  PRTUINavigationControllerCompletionBlockHelper *helper = [[PRTUINavigationControllerCompletionBlockHelper alloc] init];
  if ( completion != nil || preparation != nil ) {
    helper.previousDelegate = self.delegate;
    self.delegate = helper;
    helper.preparationBlock = preparation;
    helper.completionBlock = completion;
  }
  
  objc_setAssociatedObject(self, kPRTNavigationControllerCompletionBlockHelperKey, helper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  
  return helper;
}

#pragma mark - Public

- (void)prt_pushViewController:(UIViewController *)viewController
                      animated:(BOOL)animated
                   preparation:(PRTNavigationControllerPreparationBlock)preparation
                    completion:(PRTNavigationControllerCompletionBlock)completion
{
  [self prt_setupDelegateWithPreparation:preparation completion:completion];
  [self pushViewController:viewController animated:animated];
}

- (void)prt_popViewControllerAnimated:(BOOL)animated
                          preparation:(PRTNavigationControllerPreparationBlock)preparation
                           completion:(PRTNavigationControllerCompletionBlock)completion
{
  PRTUINavigationControllerCompletionBlockHelper *helper = [self prt_setupDelegateWithPreparation:preparation completion:completion];
  UIViewController *poppedViewController = self.viewControllers.lastObject;
  helper.poppedViewControllers = @[poppedViewController];
  [self popViewControllerAnimated:animated];
}

- (void)prt_popToViewController:(UIViewController *)viewController
                       animated:(BOOL)animated
                    preparation:(PRTNavigationControllerPreparationBlock)preparation
                     completion:(PRTNavigationControllerCompletionBlock)completion
{
  PRTUINavigationControllerCompletionBlockHelper *helper = [self prt_setupDelegateWithPreparation:preparation completion:completion];
  NSUInteger indexOfVCToPopTo = [self.viewControllers indexOfObject:viewController];
  NSArray *poppedViewControllers = [self.viewControllers objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexOfVCToPopTo + 1, self.viewControllers.count - 1 - indexOfVCToPopTo)]];
  helper.poppedViewControllers = poppedViewControllers;
  [self popToViewController:viewController animated:animated];
}

- (void)prt_popToRootViewControllerAnimated:(BOOL)animated
                                preparation:(PRTNavigationControllerPreparationBlock)preparation
                                 completion:(PRTNavigationControllerCompletionBlock)completion
{
  PRTUINavigationControllerCompletionBlockHelper *helper = [self prt_setupDelegateWithPreparation:preparation completion:completion];
  NSArray *poppedViewControllers = [self.viewControllers objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, self.viewControllers.count - 1)]];
  helper.poppedViewControllers = poppedViewControllers;
  [self popToRootViewControllerAnimated:animated];
}

- (void)prt_setViewControllers:(NSArray *)viewControllers
                      animated:(BOOL)animated
                   preparation:(PRTNavigationControllerPreparationBlock)preparation
                    completion:(PRTNavigationControllerCompletionBlock)completion
{
  [self prt_setupDelegateWithPreparation:preparation completion:completion];
  [self setViewControllers:viewControllers animated:animated];
}

@end
