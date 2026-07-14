import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/purchase_model.dart';
import 'widgets/purchase_image.dart';

class DeviceDetailScreen extends StatelessWidget {
  final PurchaseModel purchase;
  const DeviceDetailScreen({super.key, required this.purchase});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detalle del equipo', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section('Equipo'),
          _row('Modelo', purchase.deviceModel),
          _row('Capacidad', purchase.deviceCapacity),
          _row('IMEI', purchase.imei),
          _row('Serial', purchase.serialNumber),
          _row('Detalles', purchase.deviceDetails),
          _row('Precio pagado',
              purchase.pricePaid != null ? '\$${purchase.pricePaid!.toStringAsFixed(0)}' : null),
          const SizedBox(height: 16),
          _section('Vendedor'),
          _row('Nombre', purchase.sellerName),
          _row('Teléfono', purchase.sellerPhone),
          _row('Cédula', purchase.sellerIdNumber),
          if (purchase.purchaseMomentPhotoPath != null) ...[
            const SizedBox(height: 16),
            _section('Momento de la compra'),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: PurchaseImage(purchase.purchaseMomentPhotoPath!,
                  height: 160),
            ),
          ],
          if (purchase.deviceImagesPaths.isNotEmpty) ...[
            const SizedBox(height: 16),
            _section('Fotos del equipo'),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: purchase.deviceImagesPaths.length,
                separatorBuilder: (_, i) => const SizedBox(width: 8),
                itemBuilder: (_, i) => ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: PurchaseImage(purchase.deviceImagesPaths[i],
                      width: 120, height: 120),
                ),
              ),
            ),
          ],
          if (purchase.customerSignature != null) ...[
            const SizedBox(height: 16),
            _section('Firma'),
            Container(
              color: AppColors.surface,
              padding: const EdgeInsets.all(8),
              child: Image.memory(purchase.customerSignature!, height: 120),
            ),
          ],
        ],
      ),
    );
  }

  Widget _section(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(title,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
      );

  Widget _row(String label, String? value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: 120,
                child: Text(label,
                    style: const TextStyle(color: AppColors.textSecondary))),
            Expanded(child: Text(value?.isNotEmpty == true ? value! : '—')),
          ],
        ),
      );
}
