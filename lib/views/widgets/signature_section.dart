import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import '../../controllers/purchase_controller.dart';
import '../../core/theme/app_colors.dart';

class SignatureSection extends StatefulWidget {
  final PurchaseController controller;

  const SignatureSection({super.key, required this.controller});

  @override
  State<SignatureSection> createState() => _SignatureSectionState();
}

class _SignatureSectionState extends State<SignatureSection> {
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  void _saveSignature() async {
    if (_signatureController.isNotEmpty) {
      final signature = await _signatureController.toPngBytes();
      if (signature != null) {
        widget.controller.saveSignature(signature);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Firma guardada exitosamente')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: AppColors.surface,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Firma del Cliente', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: Signature(
                controller: _signatureController,
                height: 150,
                backgroundColor: AppColors.background,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => _signatureController.clear(),
                  child: const Text('Limpiar Firma'),
                ),
                ElevatedButton(
                  onPressed: _saveSignature,
                  child: const Text('Guardar Firma'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            AnimatedBuilder(
              animation: widget.controller,
              builder: (context, _) {
                if (widget.controller.purchaseData.customerSignature != null) {
                  return const Row(
                    children: [
                      Icon(Icons.check_circle, color: AppColors.success),
                      SizedBox(width: 8),
                      Text('Firma capturada', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }
            ),
          ],
        ),
      ),
    );
  }
}
