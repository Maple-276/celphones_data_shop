import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../data/purchase_api.dart';
import '../models/purchase_model.dart';
import 'device_detail_screen.dart';
import 'purchase_form_screen.dart';
import 'widgets/fade_slide_in.dart';

enum _Sort { recientes, precioAlto, precioBajo, modelo }

class RegisteredDevicesScreen extends StatefulWidget {
  const RegisteredDevicesScreen({super.key});

  @override
  State<RegisteredDevicesScreen> createState() => _RegisteredDevicesScreenState();
}

class _RegisteredDevicesScreenState extends State<RegisteredDevicesScreen> {
  String _query = '';
  _Sort _sort = _Sort.recientes;
  late Future<List<PurchaseModel>> _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() => setState(() {
        _future = PurchaseApi.fetchAll();
      });

  // Filtra en cliente sobre lo ya traído (mismos campos que buscaba el store).
  List<PurchaseModel> _filtered(List<PurchaseModel> items) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return items;
    bool has(String? v) => (v ?? '').toLowerCase().contains(q);
    return items
        .where((p) =>
            has(p.deviceModel) ||
            has(p.imei) ||
            has(p.serialNumber) ||
            has(p.sellerName) ||
            has(p.sellerIdNumber))
        .toList();
  }

  List<PurchaseModel> _sorted(List<PurchaseModel> items) {
    final list = List<PurchaseModel>.from(items);
    switch (_sort) {
      case _Sort.recientes:
        break; // el store ya devuelve más recientes primero
      case _Sort.precioAlto:
        list.sort((a, b) => (b.pricePaid ?? 0).compareTo(a.pricePaid ?? 0));
      case _Sort.precioBajo:
        list.sort((a, b) => (a.pricePaid ?? 0).compareTo(b.pricePaid ?? 0));
      case _Sort.modelo:
        list.sort((a, b) =>
            (a.deviceModel ?? '').toLowerCase().compareTo((b.deviceModel ?? '').toLowerCase()));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: FadeSlideIn(
          child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Row(
            children: [
              Expanded(
                // ponytail: un solo buscador cubre modelo/IMEI/serial/vendedor.
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar',
                    prefixIcon:
                        const Icon(Icons.search, color: AppColors.textSecondary),
                    isDense: true,
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
              const SizedBox(width: 10),
              _FilterDot(
                icon: Icons.schedule,
                tooltip: 'Más recientes',
                selected: _sort == _Sort.recientes,
                onTap: () => setState(() => _sort = _Sort.recientes),
              ),
              const SizedBox(width: 8),
              _FilterDot(
                // Alterna mayor↔menor al volver a tocarlo.
                icon: _sort == _Sort.precioBajo
                    ? Icons.arrow_upward
                    : Icons.attach_money,
                tooltip: 'Precio',
                selected: _sort == _Sort.precioAlto || _sort == _Sort.precioBajo,
                onTap: () => setState(() => _sort =
                    _sort == _Sort.precioAlto ? _Sort.precioBajo : _Sort.precioAlto),
              ),
              const SizedBox(width: 8),
              _FilterDot(
                icon: Icons.sort_by_alpha,
                tooltip: 'Modelo (A-Z)',
                selected: _sort == _Sort.modelo,
                onTap: () => setState(() => _sort = _Sort.modelo),
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<PurchaseModel>>(
            future: _future,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snap.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('No se pudo cargar: ${snap.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.error)),
                        const SizedBox(height: 12),
                        OutlinedButton(
                            onPressed: _reload, child: const Text('Reintentar')),
                      ],
                    ),
                  ),
                );
              }
              final results = _sorted(_filtered(snap.data ?? const []));
              if (results.isEmpty) {
                return const Center(
                  child: Text('No hay equipos registrados.',
                      style: TextStyle(color: AppColors.textSecondary)),
                );
              }
              return RefreshIndicator(
                onRefresh: () async => _reload(),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                  itemCount: results.length,
                  itemBuilder: (_, i) => _DeviceCard(
                    purchase: results[i],
                    onChanged: _reload,
                  ),
                ),
              );
            },
          ),
        ),
      ],
          ),
        ),
      ),
    );
  }
}

class _FilterDot extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final bool selected;
  final VoidCallback onTap;
  const _FilterDot({
    required this.icon,
    required this.tooltip,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon,
              size: 22,
              color: selected ? Colors.white : AppColors.primary),
        ),
      ),
    );
  }
}

class _DeviceCard extends StatelessWidget {
  final PurchaseModel purchase;
  final VoidCallback onChanged;
  const _DeviceCard({required this.purchase, required this.onChanged});

  Future<void> _edit(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Editar equipo', style: TextStyle(color: Colors.white)),
            backgroundColor: AppColors.primary,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: PurchaseFormScreen(existing: purchase),
        ),
      ),
    );
    onChanged();
  }

  Future<void> _delete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar equipo'),
        content: Text(
            '¿Eliminar "${purchase.deviceModel?.isNotEmpty == true ? purchase.deviceModel : 'este equipo'}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Eliminar', style: TextStyle(color: AppColors.error))),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      final messenger = ScaffoldMessenger.of(context);
      try {
        await PurchaseApi.delete(purchase.id!);
        onChanged();
      } catch (e) {
        messenger.showSnackBar(
          SnackBar(content: Text('No se pudo eliminar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final price = purchase.pricePaid != null
        ? '\$${purchase.pricePaid!.toStringAsFixed(0)}'
        : '—';

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: AppColors.primary.withValues(alpha: 0.12)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => DeviceDetailScreen(purchase: purchase)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.smartphone,
                    color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      purchase.deviceModel?.isNotEmpty == true
                          ? purchase.deviceModel!
                          : 'Equipo sin modelo',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 2),
                    Text('IMEI ${purchase.imei ?? '—'}',
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 13)),
                  ],
                ),
              ),
              Text(price,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryDark)),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
                onSelected: (v) {
                  if (v == 'edit') _edit(context);
                  if (v == 'delete') _delete(context);
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'edit',
                    child: ListTile(
                        leading: Icon(Icons.edit_outlined),
                        title: Text('Editar'),
                        contentPadding: EdgeInsets.zero),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                        leading: Icon(Icons.delete_outline, color: AppColors.error),
                        title: Text('Eliminar', style: TextStyle(color: AppColors.error)),
                        contentPadding: EdgeInsets.zero),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
