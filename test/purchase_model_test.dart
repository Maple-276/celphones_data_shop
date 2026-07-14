import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:celphones_data_shop/models/purchase_model.dart';

void main() {
  test('toJson/fromJson round-trip preserva datos y firma base64', () {
    final original = PurchaseModel(
      id: 7,
      sellerName: 'Ana',
      imei: '123456',
      deviceImagesPaths: ['a.jpg', 'b.jpg'],
      pricePaid: 500,
      customerSignature: Uint8List.fromList([0, 1, 2, 253, 254, 255]),
      createdAt: DateTime.parse('2026-07-11T10:00:00.000'),
    );

    // Simula el viaje al Worker: encode camelCase -> decode de vuelta.
    final back = PurchaseModel.fromJson(original.toJson()..['id'] = 7);

    expect(back.id, 7);
    expect(back.sellerName, 'Ana');
    expect(back.imei, '123456');
    expect(back.deviceImagesPaths, ['a.jpg', 'b.jpg']);
    expect(back.pricePaid, 500);
    expect(back.customerSignature, original.customerSignature);
    expect(back.createdAt, original.createdAt);
  });
}
