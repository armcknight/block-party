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

Ever wanted a fail-fast assert during development and a graceful exit in production? If you've ever written something like this:
```objective-c
NSAssert(expression, @"something went wrong");
if (expression) {
      ...
} else {
      ...
}
```
then you can combine the assert and conditional using this utility macro:
```objective-c
PRTAssert(^BOOL { return YES == NO; },
          ^{ NSLog(@"passed :D"); },
          ^{ NSLog(@"failed D:"); },
          @"Uh, hello, YES and NO are as unequivalent as it gets.")
