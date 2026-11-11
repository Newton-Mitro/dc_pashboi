import 'package:flutter_test/flutter_test.dart';
import 'package:pashboi/features/public/service_centers/data/models/service_center_model.dart';
import 'package:pashboi/features/public/service_centers/domain/entites/service_center_entity.dart';

void main() {
  final json = {
    'id': 'branch-1',
    'name': 'Central Branch',
    'slug': 'central-branch',
    'order': 2,
    'email': 'central@example.com',
    'phone': '01700000000',
    'ipPhone': '123',
    'fax': '456',
    'lag': 23.78,
    'lng': 90.41,
    'collection': 'Savings',
    'time': '9 AM - 5 PM',
    'address': 'Central district',
    'incharge_infos': [
      {
        'id': 'person-1',
        'name': 'Branch Manager',
        'designation': 'Manager',
        'contact_number': '01800000000',
        'email': 'manager@example.com',
        'office_location_id': 'branch-1',
        'attachment_url': 'https://example.com/photo.png',
        'attachment_path': 'photos',
        'attachment_name': 'photo.png',
        'attachment_mime': 'image/png',
        'created_at': '2025-01-01T10:00:00.000Z',
        'updated_at': '2025-01-02T10:00:00.000Z',
      },
    ],
    'publish_status': 'Published',
    'created_at': '2025-01-01T10:00:00.000Z',
    'updated_at': '2025-01-02T10:00:00.000Z',
  };

  test('maps service center fields and nested in-charge information', () {
    final model = ServiceCenterModel.fromJson(json);

    expect(model, isA<ServiceCenterEntity>());
    expect(model.id, 'branch-1');
    expect(model.name, 'Central Branch');
    expect(model.lat, '23.78');
    expect(model.lng, '90.41');
    expect(model.createdAt, DateTime.parse('2025-01-01T10:00:00.000Z'));
    expect(model.inChargeInfos.single.name, 'Branch Manager');
    expect(model.inChargeInfos.single.contactNumber, '01800000000');
    expect(model.inChargeInfos.single.createdAt, isNotNull);
  });

  test('serializes the branch and nested in-charge details', () {
    final serialized = ServiceCenterModel.fromJson(json).toJson();

    expect(serialized['name'], 'Central Branch');
    expect(serialized['lag'], '23.78');
    expect(serialized['lng'], '90.41');
    expect(
      (serialized['incharge_infos'] as List).single['contact_number'],
      '01800000000',
    );
    expect(serialized['created_at'], '2025-01-01T10:00:00.000Z');
  });

  test('defaults an absent in-charge list to empty', () {
    final model = ServiceCenterModel.fromJson({
      'id': 'branch-2',
      'name': 'North Branch',
      'created_at': '2025-01-01T10:00:00.000Z',
      'updated_at': '2025-01-02T10:00:00.000Z',
    });

    expect(model.inChargeInfos, isEmpty);
  });

  test('includes the branch name in value equality', () {
    final first = ServiceCenterModel.fromJson(json);
    final second = ServiceCenterModel.fromJson({
      ...json,
      'name': 'Renamed Branch',
    });

    expect(first, isNot(second));
    expect(first.props, contains('Central Branch'));
  });
}
