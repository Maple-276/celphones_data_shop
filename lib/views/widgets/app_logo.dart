import 'package:flutter/material.dart';

/// Logo de la app: único lugar donde vive el ícono. Reúsalo en cualquier pantalla.
/// Badge blanco circular con el logo (teléfono) adentro.
class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 96});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: size * 0.17,
            offset: Offset(0, size * 0.06),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(size * 0.16),
        child: Image.asset('assets/logo_icon.png'),
      ),
    );
  }
}
