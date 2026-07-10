import 'package:flutter/material.dart';
import '../controllers/purchase_controller.dart';
import '../core/theme/app_colors.dart';
import 'widgets/personal_info_section.dart';
import 'widgets/device_info_section.dart';
import 'widgets/media_capture_section.dart';
import 'widgets/signature_section.dart';

class PurchaseFormScreen extends StatefulWidget {
  const PurchaseFormScreen({super.key});

  @override
  State<PurchaseFormScreen> createState() => _PurchaseFormScreenState();
}

class _PurchaseFormScreenState extends State<PurchaseFormScreen> {
  final PurchaseController _controller = PurchaseController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              PersonalInfoSection(controller: _controller),
              DeviceInfoSection(controller: _controller),
              MediaCaptureSection(controller: _controller),
              SignatureSection(controller: _controller),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    _controller.submit();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Formulario enviado (Mockup)')),
                    );
                  },
                  child: const Text('Registrar Compra', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
