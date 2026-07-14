import 'package:flutter/material.dart';
import '../controllers/purchase_controller.dart';
import '../core/theme/app_colors.dart';
import '../models/purchase_model.dart';
import 'widgets/personal_info_section.dart';
import 'widgets/device_info_section.dart';
import 'widgets/media_capture_section.dart';
import 'widgets/signature_section.dart';
import 'widgets/fade_slide_in.dart';

class PurchaseFormScreen extends StatefulWidget {
  final PurchaseModel? existing; // Si viene, es edición.
  const PurchaseFormScreen({super.key, this.existing});

  @override
  State<PurchaseFormScreen> createState() => _PurchaseFormScreenState();
}

class _PurchaseFormScreenState extends State<PurchaseFormScreen> {
  late final PurchaseController _controller =
      PurchaseController(existing: widget.existing);

  bool get _isEditing => widget.existing != null;

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
          child: FadeSlideIn(
            child: Column(
              children: [
                PersonalInfoSection(controller: _controller),
                DeviceInfoSection(controller: _controller),
                MediaCaptureSection(controller: _controller),
                SignatureSection(controller: _controller),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final navigator = Navigator.of(context);
                      try {
                        await _controller.submit();
                        if (!context.mounted) return;
                        if (_isEditing) {
                          navigator.pop(true);
                        } else {
                          messenger.showSnackBar(
                            const SnackBar(content: Text('Compra registrada')),
                          );
                        }
                      } catch (e) {
                        messenger.showSnackBar(
                          SnackBar(content: Text('No se pudo guardar: $e')),
                        );
                      }
                    },
                    child: Text(_isEditing ? 'Guardar Cambios' : 'Registrar Compra',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
