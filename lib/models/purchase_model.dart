import 'dart:typed_data';

class PurchaseModel {
  String? sellerName;
  String? sellerPhone;
  String? sellerIdNumber;
  String? sellerIdPhotoPath; // Path or url
  
  String? deviceModel;
  String? deviceCapacity;
  String? imei;
  String? serialNumber;
  String? deviceDetails;
  
  List<String> deviceImagesPaths; // Paths or urls
  
  double? pricePaid;
  
  Uint8List? customerSignature;
  
  PurchaseModel({
    this.sellerName,
    this.sellerPhone,
    this.sellerIdNumber,
    this.sellerIdPhotoPath,
    this.deviceModel,
    this.deviceCapacity,
    this.imei,
    this.serialNumber,
    this.deviceDetails,
    this.deviceImagesPaths = const [],
    this.pricePaid,
    this.customerSignature,
  });
}
