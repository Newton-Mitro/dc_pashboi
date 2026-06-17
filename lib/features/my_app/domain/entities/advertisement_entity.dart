import 'package:equatable/equatable.dart';

class AdvertisementEntity extends Equatable {
  final String id;
  final String title;
  final String attachmentUrl;
  final String attachmentMime;

  const AdvertisementEntity({
    required this.id,
    required this.title,
    required this.attachmentUrl,
    required this.attachmentMime,
  });

  AdvertisementEntity copyWith({
    String? id,
    String? title,
    String? attachmentUrl,
    String? attachmentMime,
  }) {
    return AdvertisementEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      attachmentMime: attachmentMime ?? this.attachmentMime,
    );
  }

  @override
  List<Object?> get props => [id, title, attachmentUrl, attachmentMime];
}
