import 'package:flutter/material.dart';
import '../../controllers/purchase_controller.dart';
import 'form_section.dart';

class PersonalInfoSection extends StatelessWidget {
  final PurchaseController controller;

  const PersonalInfoSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FormSection(
      title: 'Información Personal',
      fields: (full, half) => [
        field(controller.nameController, 'Nombre del Vendedor', full),
        field(controller.phoneController, 'Número de Teléfono', half,
            keyboardType: TextInputType.phone),
        field(controller.idNumberController, 'Número de Cédula', half,
            keyboardType: TextInputType.number),
      ],
    );
  }
}
