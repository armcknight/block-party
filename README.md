# Block Party!
Lego of the delegate pattern.

## De-delegatized
- UINavigationController
```objective-c
[self.navigationController prt_pushViewController:someViewController
      animated:YES
      preparation:^(UINavigationController *navigationController,
                    UIViewController *presentingViewController) {
          NSLog(@"Hi! I execute before the nav push!");
      }
      completion:^(UINavigationController *navigationController,
                   UIViewController *presentedViewController,
                   NSArray *poppedViewControllers) {
          NSLog(@"Hi! I execute after the nav push!");
      }];
```

## Utilities
- PRTAssert
```objective-c
PRTAssert(^BOOL { return YES == NO; },
          ^{ NSLog(@"passed :D"); },
          ^{ NSLog(@"failed D:"); },
          @"Uh, hello, YES and NO are as unequivalent as it gets.")
