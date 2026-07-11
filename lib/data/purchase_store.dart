import '../models/purchase_model.dart';

// ponytail: almacenamiento en memoria (se pierde al cerrar la app).
// Para persistir, reemplaza el cuerpo por Hive/SQLite; las vistas solo usan .all/.search/.add.
class PurchaseStore {
  PurchaseStore._();
  static final PurchaseStore instance = PurchaseStore._();

  final List<PurchaseModel> _items = [];

  /// Más recientes primero.
  List<PurchaseModel> get all => _items.reversed.toList();

  void add(PurchaseModel purchase) => _items.add(purchase);

  void remove(PurchaseModel purchase) => _items.remove(purchase);

  void replace(PurchaseModel oldPurchase, PurchaseModel newPurchase) {
    final i = _items.indexOf(oldPurchase);
    if (i != -1) _items[i] = newPurchase;
  }

  List<PurchaseModel> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return all;
    bool has(String? v) => (v ?? '').toLowerCase().contains(q);
    return all
        .where((p) =>
            has(p.deviceModel) ||
            has(p.imei) ||
            has(p.serialNumber) ||
            has(p.sellerName) ||
            has(p.sellerIdNumber))
        .toList();
  }
}
