import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Card con título y campos que se acomodan en 1 o 2 columnas según el ancho.
/// `fields` recibe (anchoCompleto, mediaColumna) para dimensionar cada campo.
class FormSection extends StatelessWidget {
  final String title;
  final List<Widget> Function(double full, double half) fields;
  const FormSection({super.key, required this.title, required this.fields});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: AppColors.surface,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, c) {
            final half = c.maxWidth > 600 ? (c.maxWidth / 2) - 8 : c.maxWidth;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark)),
                const SizedBox(height: 16),
                Wrap(spacing: 16, runSpacing: 16, children: fields(c.maxWidth, half)),
              ],
            );
          },
        ),
      ),
    );
  }
}

Widget field(TextEditingController controller, String label, double width,
        {TextInputType? keyboardType, int maxLines = 1, String? prefixText}) =>
    SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            prefixText: prefixText),
      ),
    );
