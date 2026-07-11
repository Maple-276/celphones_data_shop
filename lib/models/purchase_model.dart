import 'dart:typed_data';

class PurchaseModel {
  String? sellerName;
  String? sellerPhone;
  String? sellerIdNumber;
  String? sellerIdPhotoPath; // Path or url
  String? purchaseMomentPhotoPath; // Foto de la persona en el momento de la compra

  String? deviceModel;
  String? deviceCapacity;
  String? imei;
  String? serialNumber;
  String? deviceDetails;
  
  List<String> deviceImagesPaths; // Paths or urls
  
  double? pricePaid;
  
  Uint8List? customerSignature;

  DateTime? createdAt;

  PurchaseModel({
    this.sellerName,
    this.sellerPhone,
    this.sellerIdNumber,
    this.sellerIdPhotoPath,
    this.purchaseMomentPhotoPath,
    this.deviceModel,
    this.deviceCapacity,
    this.imei,
    this.serialNumber,
    this.deviceDetails,
    this.deviceImagesPaths = const [],
    this.pricePaid,
    this.customerSignature,
    this.createdAt,
  });

  PurchaseModel copy() => PurchaseModel(
        sellerName: sellerName,
        sellerPhone: sellerPhone,
        sellerIdNumber: sellerIdNumber,
        sellerIdPhotoPath: sellerIdPhotoPath,
        purchaseMomentPhotoPath: purchaseMomentPhotoPath,
        deviceModel: deviceModel,
        deviceCapacity: deviceCapacity,
        imei: imei,
        serialNumber: serialNumber,
        deviceDetails: deviceDetails,
        deviceImagesPaths: List.from(deviceImagesPaths),
        pricePaid: pricePaid,
        customerSignature: customerSignature,
        createdAt: createdAt,
      );
}
