//
//  CBPeripheralManager+PRTBlocks.m
//  BlockPartyDemo
//
//  Created by Andrew McKnight on 3/28/15.
//  Copyright (c) 2015 Andrew McKnight. All rights reserved.
//

#import "CBPeripheralManager+PRTBlocks.h"

#import <objc/runtime.h>

static const void *kPRTCBPeripheralManagerDelegateKey =
    &kPRTCBPeripheralManagerDelegateKey;

@interface PRTCBPeripheralManagerDelegate
    : NSObject<CBPeripheralManagerDelegate>

@property(strong, nonatomic) NSMutableDictionary *callbackSelectorBlockMap;
@property(weak, nonatomic) id<CBPeripheralManagerDelegate> previousDelegate;

@end

@implementation PRTCBPeripheralManagerDelegate

- (instancetype)init {
  self = [super init];
  if (self) {
    _callbackSelectorBlockMap = [NSMutableDictionary dictionary];
  }
  return self;
}

#pragma mark - CBPeripheralManagerDelegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
  PRTPeriphalManagerBlock handler =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (handler) {
    handler(peripheral);
  }
  if ([self.previousDelegate respondsToSelector:_cmd]) {
    [self.previousDelegate peripheralManagerDidUpdateState:peripheral];
  }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral
         willRestoreState:(NSDictionary *)dict {
  PRTPeripheralManagerStateRestoreBlock handler =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (handler) {
    handler(peripheral, dict);
  }
  if ([self.previousDelegate respondsToSelector:_cmd]) {
    [self.previousDelegate peripheralManager:peripheral willRestoreState:dict];
  }
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral
                                       error:(NSError *)error {
  PRTPeripheralManagerAdvertisingBlock handler =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (handler) {
    handler(peripheral, error);
  }
  if ([self.previousDelegate respondsToSelector:_cmd]) {
    [self.previousDelegate peripheralManagerDidStartAdvertising:peripheral
                                                          error:error];
  }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral
            didAddService:(CBService *)service
                    error:(NSError *)error {
  PRTPeripheralManagerServiceBlock handler =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (handler) {
    handler(peripheral, service, error);
  }
  if ([self.previousDelegate respondsToSelector:_cmd]) {
    [self.previousDelegate peripheralManager:peripheral
                               didAddService:service
                                       error:error];
  }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral
                         central:(CBCentral *)central
    didSubscribeToCharacteristic:(CBCharacteristic *)characteristic {
  PRTPeripheralManagerCharacteristicBlock handler =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (handler) {
    handler(peripheral, central, characteristic);
  }
  if ([self.previousDelegate respondsToSelector:_cmd]) {
    [self.previousDelegate peripheralManager:peripheral
                                     central:central
                didSubscribeToCharacteristic:characteristic];
  }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral
                             central:(CBCentral *)central
    didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic {
  PRTPeripheralManagerCharacteristicBlock handler =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (handler) {
    handler(peripheral, central, characteristic);
  }
  if ([self.previousDelegate respondsToSelector:_cmd]) {
    [self.previousDelegate peripheralManager:peripheral
                                     central:central
            didUnsubscribeFromCharacteristic:characteristic];
  }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral
    didReceiveReadRequest:(CBATTRequest *)request {
  PRTPeripheralManagerReadRequestBlock handler =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (handler) {
    handler(peripheral, request);
  }
  if ([self.previousDelegate respondsToSelector:_cmd]) {
    [self.previousDelegate peripheralManager:peripheral
                       didReceiveReadRequest:request];
  }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral
    didReceiveWriteRequests:(NSArray *)requests {
  PRTPeripheralManagerWriteRequestsBlock handler =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (handler) {
    handler(peripheral, requests);
  }
  if ([self.previousDelegate respondsToSelector:_cmd]) {
    [self.previousDelegate peripheralManager:peripheral
                     didReceiveWriteRequests:requests];
  }
}

- (void)peripheralManagerIsReadyToUpdateSubscribers:
        (CBPeripheralManager *)peripheral {
  PRTPeriphalManagerBlock handler =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (handler) {
    handler(peripheral);
  }
  if ([self.previousDelegate respondsToSelector:_cmd]) {
    [self.previousDelegate
        peripheralManagerIsReadyToUpdateSubscribers:peripheral];
  }
}

@end

@implementation CBPeripheralManager (PRTBlocks)

#pragma mark - Public

- (void)prt_peripheralManagerDidUpdateStateHandler:
        (PRTPeriphalManagerBlock)handler {
  [self prt_setBlock:handler
         forSelector:@selector(peripheralManagerDidUpdateState:)];
}

- (void)prt_peripheralManagerWillRestoreStateHandler:
        (PRTPeripheralManagerStateRestoreBlock)handler {
  [self prt_setBlock:handler
         forSelector:@selector(prt_peripheralManagerWillRestoreStateHandler:)];
}

- (void)prt_startAdvertising:(NSDictionary *)advertisementData
                  completion:(PRTPeripheralManagerAdvertisingBlock)completion {
  [self prt_setBlock:completion
         forSelector:@selector(peripheralManagerDidStartAdvertising:error:)];
  [self startAdvertising:advertisementData];
}

- (void)prt_addService:(CBMutableService *)service
            completion:(PRTPeripheralManagerServiceBlock)completion {
  [self prt_setBlock:completion
         forSelector:@selector(peripheralManager:didAddService:error:)];
  [self addService:service];
}

- (void)prt_peripheralManagerDidSubscribeToCharacteristicHandler:
        (PRTPeripheralManagerCharacteristicBlock)handler {
  [self prt_setBlock:handler
         forSelector:@selector(peripheralManager:
                                              central:
                         didSubscribeToCharacteristic:)];
}

- (void)prt_peripheralManagerDidUnsubscribeToCharacteristicHandler:
        (PRTPeripheralManagerCharacteristicBlock)handler {
  [self prt_setBlock:handler
         forSelector:@selector(peripheralManager:central:
                         didUnsubscribeFromCharacteristic:)];
}

- (void)prt_peripheralManagerDidReceiveReadRequestHandler:
        (PRTPeripheralManagerReadRequestBlock)handler {
  [self prt_setBlock:handler
         forSelector:@selector(peripheralManager:didReceiveReadRequest:)];
}

- (void)prt_peripheralManagerDidReceiveWriteRequestsHandler:
        (PRTPeripheralManagerWriteRequestsBlock)handler {
  [self prt_setBlock:handler
         forSelector:@selector(peripheralManager:didReceiveWriteRequests:)];
}

- (void)prt_peripheralManagerIsReadyToUpdateSubscribersHandler:
        (PRTPeriphalManagerBlock)handler {
  [self prt_setBlock:handler
         forSelector:@selector(peripheralManagerIsReadyToUpdateSubscribers:)];
}

#pragma mark - Private

- (void)prt_setBlock:(id)block forSelector:(SEL)selector {
  [[self prt_delegate] callbackSelectorBlockMap][NSStringFromSelector(
      selector)] = [block copy];
}

- (PRTCBPeripheralManagerDelegate *)prt_delegate {
  static PRTCBPeripheralManagerDelegate *delegate;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    delegate = [PRTCBPeripheralManagerDelegate new];
    delegate.previousDelegate = self.delegate;
    self.delegate = delegate;
    objc_setAssociatedObject(self, kPRTCBPeripheralManagerDelegateKey, delegate,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  });
  return delegate;
}

@end
