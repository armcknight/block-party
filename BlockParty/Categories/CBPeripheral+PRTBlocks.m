//
//  CBPeripheral+PRTBlocks.m
//  BlockPartyDemo
//
//  Created by Andrew McKnight on 3/22/15.
//  Copyright (c) 2015 Andrew McKnight. All rights reserved.
//

#import "CBPeripheral+PRTBlocks.h"

#import <objc/runtime.h>

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

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 6

- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral {
  PRTPeripheralBlock handler =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (handler) {
    handler(peripheral, nil);
  }
  if ([self.previousDelegate respondsToSelector:_cmd]) {
    [self.previousDelegate peripheralDidUpdateName:peripheral];
  }
}

#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 7

- (void)peripheralDidInvalidateServices:(CBPeripheral *)peripheral {
  PRTPeripheralBlock handler =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (handler) {
    handler(peripheral, nil);
  }
  if ([self.previousDelegate respondsToSelector:_cmd]) {
    [self.previousDelegate peripheralDidInvalidateServices:peripheral];
  }
}

#else

- (void)peripheral:(CBPeripheral *)peripheral
 didModifyServices:(NSArray *)invalidatedServices {
  PRTInvalidatedServicesBlock handler =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (handler) {
    handler(peripheral, invalidatedServices);
  }
  if ([self.previousDelegate respondsToSelector:_cmd]) {
    [self.previousDelegate peripheral:peripheral
                    didModifyServices:invalidatedServices];
  }
}

#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 8

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral
                          error:(NSError *)error {
  PRTRSSIBlock completion =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (completion) {
    completion(peripheral, RSSI, error);
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
    completion(peripheral, RSSI, error);
  }
  if ([self.previousDelegate respondsToSelector:_cmd]) {
    [self.previousDelegate peripheral:peripheral didReadRSSI:RSSI error:error];
  }
}

#endif

- (void)peripheral:(CBPeripheral *)peripheral
    didDiscoverServices:(NSError *)error {
  PRTPeripheralBlock completion =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (completion) {
    completion(peripheral, error);
  }
  if ([self.previousDelegate respondsToSelector:_cmd]) {
    [self.previousDelegate peripheral:peripheral didDiscoverServices:error];
  }
}

- (void)peripheral:(CBPeripheral *)peripheral
    didDiscoverIncludedServicesForService:(CBService *)service
                                    error:(NSError *)error {
  PRTServiceBlock completion =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (completion) {
    completion(peripheral, service, error);
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
  PRTServiceBlock completion =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (completion) {
    completion(peripheral, service, error);
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
  PRTCharacteristicBlock completion =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (completion) {
    completion(peripheral, characteristic, error);
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
  PRTCharacteristicBlock completion =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (completion) {
    completion(peripheral, characteristic, error);
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
  PRTCharacteristicBlock completion =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (completion) {
    completion(peripheral, characteristic, error);
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
  PRTCharacteristicBlock completion =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (completion) {
    completion(peripheral, characteristic, error);
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
  PRTDescriptorBlock completion =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (completion) {
    completion(peripheral, descriptor, error);
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
  PRTDescriptorBlock completion =
      self.callbackSelectorBlockMap[NSStringFromSelector(_cmd)];
  if (completion) {
    completion(peripheral, descriptor, error);
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

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 6

- (void)prt_peripheralDidUpdateNameHandler:(PRTPeripheralBlock)handler {
  [[self prt_delegate] callbackSelectorBlockMap][NSStringFromSelector(
      @selector(peripheralDidUpdateName:))] = [handler copy];
}

#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 7

- (void)prt_peripheralDidInvalidateServicesHandler:(PRTPeripheralBlock)handler {
  [[self prt_delegate] callbackSelectorBlockMap][NSStringFromSelector(
      @selector(peripheralDidInvalidateServices:))] = [handler copy];
}

#else

- (void)prt_peripheralDidModifyServicesHandler:
    (PRTInvalidatedServicesBlock)handler {
  [[self prt_delegate] callbackSelectorBlockMap][NSStringFromSelector(
      @selector(peripheral:didModifyServices:))] = [handler copy];
}

#endif

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
                  completion:(PRTPeripheralBlock)completion {
  [[self prt_delegate] callbackSelectorBlockMap][NSStringFromSelector(
      @selector(peripheral:didDiscoverServices:))] = [completion copy];
  [self discoverServices:serviceUUIDs];
}

- (void)prt_discoverIncludedServices:(NSArray *)includedServiceUUIDs
                          forService:(CBService *)service
                          completion:(PRTServiceBlock)completion {
  [[self prt_delegate] callbackSelectorBlockMap][NSStringFromSelector(
      @selector(peripheral:didDiscoverIncludedServicesForService:error:))] =
      [completion copy];
  [self discoverIncludedServices:includedServiceUUIDs forService:service];
}

- (void)prt_discoverCharacteristics:(NSArray *)characteristicUUIDs
                         forService:(CBService *)service
                         completion:(PRTServiceBlock)completion {
  [[self prt_delegate] callbackSelectorBlockMap][NSStringFromSelector(
      @selector(peripheral:didDiscoverCharacteristicsForService:error:))] =
      [completion copy];
  [self discoverCharacteristics:characteristicUUIDs forService:service];
}

- (void)prt_writeValue:(NSData *)data
     forCharacteristic:(CBCharacteristic *)characteristic
            completion:(PRTCharacteristicBlock)completion {
  PRTCBPeripheralDelegate *delegate = [self prt_delegate];
  [delegate callbackSelectorBlockMap][NSStringFromSelector(
      @selector(peripheral:didWriteValueForCharacteristic:error:))] =
      [completion copy];
  [self writeValue:data
      forCharacteristic:characteristic
                   type:CBCharacteristicWriteWithResponse];
}

- (void)prt_characteristicUpdateHandler:(PRTCharacteristicBlock)handler {
  [[self prt_delegate] callbackSelectorBlockMap][NSStringFromSelector(
      @selector(peripheral:didUpdateValueForCharacteristic:error:))] =
      [handler copy];
}

- (void)prt_setNotifyValue:(BOOL)enabled
         forCharacteristic:(CBCharacteristic *)characteristic
                completion:(PRTCharacteristicBlock)completion {
  [[self prt_delegate] callbackSelectorBlockMap][NSStringFromSelector(@selector(
                                       peripheral:
      didUpdateNotificationStateForCharacteristic:
                                            error:))] = [completion copy];
  [self setNotifyValue:enabled forCharacteristic:characteristic];
}

- (void)
    prt_discoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic
                                  completion:
                                      (PRTCharacteristicBlock)completion {
  [[self prt_delegate] callbackSelectorBlockMap][NSStringFromSelector(
      @selector(peripheral:didDiscoverDescriptorsForCharacteristic:error:))] =
      [completion copy];
  [self discoverDescriptorsForCharacteristic:characteristic];
}

- (void)prt_descriptorUpdateHandler:(PRTDescriptorBlock)handler {
  [[self prt_delegate] callbackSelectorBlockMap][NSStringFromSelector(
      @selector(peripheral:didUpdateValueForDescriptor:error:))] =
      [handler copy];
}

- (void)prt_writeValue:(NSData *)data
         forDescriptor:(CBDescriptor *)descriptor
            completion:(PRTDescriptorBlock)completion {
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
