import 'package:flutter/material.dart';
import '../../controllers/purchase_controller.dart';
import '../../core/theme/app_colors.dart';

class DeviceInfoSection extends StatelessWidget {
  final PurchaseController controller;

  const DeviceInfoSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: AppColors.surface,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double fieldWidth = constraints.maxWidth > 600 ? (constraints.maxWidth / 2) - 8 : constraints.maxWidth;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Datos del Equipo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    SizedBox(
                      width: fieldWidth,
                      child: TextField(
                        controller: controller.deviceModelController,
                        decoration: const InputDecoration(labelText: 'Modelo del Equipo', border: OutlineInputBorder()),
                      ),
                    ),
                    SizedBox(
                      width: fieldWidth,
                      child: TextField(
                        controller: controller.deviceCapacityController,
                        decoration: const InputDecoration(labelText: 'Capacidad (GB)', border: OutlineInputBorder()),
                      ),
                    ),
                    SizedBox(
                      width: fieldWidth,
                      child: TextField(
                        controller: controller.imeiController,
                        decoration: const InputDecoration(labelText: 'IMEI', border: OutlineInputBorder()),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(
                      width: fieldWidth,
                      child: TextField(
                        controller: controller.snController,
                        decoration: const InputDecoration(labelText: 'Serial Number (SN)', border: OutlineInputBorder()),
                      ),
                    ),
                    SizedBox(
                      width: constraints.maxWidth,
                      child: TextField(
                        controller: controller.detailsController,
                        decoration: const InputDecoration(labelText: 'Detalles/Estado del equipo', border: OutlineInputBorder()),
                        maxLines: 3,
                      ),
                    ),
                    SizedBox(
                      width: fieldWidth,
                      child: TextField(
                        controller: controller.priceController,
                        decoration: const InputDecoration(labelText: 'Precio Pagado', border: OutlineInputBorder(), prefixText: '\$ '),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}
