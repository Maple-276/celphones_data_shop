import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../controllers/purchase_controller.dart';
import '../../core/theme/app_colors.dart';

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
                
                // Id Photo
                const Text('Foto de la Cédula', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                if (controller.purchaseData.sellerIdPhotoPath != null)
                  kIsWeb 
                    ? Image.network(controller.purchaseData.sellerIdPhotoPath!, height: 100)
                    : Image.file(File(controller.purchaseData.sellerIdPhotoPath!), height: 100)
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
                    children: controller.purchaseData.deviceImagesPaths.map((path) => 
                      kIsWeb 
                        ? Image.network(path, height: 100, width: 100, fit: BoxFit.cover)
                        : Image.file(File(path), height: 100, width: 100, fit: BoxFit.cover)
                    ).toList(),
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
