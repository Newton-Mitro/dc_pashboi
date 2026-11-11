import 'package:flutter_test/flutter_test.dart';
import 'package:pashboi/features/public/project/data/models/project_model.dart';
import 'package:pashboi/features/public/project/domain/entites/project_entity.dart';

void main() {
  const createdAt = '2025-01-01T10:00:00.000Z';
  const updatedAt = '2025-01-02T10:00:00.000Z';
  final json = {
    'id': 'project-1',
    'title': 'Community Center',
    'slug': 'community-center',
    'order': 4,
    'short_description': 'A community space',
    'description': 'A space for local programs',
    'attachment_url': 'https://example.com/project.png',
    'attachment_path': 'projects',
    'attachment_name': 'project.png',
    'attachment_mime': 'image/png',
    'publish_status': 'Published',
    'created_at': createdAt,
    'updated_at': updatedAt,
  };

  test('maps project API fields to the project entity', () {
    final model = ProjectModel.fromJson(json);

    expect(model, isA<ProjectEntity>());
    expect(model.id, 'project-1');
    expect(model.title, 'Community Center');
    expect(model.order, 4);
    expect(model.shortDescription, 'A community space');
    expect(model.longDescription, 'A space for local programs');
    expect(model.createdAt, DateTime.parse(createdAt));
  });

  test('serializes fields using the API description key', () {
    final model = ProjectModel.fromJson(json);
    final serialized = model.toJson();

    expect(serialized['description'], 'A space for local programs');
    expect(serialized.containsKey('long_description'), isFalse);
    expect(
      ProjectModel.fromJson(serialized).longDescription,
      model.longDescription,
    );
    expect(serialized['order'], 4);
  });

  test('defaults a missing order to an integer zero', () {
    final model = ProjectModel.fromJson({...json, 'order': null});

    expect(model.order, 0);
  });
}
