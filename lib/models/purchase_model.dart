import 'dart:convert';
import 'dart:typed_data';

class PurchaseModel {
  int? id; // null hasta que el Worker lo asigna (INSERT). Lo usa update/delete.
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
    this.id,
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
        id: id,
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

  // El Worker habla camelCase (ver toApi en backend/src/index.js).
  // La firma viaja como base64; las fechas como ISO-8601.
  Map<String, dynamic> toJson() => {
        'sellerName': sellerName,
        'sellerPhone': sellerPhone,
        'sellerIdNumber': sellerIdNumber,
        'sellerIdPhotoPath': sellerIdPhotoPath,
        'purchaseMomentPhotoPath': purchaseMomentPhotoPath,
        'deviceModel': deviceModel,
        'deviceCapacity': deviceCapacity,
        'imei': imei,
        'serialNumber': serialNumber,
        'deviceDetails': deviceDetails,
        'deviceImagesPaths': deviceImagesPaths,
        'pricePaid': pricePaid,
        'customerSignature':
            customerSignature == null ? null : base64Encode(customerSignature!),
        'createdAt': createdAt?.toIso8601String(),
      };

  factory PurchaseModel.fromJson(Map<String, dynamic> j) => PurchaseModel(
        id: j['id'] as int?,
        sellerName: j['sellerName'] as String?,
        sellerPhone: j['sellerPhone'] as String?,
        sellerIdNumber: j['sellerIdNumber'] as String?,
        sellerIdPhotoPath: j['sellerIdPhotoPath'] as String?,
        purchaseMomentPhotoPath: j['purchaseMomentPhotoPath'] as String?,
        deviceModel: j['deviceModel'] as String?,
        deviceCapacity: j['deviceCapacity'] as String?,
        imei: j['imei'] as String?,
        serialNumber: j['serialNumber'] as String?,
        deviceDetails: j['deviceDetails'] as String?,
        deviceImagesPaths: (j['deviceImagesPaths'] as List?)?.cast<String>() ?? const [],
        pricePaid: (j['pricePaid'] as num?)?.toDouble(),
        customerSignature: j['customerSignature'] == null
            ? null
            : base64Decode(j['customerSignature'] as String),
        createdAt: j['createdAt'] == null
            ? null
            : DateTime.tryParse(j['createdAt'] as String),
      );
}
