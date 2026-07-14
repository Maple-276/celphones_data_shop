import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../controllers/auth_controller.dart';

class AppDrawer extends StatelessWidget {
  final Function(int) onItemSelected;
  final int selectedIndex;

  const AppDrawer({super.key, required this.onItemSelected, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? '';
    // Los de email/contraseña no traen displayName; caemos al inicio del correo.
    final name = (user?.displayName?.isNotEmpty ?? false)
        ? user!.displayName!
        : (email.isNotEmpty ? email.split('@').first : 'Usuario');
    final photo = user?.photoURL;

    return Drawer(
      backgroundColor: AppColors.surface,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primary),
            accountName: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              // Foto de Google si existe; si no, inicial del nombre.
              backgroundImage: photo != null ? NetworkImage(photo) : null,
              child: photo == null
                  ? Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary),
                    )
                  : null,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add_shopping_cart),
            title: const Text('Nueva Compra'),
            selected: selectedIndex == 0,
            selectedColor: AppColors.primaryDark,
            onTap: () {
              onItemSelected(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.phone_iphone),
            title: const Text('Equipos Registrados'),
            selected: selectedIndex == 1,
            selectedColor: AppColors.primaryDark,
            onTap: () {
              onItemSelected(1);
              Navigator.pop(context);
            },
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: const Text('Cerrar Sesión', style: TextStyle(color: AppColors.error)),
            onTap: () => AuthController.signOut(), // el auth gate vuelve al login solo.
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
