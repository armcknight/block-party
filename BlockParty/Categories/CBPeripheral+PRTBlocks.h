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
typedef void (^PRTPeripheralCompletion)(CBPeripheral *peripheral,
                                        NSError *error);
typedef void (^PRTServiceCompletion)(CBPeripheral *peripheral,
                                     CBService *service, NSError *error);
typedef void (^PRTCharacteristicCompletion)(CBPeripheral *peripheral,
                                            CBCharacteristic *characteristic,
                                            NSError *error);
typedef void (^PRTDescriptorCompletion)(CBPeripheral *peripheral,
                                        CBDescriptor *descriptor,
                                        NSError *error);

@interface CBPeripheral (PRTBlocks)

- (void)prt_readRSSIWithCompletion:(PRTRSSIBlock)completion;

- (void)prt_discoverServices:(NSArray *)serviceUUIDs
                  completion:(PRTPeripheralCompletion)completion;

- (void)prt_discoverIncludedServices:(NSArray *)includedServiceUUIDs
                          forService:(CBService *)service
                          completion:(PRTServiceCompletion)completion;

- (void)prt_discoverCharacteristics:(NSArray *)characteristicUUIDs
                         forService:(CBService *)service
                         completion:(PRTServiceCompletion)completion;

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
            completion:(PRTCharacteristicCompletion)completion;

- (void)prt_characteristicUpdateHandler:(PRTCharacteristicCompletion)handler;

- (void)prt_setNotifyValue:(BOOL)enabled
         forCharacteristic:(CBCharacteristic *)characteristic
                completion:(PRTCharacteristicCompletion)completion;

- (void)
    prt_discoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic
                                  completion:
                                      (PRTCharacteristicCompletion)completion;

- (void)prt_writeValue:(NSData *)data
         forDescriptor:(CBDescriptor *)descriptor
            completion:(PRTDescriptorCompletion)completion;

- (void)prt_descriptorUpdateHandler:(PRTDescriptorCompletion)handler;

@end
