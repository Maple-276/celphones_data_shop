import 'package:flutter/material.dart';
import '../../controllers/purchase_controller.dart';
import 'form_section.dart';

class DeviceInfoSection extends StatelessWidget {
  final PurchaseController controller;

  const DeviceInfoSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FormSection(
      title: 'Datos del Equipo',
      fields: (full, half) => [
        field(controller.deviceModelController, 'Modelo del Equipo', half),
        field(controller.deviceCapacityController, 'Capacidad (GB)', half),
        field(controller.imeiController, 'IMEI', half,
            keyboardType: TextInputType.number),
        field(controller.snController, 'Serial Number (SN)', half),
        field(controller.detailsController, 'Detalles/Estado del equipo', full,
            maxLines: 3),
        field(controller.priceController, 'Precio Pagado', half,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefixText: '\$ '),
      ],
    );
  }
}
