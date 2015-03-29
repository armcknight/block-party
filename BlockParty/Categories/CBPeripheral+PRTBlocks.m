//
//  CBPeripheral+PRTBlocks.m
//  BlockPartyDemo
//
//  Created by Andrew McKnight on 3/22/15.
//  Copyright (c) 2015 Andrew McKnight. All rights reserved.
//

#import "CBPeripheral+PRTBlocks.h"

#import <objc/runtime.h>

#define PRT_EXECUTE_ON_MAIN_THREAD(block)      \
  dispatch_async(dispatch_get_main_queue(), ^{ \
    block;                                     \
  })

static const void *kPRTCBPeripheralDelegateKey = &kPRTCBPeripheralDelegateKey;

@interface PRTCBPeripheralDelegate : NSObject<CBPeripheralDelegate>

@property(strong, nonatomic) NSMutableDictionary *callbackSelectorBlockMap;
@property(weak, nonatomic) id<CBPeripheralDelegate> previousDelegate;

@end

@implementation PRTCBPeripheralDelegate

- (instancetype)init {
  self = [super init];
  if (self) {
    _callbackSelectorBlockMap = [NSMutableDictionary dictionary];
  }
  return self;
}

#pragma mark - CBPeripheralDelegate

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 8

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral
                          error:(NSError *)error {
  PRTRSSIBlock completion =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (completion) {
    PRT_EXECUTE_ON_MAIN_THREAD(completion(peripheral, RSSI, error));
  }
  if ([self.previousDelegate respondsToSelector:_cmd]) {
    [self.previousDelegate peripheralDidUpdateRSSI:peripheral error:error];
  }
}

#else

- (void)peripheral:(CBPeripheral *)peripheral
       didReadRSSI:(NSNumber *)RSSI
             error:(NSError *)error {
  PRTRSSIBlock completion =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (completion) {
    PRT_EXECUTE_ON_MAIN_THREAD(completion(peripheral, RSSI, error));
  }
  if ([self.previousDelegate respondsToSelector:_cmd]) {
    [self.previousDelegate peripheral:peripheral didReadRSSI:RSSI error:error];
  }
}

#endif

- (void)peripheral:(CBPeripheral *)peripheral
    didDiscoverServices:(NSError *)error {
  PRTPeripheralCompletion completion =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (completion) {
    PRT_EXECUTE_ON_MAIN_THREAD(completion(peripheral, error));
  }
  if ([self.previousDelegate respondsToSelector:_cmd]) {
    [self.previousDelegate peripheral:peripheral didDiscoverServices:error];
  }
}

- (void)peripheral:(CBPeripheral *)peripheral
    didDiscoverIncludedServicesForService:(CBService *)service
                                    error:(NSError *)error {
  PRTServiceCompletion completion =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (completion) {
    PRT_EXECUTE_ON_MAIN_THREAD(completion(peripheral, service, error));
  }
  if ([self.previousDelegate respondsToSelector:_cmd]) {
    [self.previousDelegate peripheral:peripheral
        didDiscoverIncludedServicesForService:service
                                        error:error];
  }
}

- (void)peripheral:(CBPeripheral *)peripheral
    didDiscoverCharacteristicsForService:(CBService *)service
                                   error:(NSError *)error {
  PRTServiceCompletion completion =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (completion) {
    PRT_EXECUTE_ON_MAIN_THREAD(completion(peripheral, service, error));
  }
  if ([self.previousDelegate respondsToSelector:_cmd]) {
    [self.previousDelegate peripheral:peripheral
        didDiscoverCharacteristicsForService:service
                                       error:error];
  }
}

- (void)peripheral:(CBPeripheral *)peripheral
    didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
                              error:(NSError *)error {
  PRTCharacteristicCompletion completion =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (completion) {
    PRT_EXECUTE_ON_MAIN_THREAD(completion(peripheral, characteristic, error));
  }
  if ([self.previousDelegate respondsToSelector:_cmd]) {
    [self.previousDelegate peripheral:peripheral
        didUpdateValueForCharacteristic:characteristic
                                  error:error];
  }
}

- (void)peripheral:(CBPeripheral *)peripheral
    didWriteValueForCharacteristic:(CBCharacteristic *)characteristic
                             error:(NSError *)error {
  PRTCharacteristicCompletion completion =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (completion) {
    PRT_EXECUTE_ON_MAIN_THREAD(completion(peripheral, characteristic, error));
  }
  if ([self.previousDelegate respondsToSelector:_cmd]) {
    [self.previousDelegate peripheral:peripheral
        didWriteValueForCharacteristic:characteristic
                                 error:error];
  }
}

- (void)peripheral:(CBPeripheral *)peripheral
    didUpdateNotificationStateForCharacteristic:
        (CBCharacteristic *)characteristic
                                          error:(NSError *)error {
  PRTCharacteristicCompletion completion =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (completion) {
    PRT_EXECUTE_ON_MAIN_THREAD(completion(peripheral, characteristic, error));
  }
  if ([self.previousDelegate respondsToSelector:_cmd]) {
    [self.previousDelegate peripheral:peripheral
        didUpdateNotificationStateForCharacteristic:characteristic
                                              error:error];
  }
}

- (void)peripheral:(CBPeripheral *)peripheral
    didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic
                                      error:(NSError *)error {
  PRTCharacteristicCompletion completion =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (completion) {
    PRT_EXECUTE_ON_MAIN_THREAD(completion(peripheral, characteristic, error));
  }
  if ([self.previousDelegate respondsToSelector:_cmd]) {
    [self.previousDelegate peripheral:peripheral
        didDiscoverDescriptorsForCharacteristic:characteristic
                                          error:error];
  }
}

- (void)peripheral:(CBPeripheral *)peripheral
    didUpdateValueForDescriptor:(CBDescriptor *)descriptor
                          error:(NSError *)error {
  PRTDescriptorCompletion completion =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (completion) {
    PRT_EXECUTE_ON_MAIN_THREAD(completion(peripheral, descriptor, error));
  }
  if ([self.previousDelegate respondsToSelector:_cmd]) {
    [self.previousDelegate peripheral:peripheral
          didUpdateValueForDescriptor:descriptor
                                error:error];
  }
}

- (void)peripheral:(CBPeripheral *)peripheral
    didWriteValueForDescriptor:(CBDescriptor *)descriptor
                         error:(NSError *)error {
  PRTDescriptorCompletion completion =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (completion) {
    PRT_EXECUTE_ON_MAIN_THREAD(completion(peripheral, descriptor, error));
  }
  if ([self.previousDelegate respondsToSelector:_cmd]) {
    [self.previousDelegate peripheral:peripheral
           didWriteValueForDescriptor:descriptor
                                error:error];
  }
}

@end

@implementation CBPeripheral (PRTBlocks)

#pragma mark - Public

- (void)prt_readRSSIWithCompletion:(PRTRSSIBlock)completion {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 8
  [[self prt_delegate] callbackSelectorBlockMap][NSStringFromSelector(
      @selector(peripheralDidUpdateRSSI:error:))] = [completion copy];
#else
  [[self prt_delegate] callbackSelectorBlockMap][NSStringFromSelector(
      @selector(peripheral:didReadRSSI:error:))] = [completion copy];
#endif
  [self readRSSI];
}

- (void)prt_discoverServices:(NSArray *)serviceUUIDs
                  completion:(PRTPeripheralCompletion)completion {
  [[self prt_delegate] callbackSelectorBlockMap][NSStringFromSelector(
      @selector(peripheral:didDiscoverServices:))] = [completion copy];
  [self discoverServices:serviceUUIDs];
}

- (void)prt_discoverIncludedServices:(NSArray *)includedServiceUUIDs
                          forService:(CBService *)service
                          completion:(PRTServiceCompletion)completion {
  [[self prt_delegate] callbackSelectorBlockMap][NSStringFromSelector(
      @selector(peripheral:didDiscoverIncludedServicesForService:error:))] =
      [completion copy];
  [self discoverIncludedServices:includedServiceUUIDs forService:service];
}

- (void)prt_discoverCharacteristics:(NSArray *)characteristicUUIDs
                         forService:(CBService *)service
                         completion:(PRTServiceCompletion)completion {
  [[self prt_delegate] callbackSelectorBlockMap][NSStringFromSelector(
      @selector(peripheral:didDiscoverCharacteristicsForService:error:))] =
      [completion copy];
  [self discoverCharacteristics:characteristicUUIDs forService:service];
}

- (void)prt_writeValue:(NSData *)data
     forCharacteristic:(CBCharacteristic *)characteristic
            completion:(PRTCharacteristicCompletion)completion {
  PRTCBPeripheralDelegate *delegate = [self prt_delegate];
  [delegate callbackSelectorBlockMap][NSStringFromSelector(
      @selector(peripheral:didWriteValueForCharacteristic:error:))] =
      [completion copy];
  [self writeValue:data
      forCharacteristic:characteristic
                   type:CBCharacteristicWriteWithResponse];
}

- (void)prt_characteristicUpdateHandler:(PRTCharacteristicCompletion)handler {
  [[self prt_delegate] callbackSelectorBlockMap][NSStringFromSelector(
      @selector(peripheral:didUpdateValueForCharacteristic:error:))] =
      [handler copy];
}

- (void)prt_setNotifyValue:(BOOL)enabled
         forCharacteristic:(CBCharacteristic *)characteristic
                completion:(PRTCharacteristicCompletion)completion {
  [[self prt_delegate] callbackSelectorBlockMap][NSStringFromSelector(@selector(
                                       peripheral:
      didUpdateNotificationStateForCharacteristic:
                                            error:))] = [completion copy];
  [self setNotifyValue:enabled forCharacteristic:characteristic];
}

- (void)
    prt_discoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic
                                  completion:
                                      (PRTCharacteristicCompletion)completion {
  [[self prt_delegate] callbackSelectorBlockMap][NSStringFromSelector(
      @selector(peripheral:didDiscoverDescriptorsForCharacteristic:error:))] =
      [completion copy];
  [self discoverDescriptorsForCharacteristic:characteristic];
}

- (void)prt_descriptorUpdateHandler:(PRTDescriptorCompletion)handler {
  [[self prt_delegate] callbackSelectorBlockMap][NSStringFromSelector(
      @selector(peripheral:didUpdateValueForDescriptor:error:))] =
      [handler copy];
}

- (void)prt_writeValue:(NSData *)data
         forDescriptor:(CBDescriptor *)descriptor
            completion:(PRTDescriptorCompletion)completion {
  PRTCBPeripheralDelegate *delegate = [self prt_delegate];
  [delegate callbackSelectorBlockMap][NSStringFromSelector(
      @selector(peripheral:didWriteValueForDescriptor:error:))] =
      [completion copy];
  [self writeValue:data forDescriptor:descriptor];
}

#pragma mark - Private

- (PRTCBPeripheralDelegate *)prt_delegate {
  static PRTCBPeripheralDelegate *delegate;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    delegate = [PRTCBPeripheralDelegate new];
    delegate.previousDelegate = self.delegate;
    self.delegate = delegate;
    objc_setAssociatedObject(self, kPRTCBPeripheralDelegateKey, delegate,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  });
  return delegate;
}

@end
