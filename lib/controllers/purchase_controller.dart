import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/purchase_model.dart';
import 'package:image_picker/image_picker.dart';

class PurchaseController extends ChangeNotifier {
  final PurchaseModel purchaseData = PurchaseModel();
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

  Future<void> pickIdPhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      purchaseData.sellerIdPhotoPath = image.path;
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

  void submit() {
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
    
    // In a real app we'd validate and send to backend
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
