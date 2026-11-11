import 'package:pashboi/core/entities/entity.dart';
import 'package:pashboi/features/public/service_centers/domain/entites/incharge_entity.dart';

class ServiceCenterEntity extends Entity<String> {
  final String name;
  final String slug;
  final int order;
  final String email;
  final String phone;
  final String ipPhone;
  final String fax;
  final String lat;
  final String lng;
  final String collection;
  final String time;
  final String address;
  final List<InChargeEntity> inChargeInfos;
  final String publishStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceCenterEntity({
    required this.name,
    required this.slug,
    required this.order,
    required this.email,
    required this.phone,
    required this.ipPhone,
    required this.fax,
    required this.lat,
    required this.lng,
    required this.collection,
    required this.time,
    required this.address,
    required this.inChargeInfos,
    required this.publishStatus,
    required this.createdAt,
    required this.updatedAt,
    required super.id,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    slug,
    order,
    email,
    phone,
    ipPhone,
    fax,
    lat,
    lng,
    collection,
    time,
    address,
    inChargeInfos,
    publishStatus,
    createdAt,
    updatedAt,
  ];
}
