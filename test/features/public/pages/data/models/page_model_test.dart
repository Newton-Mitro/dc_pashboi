import 'package:flutter_test/flutter_test.dart';
import 'package:pashboi/features/public/pages/data/models/page_model.dart';
import 'package:pashboi/features/public/pages/domain/enities/page_entity.dart';

void main() {
  const createdAt = '2025-01-01T10:00:00.000Z';
  const updatedAt = '2025-01-02T10:00:00.000Z';
  final json = {
    'id': 'page-1',
    'title': 'About Us',
    'slug': 'about-us',
    'order': 2,
    'short_description': 'Who we are',
    'description': 'Our organization background',
    'attachment_url': 'https://example.com/about.png',
    'attachment_path': 'pages',
    'attachment_name': 'about.png',
    'attachment_mime': 'image/png',
    'publish_status': 'Published',
    'created_at': createdAt,
    'updated_at': updatedAt,
  };

  test('maps page API fields to the page entity', () {
    final model = PageModel.fromJson(json);

    expect(model, isA<PageEntity>());
    expect(model.id, 'page-1');
    expect(model.title, 'About Us');
    expect(model.slug, 'about-us');
    expect(model.order, 2);
    expect(model.shortDescription, 'Who we are');
    expect(model.longDescription, 'Our organization background');
    expect(model.createdAt, DateTime.parse(createdAt));
    expect(model.updatedAt, DateTime.parse(updatedAt));
  });

  test(
    'serializes the page using API keys and round-trips its description',
    () {
      final model = PageModel.fromJson(json);
      final serialized = model.toJson();

      expect(serialized['description'], 'Our organization background');
      expect(serialized.containsKey('long_description'), isFalse);
      expect(
        PageModel.fromJson(serialized).longDescription,
        model.longDescription,
      );
      expect(serialized['order'], 2);
    },
  );

  test('defaults a missing order to zero', () {
    final model = PageModel.fromJson({...json, 'order': null});

    expect(model.order, 0);
  });
}
