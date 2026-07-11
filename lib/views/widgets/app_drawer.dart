import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../login_screen.dart';

class AppDrawer extends StatelessWidget {
  final Function(int) onItemSelected;
  final int selectedIndex;

  const AppDrawer({super.key, required this.onItemSelected, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: AppColors.primary),
            accountName: Text('Usuario Administrador', style: TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: Text('admin@celphones.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: AppColors.primary),
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
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
