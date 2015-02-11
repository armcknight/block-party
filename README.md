# Block Party!
Lego of the delegate pattern.

## De-delegatized
- UINavigationController

	  [self.navigationController prt_pushViewController:self.vc1
      	animated:animated
      	preparation:^(UINavigationController *navigationController,
                    UIViewController *presentingViewController) {
          NSLog(@"Hi! I execute before the nav push!");
      	}
      	completion:^(UINavigationController *navigationController,
                   UIViewController *presentedViewController,
                   NSArray *poppedViewControllers) {
          NSLog(@"Hi! I execute after the nav push!");
      	}];


## Utilities
- PRTAssert

		PRTAssert(^BOOL { return YES == NO; },
            	  ^{ NSLog(@"passed :D"); },
            	  ^{ NSLog(@"failed D:"); },
            	  @"Uh, hello, YES and NO are as unequivalent as it gets.")