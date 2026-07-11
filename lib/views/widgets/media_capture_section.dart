import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../controllers/purchase_controller.dart';
import '../../core/theme/app_colors.dart';

Widget _img(String path, {double? width}) => kIsWeb
    ? Image.network(path, height: 100, width: width, fit: BoxFit.cover)
    : Image.file(File(path), height: 100, width: width, fit: BoxFit.cover);

class MediaCaptureSection extends StatelessWidget {
  final PurchaseController controller;

  const MediaCaptureSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          color: AppColors.surface,
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Evidencia Fotográfica', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                const SizedBox(height: 16),

                // Purchase moment photo (persona)
                const Text('Momento de la Compra', style: TextStyle(fontWeight: FontWeight.w600)),
                const Text('Foto de la persona a quien se le compra el equipo',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                if (controller.purchaseData.purchaseMomentPhotoPath != null)
                  _img(controller.purchaseData.purchaseMomentPhotoPath!)
                else
                  const Text('No se ha tomado la foto del momento de la compra'),
                ElevatedButton.icon(
                  onPressed: controller.pickPurchaseMomentPhoto,
                  icon: const Icon(Icons.person_pin),
                  label: const Text('Tomar Foto de la Persona'),
                ),
                const Divider(height: 32),

                // Id Photo
                const Text('Foto de la Cédula', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                if (controller.purchaseData.sellerIdPhotoPath != null)
                  _img(controller.purchaseData.sellerIdPhotoPath!)
                else
                  const Text('No se ha tomado la foto de la cédula'),
                ElevatedButton.icon(
                  onPressed: controller.pickIdPhoto,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Tomar Foto Cédula'),
                ),
                const Divider(height: 32),
                
                // Device Images
                const Text('Fotos del Equipo', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                if (controller.purchaseData.deviceImagesPaths.isNotEmpty)
                  Wrap(
                    spacing: 8.0,
                    children: controller.purchaseData.deviceImagesPaths
                        .map((path) => _img(path, width: 100))
                        .toList(),
                  )
                else
                  const Text('No se han agregado fotos del equipo'),
                ElevatedButton.icon(
                  onPressed: controller.pickDeviceImages,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Seleccionar Fotos Equipo'),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
