import 'package:pashboi/features/public/project/domain/entites/project_entity.dart';

class ProjectModel extends ProjectEntity {
  ProjectModel({
    required super.id,
    required super.title,
    required super.slug,
    required super.order,
    required super.shortDescription,
    required super.longDescription,
    required super.attachmentUrl,
    required super.attachmentPath,
    required super.attachmentName,
    required super.attachmentMimeType,
    required super.publishStatus,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] ?? "",
      title: json['title'] ?? "",
      slug: json['slug'] ?? "",
      order: json['order'] ?? 0,
      shortDescription: json['short_description'] ?? "",
      longDescription: json['description'] ?? "",
      attachmentUrl: json['attachment_url'] ?? "",
      attachmentPath: json['attachment_path'] ?? "",
      attachmentName: json['attachment_name'] ?? "",
      attachmentMimeType: json['attachment_mime'] ?? "",
      publishStatus: json['publish_status'] ?? "",
      createdAt: DateTime.parse(json['created_at'] ?? ""),
      updatedAt: DateTime.parse(json['updated_at'] ?? ""),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'order': order,
      'short_description': shortDescription,
      'description': longDescription,
      'attachment_url': attachmentUrl,
      'attachment_path': attachmentPath,
      'attachment_name': attachmentName,
      'attachment_mime': attachmentMimeType,
      'publish_status': publishStatus,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
