//
//  CBCentralManager+PRTBlocks.m
//  BlockPartyDemo
//
//  Created by Andrew McKnight on 3/22/15.
//  Copyright (c) 2015 Andrew McKnight. All rights reserved.
//

#import "CBCentralManager+PRTBlocks.h"

#import <objc/runtime.h>

static const void *kPRTCBCentralManagerDelegateKey =
    &kPRTCBCentralManagerDelegateKey;

@interface PRTCBCentralManagerDelegate : NSObject<CBCentralManagerDelegate>

@property(strong, nonatomic) NSMutableDictionary *callbackSelectorBlockMap;
@property(weak, nonatomic) id<CBCentralManagerDelegate> previousDelegate;

@end

@implementation PRTCBCentralManagerDelegate

- (instancetype)init {
  self = [super init];
  if (self) {
    _callbackSelectorBlockMap = [NSMutableDictionary dictionary];
  }
  return self;
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
  PRTCBCentralBlock completion =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (completion) {
    completion(central);
  }
  if ([self.previousDelegate respondsToSelector:_cmd]) {
    [self.previousDelegate centralManagerDidUpdateState:central];
  }
}

- (void)centralManager:(CBCentralManager *)central
      willRestoreState:(NSDictionary *)dict {
  PRTCBCentralRestoreBlock completion =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (completion) {
    completion(central, dict);
  }
  if ([self.previousDelegate respondsToSelector:_cmd]) {
    [self.previousDelegate centralManager:central willRestoreState:dict];
  }
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 7

- (void)centralManager:(CBCentralManager *)central
    didRetrievePeripherals:(NSArray *)peripherals {
  PRTCBPeripheralsBlock completion =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (completion) {
    completion(central, peripherals);
  }
  if ([self.previousDelegate respondsToSelector:_cmd]) {
    [self.previousDelegate centralManager:central
                   didRetrievePeripherals:peripherals];
  }
}

- (void)centralManager:(CBCentralManager *)central
    didRetrieveConnectedPeripherals:(NSArray *)peripherals {
  PRTCBPeripheralsBlock completion =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (completion) {
    completion(central, peripherals);
  }
  if ([self.previousDelegate respondsToSelector:_cmd]) {
    [self.previousDelegate centralManager:central
          didRetrieveConnectedPeripherals:peripherals];
  }
}

#endif

- (void)centralManager:(CBCentralManager *)central
    didDiscoverPeripheral:(CBPeripheral *)peripheral
        advertisementData:(NSDictionary *)advertisementData
                     RSSI:(NSNumber *)RSSI {
  PRTCBPeripheralFoundBlock completion =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (completion) {
    completion(central, peripheral, advertisementData, RSSI);
  }
  if ([self.previousDelegate respondsToSelector:_cmd]) {
    [self.previousDelegate centralManager:central
                    didDiscoverPeripheral:peripheral
                        advertisementData:advertisementData
                                     RSSI:RSSI];
  }
}

- (void)centralManager:(CBCentralManager *)central
    didConnectPeripheral:(CBPeripheral *)peripheral {
  PRTCBPeripheralBlock completion =
      self.callbackSelectorBlockMap
          [NSStringFromSelector(_cmd)];
  if (completion) {
    completion(central, peripheral, nil);
  }
  if ([self.previousDelegate respondsToSelector:_cmd]) {
    [self.previousDelegate centralManager:central
                     didConnectPeripheral:peripheral];
  }
}

- (void)centralManager:(CBCentralManager *)central
    didFailToConnectPeripheral:(CBPeripheral *)peripheral
                         error:(NSError *)error {
  PRTCBPeripheralBlock completion =
      self.callbackSelectorBlockMap
          [NSStringFromSelector(_cmd)];
  if (completion) {
    completion(central, peripheral, error);
  }
  if ([self.previousDelegate respondsToSelector:_cmd]) {
    [self.previousDelegate centralManager:central
               didFailToConnectPeripheral:peripheral
                                    error:error];
  }
}

- (void)centralManager:(CBCentralManager *)central
    didDisconnectPeripheral:(CBPeripheral *)peripheral
                      error:(NSError *)error {
  PRTCBPeripheralBlock completion =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (completion) {
    completion(central, peripheral, error);
  }
  if ([self.previousDelegate respondsToSelector:_cmd]) {
    [self.previousDelegate centralManager:central
                  didDisconnectPeripheral:peripheral
                                    error:error];
  }
}

@end

@implementation CBCentralManager (PRTBlocks)

#pragma mark - Public

- (void)prt_centralManagerDidUpdateStateHandler:(PRTCBCentralBlock)handler {
  [[self prt_delegate] callbackSelectorBlockMap][NSStringFromSelector(
      @selector(centralManagerDidUpdateState:))] = [handler copy];
}

- (void)prt_centralManagerWillRestoreStateHandler:
        (PRTCBCentralRestoreBlock)handler {
  [[self prt_delegate] callbackSelectorBlockMap][NSStringFromSelector(
      @selector(centralManager:willRestoreState:))] = [handler copy];
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 7

- (void)prt_retrievePeripherals:(NSArray *)peripheralUUIDs
                     completion:(PRTCBPeripheralsBlock)completion {
  [[self prt_delegate] callbackSelectorBlockMap][NSStringFromSelector(
      @selector(centralManager:didRetrievePeripherals:))] = [completion copy];
  [self retrievePeripherals:peripheralUUIDs];
}

- (void)prt_retrieveConnectedPeripheralsWithCompletion:
        (PRTCBPeripheralsBlock)completion {
  [[self prt_delegate] callbackSelectorBlockMap][NSStringFromSelector(
      @selector(centralManager:didRetrieveConnectedPeripherals:))] =
      [completion copy];
}

#endif

- (void)prt_scanForPeripheralsWithServices:(NSArray *)serviceUUIDs
                                   options:(NSDictionary *)options
                                completion:
                                    (PRTCBPeripheralFoundBlock)completion {
  [[self prt_delegate] callbackSelectorBlockMap][NSStringFromSelector(@selector(
             centralManager:
      didDiscoverPeripheral:
          advertisementData:
                       RSSI:))] = [completion copy];
  [self scanForPeripheralsWithServices:serviceUUIDs options:options];
}

- (void)prt_connectPeripheral:(CBPeripheral *)peripheral
                      options:(NSDictionary *)options
                   completion:(PRTCBPeripheralBlock)completion {
  PRTCBCentralManagerDelegate *delegate = [self prt_delegate];
  delegate
      .callbackSelectorBlockMap[NSStringFromSelector(@selector(centralManager:didConnectPeripheral:))] =
      [completion copy];
  delegate
      .callbackSelectorBlockMap[NSStringFromSelector(@selector(centralManager:didFailToConnectPeripheral:error:))] =
      [completion copy];
  [self connectPeripheral:peripheral options:options];
}

- (void)prt_cancelPeripheralConnection:(CBPeripheral *)peripheral
                            completion:(PRTCBPeripheralBlock)completion {
  [[self prt_delegate] callbackSelectorBlockMap][NSStringFromSelector(
      @selector(centralManager:didDisconnectPeripheral:error:))] =
      [completion copy];
  [self cancelPeripheralConnection:peripheral];
}

#pragma mark - Private

- (PRTCBCentralManagerDelegate *)prt_delegate {
  static PRTCBCentralManagerDelegate *delegate;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    delegate = [PRTCBCentralManagerDelegate new];
    delegate.previousDelegate = self.delegate;
    self.delegate = delegate;
    objc_setAssociatedObject(self, kPRTCBCentralManagerDelegateKey, delegate,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  });
  return delegate;
}

@end
