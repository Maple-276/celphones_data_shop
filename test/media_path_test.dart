import 'package:flutter_test/flutter_test.dart';
import 'package:celphones_data_shop/data/purchase_api.dart';

// isLocalMediaPath decide si una foto se sube a R2 o ya está guardada.
// Si se rompe, o se re-suben keys existentes o no se sube una foto nueva.
void main() {
  test('paths locales -> true (hay que subirlos)', () {
    expect(isLocalMediaPath('/data/user/0/app/cache/foto.jpg'), isTrue);
    expect(isLocalMediaPath('blob:http://localhost/abc'), isTrue);
    expect(isLocalMediaPath('http://ejemplo/foo.jpg'), isTrue);
  });

  test('keys de R2 -> false (ya están guardadas)', () {
    expect(isLocalMediaPath('uid123/9f8e-7d6c.jpg'), isFalse);
    expect(isLocalMediaPath('abc/def.png'), isFalse);
  });
}
