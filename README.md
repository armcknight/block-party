# Block Party! <img src="https://img.shields.io/cocoapods/v/BlockParty.svg" />

Lego the delegate pattern.

## De-delegatized

Use Block Party to replace all the delegate callbacks with blocks (or just some--delegate callbacks still fire in all cases).

#### Core Bluetooth (CBCentralManager, CBPeripheral and CBPeripheralManager)
##### CBPeripheralManager
```objective-c
[self.peripheralManager prt_peripheralManagerIsReadyToUpdateSubscribersHandler:
  ^(CBPeripheralManager* manager) {
    [self sendData];
  }];
``` 
    
##### CBPeripheral
```objective-c
[peripheral prt_discoverServices:services
                      completion:^(CBPeripheral* peripheral, NSError* error) {
                        if (error) {
                          NSLog(@"error discovering services %@", error);
                        } else {
                          for (CBService* service in peripheral.services) {
                            if ([service.UUID.UUIDString isEqualToString:TRANSFER_SERVICE_UUID]) {
                              self.foundService = service;
                              NSArray *characteristics = @[ [CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID] ];
                              [self.peripheral discoverCharacteristics:characteristics
                                                            forService:self.foundService];
                              break;
                            }
                        }
                    }
                  }];
```

#### UINavigationController
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
### PRTAssert

Ever wanted a fail-fast assert during development and a graceful exit in production? If you've ever written something like this:
```objective-c
NSAssert(expression, @"something went wrong");
if (expression) {
  NSLog(@"production success code");
} else {
  NSLog(@"production failure code");
}
```
then you can combine the assert and conditional using this utility macro:
```objective-c
PRTAssert(expression,
          ^{ NSLog(@"production success code"); },
          ^{ NSLog(@"production failure code"); },
          @"something went wrong")
```
