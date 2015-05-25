//
//  CBPeripheral+PRTBlocks.h
//  BlockPartyDemo
//
//  Created by Andrew McKnight on 3/22/15.
//  Copyright (c) 2015 Andrew McKnight. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

typedef void (^PRTRSSIBlock)(CBPeripheral *peripheral, NSNumber *RSSI,
                             NSError *error);

typedef void (^PRTPeripheralBlock)(CBPeripheral *peripheral, NSError *error);
typedef void (^PRTInvalidatedServicesBlock)(CBPeripheral *peripheral,
                                            NSArray *invalidatedServices);

typedef void (^PRTServiceBlock)(CBPeripheral *peripheral, CBService *service,
                                NSError *error);
typedef void (^PRTCharacteristicBlock)(CBPeripheral *peripheral,
                                       CBCharacteristic *characteristic,
                                       NSError *error);
typedef void (^PRTDescriptorBlock)(CBPeripheral *peripheral,
                                   CBDescriptor *descriptor,
                                   NSError *error);
@interface CBPeripheral (PRTBlocks)

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 6

- (void)prt_peripheralDidUpdateNameHandler:(PRTPeripheralBlock)handler;

#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 7
- (void)prt_peripheralDidInvalidateServicesHandler:(PRTPeripheralBlock)handler;

#else
- (void)prt_peripheralDidModifyServicesHandler:
    (PRTInvalidatedServicesBlock)handler;

#endif
- (void)prt_readRSSIWithCompletion:(PRTRSSIBlock)completion;

- (void)prt_discoverServices:(NSArray *)serviceUUIDs
                  completion:(PRTPeripheralBlock)completion;

- (void)prt_discoverIncludedServices:(NSArray *)includedServiceUUIDs
                          forService:(CBService *)service
                          completion:(PRTServiceBlock)completion;

- (void)prt_discoverCharacteristics:(NSArray *)characteristicUUIDs
                         forService:(CBService *)service
                         completion:(PRTServiceBlock)completion;

/**
 *  Writes a value to the specified characteristic and performs the provided
 *block for the @c peripheral:didWriteValueForCharacteristic:error: delegate
 *callback. Always performs a write with type @c
 *CBCharacteristicWriteWithResponse.
 *
 *  @param data           Value to write to the characteristic.
 *  @param characteristic Characteristic to which to write the value.
 *  @param completion     Block to execute on receipt of @c
 *peripheral:didWriteValueForCharacteristic:error:
 */
- (void)prt_writeValue:(NSData *)data
     forCharacteristic:(CBCharacteristic *)characteristic
            completion:(PRTCharacteristicBlock)completion;

- (void)prt_characteristicUpdateHandler:(PRTCharacteristicBlock)handler;

- (void)prt_setNotifyValue:(BOOL)enabled
         forCharacteristic:(CBCharacteristic *)characteristic
                completion:(PRTCharacteristicBlock)completion;

- (void)
    prt_discoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic
                                  completion:
                                      (PRTCharacteristicBlock)completion;

- (void)prt_writeValue:(NSData *)data
         forDescriptor:(CBDescriptor *)descriptor
            completion:(PRTDescriptorBlock)completion;

- (void)prt_descriptorUpdateHandler:(PRTDescriptorBlock)handler;

@end
