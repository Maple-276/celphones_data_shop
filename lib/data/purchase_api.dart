import 'dart:convert';
import 'package:image_picker/image_picker.dart' show XFile;
import 'package:http/http.dart' as http;
import '../controllers/auth_controller.dart';
import '../models/purchase_model.dart';

/// true si es un archivo local que todavía no se subió (móvil: '/...', web: 'blob:'/'http').
/// false si ya es una key de R2 guardada en D1. Única fuente de verdad: la usan el
/// controller (para decidir si sube) y PurchaseImage (para decidir si baja).
bool isLocalMediaPath(String s) =>
    s.startsWith('/') || s.startsWith('blob:') || s.startsWith('http');

/// Cliente del Worker de Cloudflare. Reemplaza al PurchaseStore en memoria.
/// Cada request lleva el ID token de Firebase; el Worker filtra por dueño.
///
/// La URL se pasa al compilar:
///   flutter run --dart-define=API_URL=https://celphones-backend.TU-CUENTA.workers.dev
class PurchaseApi {
  // ponytail: --dart-define en vez de hardcodear; igual que _googleServerClientId.
  static const String _baseUrl = String.fromEnvironment('API_URL');

  static Uri _uri([String path = '']) {
    if (_baseUrl.isEmpty) {
      throw StateError(
          'Falta API_URL. Corré con --dart-define=API_URL=https://...workers.dev');
    }
    return Uri.parse('$_baseUrl/purchases$path');
  }

  /// URL pública (del Worker) para bajar un archivo de R2 por su key.
  /// La descarga igual exige el token de Firebase en el header (ver PurchaseImage).
  static String fileUrl(String key) => '$_baseUrl/uploads/$key';

  /// Sube un archivo local a R2 (vía el Worker) y devuelve su key para guardar en D1.
  /// XFile.readAsBytes anda igual en móvil (lee del filesystem) y en web (lee el blob),
  /// así el mismo código sube fotos en las dos plataformas.
  static Future<String> uploadFile(String localPath) async {
    final token = await AuthController.idToken();
    if (token == null) throw StateError('No hay sesión de Firebase');
    final r = await http.post(
      Uri.parse('$_baseUrl/uploads'),
      headers: {
        'authorization': 'Bearer $token',
        'content-type':
            localPath.toLowerCase().endsWith('.png') ? 'image/png' : 'image/jpeg',
      },
      body: await XFile(localPath).readAsBytes(),
    );
    _check(r);
    return (jsonDecode(r.body) as Map)['key'] as String;
  }

  static Future<Map<String, String>> _headers() async {
    final token = await AuthController.idToken();
    if (token == null) throw StateError('No hay sesión de Firebase');
    return {
      'authorization': 'Bearer $token',
      'content-type': 'application/json',
    };
  }

  // Convierte una respuesta no-2xx en una excepción legible.
  static void _check(http.Response r) {
    if (r.statusCode >= 200 && r.statusCode < 300) return;
    throw Exception('Worker ${r.statusCode}: ${r.body}');
  }

  /// GET /purchases  — más recientes primero (lo ordena el Worker).
  static Future<List<PurchaseModel>> fetchAll() async {
    final r = await http.get(_uri(), headers: await _headers());
    _check(r);
    final list = jsonDecode(r.body) as List;
    return list
        .map((e) => PurchaseModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// POST /purchases  — devuelve el id que asignó la DB.
  static Future<int> create(PurchaseModel p) async {
    final r = await http.post(_uri(),
        headers: await _headers(), body: jsonEncode(p.toJson()));
    _check(r);
    return (jsonDecode(r.body) as Map)['id'] as int;
  }

  /// PUT /purchases/:id
  static Future<void> update(PurchaseModel p) async {
    final r = await http.put(_uri('/${p.id}'),
        headers: await _headers(), body: jsonEncode(p.toJson()));
    _check(r);
  }

  /// DELETE /purchases/:id
  static Future<void> delete(int id) async {
    final r = await http.delete(_uri('/$id'), headers: await _headers());
    _check(r);
  }
}
