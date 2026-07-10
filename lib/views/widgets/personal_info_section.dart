import 'package:flutter/material.dart';
import '../../controllers/purchase_controller.dart';
import '../../core/theme/app_colors.dart';

class PersonalInfoSection extends StatelessWidget {
  final PurchaseController controller;

  const PersonalInfoSection({super.key, required this.controller});

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
                const Text('Información Personal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    SizedBox(
                      width: constraints.maxWidth,
                      child: TextField(
                        controller: controller.nameController,
                        decoration: const InputDecoration(labelText: 'Nombre del Vendedor', border: OutlineInputBorder()),
                      ),
                    ),
                    SizedBox(
                      width: fieldWidth,
                      child: TextField(
                        controller: controller.phoneController,
                        decoration: const InputDecoration(labelText: 'Número de Teléfono', border: OutlineInputBorder()),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    SizedBox(
                      width: fieldWidth,
                      child: TextField(
                        controller: controller.idNumberController,
                        decoration: const InputDecoration(labelText: 'Número de Cédula', border: OutlineInputBorder()),
                        keyboardType: TextInputType.number,
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
