import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../controllers/auth_controller.dart';
import '../../data/purchase_api.dart';

/// Muestra una foto de una compra, venga de donde venga:
///  - Path local (recién capturada, aún sin subir): Image.file en móvil, Image.network en web.
///  - Key de R2 (ya guardada en D1): se baja del Worker con el token de Firebase en el header.
class PurchaseImage extends StatelessWidget {
  final String source;
  final double? width;
  final double? height;
  final BoxFit fit;

  const PurchaseImage(this.source,
      {super.key, this.width, this.height, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    if (isLocalMediaPath(source)) {
      return kIsWeb
          ? Image.network(source, width: width, height: height, fit: fit)
          : Image.file(File(source), width: width, height: height, fit: fit);
    }
    // Es una key de R2: URL del Worker + token en el header (Image.network cachea por URL).
    return FutureBuilder<String?>(
      future: AuthController.idToken(),
      builder: (_, snap) {
        if (!snap.hasData) {
          return SizedBox(
            width: width,
            height: height,
            child: const Center(child: CircularProgressIndicator()),
          );
        }
        return Image.network(
          PurchaseApi.fileUrl(source),
          headers: {'authorization': 'Bearer ${snap.data}'},
          width: width,
          height: height,
          fit: fit,
        );
      },
    );
  }
}
