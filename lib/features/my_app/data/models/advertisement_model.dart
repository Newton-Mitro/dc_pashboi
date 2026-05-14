import 'package:pashboi/features/my_app/domain/entities/advertisement_entity.dart';

class AdvertisementModel extends AdvertisementEntity {
  const AdvertisementModel({
    required super.id,
    required super.title,
    required super.attachmentUrl,
    required super.attachmentMime,
  });

  factory AdvertisementModel.fromJson(Map<String, dynamic> json) {
    return AdvertisementModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      attachmentUrl: json['attachment_url'] ?? '',
      attachmentMime: json['attachment_mime'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'attachment_url': attachmentUrl,
      'attachment_mime': attachmentMime,
    };
  }

  @override
  AdvertisementModel copyWith({
    String? id,
    String? title,
    String? attachmentUrl,
    String? attachmentMime,
  }) {
    return AdvertisementModel(
      id: id ?? this.id,
      title: title ?? this.title,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      attachmentMime: attachmentMime ?? this.attachmentMime,
    );
  }
}
