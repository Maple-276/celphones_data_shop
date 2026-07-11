import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'widgets/app_drawer.dart';
import 'purchase_form_screen.dart';
import 'registered_devices_screen.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _selectedIndex = 1; // Aterriza en Equipos Registrados tras login

  final List<Widget> _views = [
    const PurchaseFormScreen(),
    const RegisteredDevicesScreen(),
  ];

  final List<String> _titles = [
    'Registro de Compra de Equipo',
    'Equipos Registrados',
  ];

  void _onDrawerItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_titles[_selectedIndex], style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: AppDrawer(
        onItemSelected: _onDrawerItemSelected,
        selectedIndex: _selectedIndex,
      ),
      body: _views[_selectedIndex],
    );
  }
}
