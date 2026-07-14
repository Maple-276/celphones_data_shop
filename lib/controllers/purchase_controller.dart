import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/purchase_model.dart';
import '../data/purchase_api.dart';
import 'package:image_picker/image_picker.dart';

class PurchaseController extends ChangeNotifier {
  final PurchaseModel purchaseData;
  final PurchaseModel? _editing; // Si existe, se actualiza en vez de agregar.
  final ImagePicker _picker = ImagePicker();

  // Controllers for text fields
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final idNumberController = TextEditingController();
  final deviceModelController = TextEditingController();
  final deviceCapacityController = TextEditingController();
  final imeiController = TextEditingController();
  final snController = TextEditingController();
  final detailsController = TextEditingController();
  final priceController = TextEditingController();

  PurchaseController({PurchaseModel? existing})
      : purchaseData = existing?.copy() ?? PurchaseModel(),
        _editing = existing {
    nameController.text = purchaseData.sellerName ?? '';
    phoneController.text = purchaseData.sellerPhone ?? '';
    idNumberController.text = purchaseData.sellerIdNumber ?? '';
    deviceModelController.text = purchaseData.deviceModel ?? '';
    deviceCapacityController.text = purchaseData.deviceCapacity ?? '';
    imeiController.text = purchaseData.imei ?? '';
    snController.text = purchaseData.serialNumber ?? '';
    detailsController.text = purchaseData.deviceDetails ?? '';
    priceController.text = purchaseData.pricePaid?.toStringAsFixed(0) ?? '';
  }

  Future<void> pickIdPhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      purchaseData.sellerIdPhotoPath = image.path;
      notifyListeners();
    }
  }

  Future<void> pickPurchaseMomentPhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      purchaseData.purchaseMomentPhotoPath = image.path;
      notifyListeners();
    }
  }

  Future<void> pickDeviceImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      final List<String> paths = List.from(purchaseData.deviceImagesPaths);
      paths.addAll(images.map((e) => e.path));
      purchaseData.deviceImagesPaths = paths;
      notifyListeners();
    }
  }

  void saveSignature(Uint8List signature) {
    purchaseData.customerSignature = signature;
    notifyListeners();
  }

  // Si es un path local, lo sube a R2 y devuelve la key. Si ya es una key, la deja igual.
  Future<String?> _ensureUploaded(String? path) async {
    if (path == null) return null;
    return isLocalMediaPath(path) ? await PurchaseApi.uploadFile(path) : path;
  }

  Future<void> submit() async {
    // Populate model with text fields before submit
    purchaseData.sellerName = nameController.text;
    purchaseData.sellerPhone = phoneController.text;
    purchaseData.sellerIdNumber = idNumberController.text;
    purchaseData.deviceModel = deviceModelController.text;
    purchaseData.deviceCapacity = deviceCapacityController.text;
    purchaseData.imei = imeiController.text;
    purchaseData.serialNumber = snController.text;
    purchaseData.deviceDetails = detailsController.text;
    purchaseData.pricePaid = double.tryParse(priceController.text);
    purchaseData.createdAt ??= DateTime.now(); // conserva la fecha original al editar

    // Sube las fotos locales a R2 y reemplaza los paths por keys antes de persistir.
    // Las que ya son keys (al editar) no se vuelven a subir.
    purchaseData.sellerIdPhotoPath = await _ensureUploaded(purchaseData.sellerIdPhotoPath);
    purchaseData.purchaseMomentPhotoPath =
        await _ensureUploaded(purchaseData.purchaseMomentPhotoPath);
    final keys = <String>[];
    for (final p in purchaseData.deviceImagesPaths) {
      final k = await _ensureUploaded(p);
      if (k != null) keys.add(k);
    }
    purchaseData.deviceImagesPaths = keys;

    if (_editing != null) {
      await PurchaseApi.update(purchaseData); // ya trae el id de la fila
    } else {
      await PurchaseApi.create(purchaseData);
    }
    debugPrint("Purchase submitted: ${purchaseData.sellerName}, ${purchaseData.pricePaid}");
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    idNumberController.dispose();
    deviceModelController.dispose();
    deviceCapacityController.dispose();
    imeiController.dispose();
    snController.dispose();
    detailsController.dispose();
    priceController.dispose();
    super.dispose();
  }
}
