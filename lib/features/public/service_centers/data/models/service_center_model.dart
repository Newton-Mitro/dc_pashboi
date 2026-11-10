import 'package:pashboi/features/public/service_centers/data/models/incharge_model.dart';
import 'package:pashboi/features/public/service_centers/domain/entites/service_center_entity.dart';

class ServiceCenterModel extends ServiceCenterEntity {
  ServiceCenterModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.order,
    required super.email,
    required super.phone,
    required super.ipPhone,
    required super.fax,
    required super.lat,
    required super.lng,
    required super.collection,
    required super.time,
    required super.address,
    required super.inChargeInfos,
    required super.publishStatus,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ServiceCenterModel.fromJson(Map<String, dynamic> json) {
    return ServiceCenterModel(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      slug: json['slug'] ?? "",
      order: json['order'] ?? 0,
      email: json['email'] ?? "",
      phone: json['phone'] ?? "",
      ipPhone: json['ipPhone'] ?? "",
      fax: json['fax'] ?? "",
      lat: json['lag']?.toString() ?? "",
      lng: json['lng']?.toString() ?? "",
      collection: json['collection'] ?? "",
      time: json['time'] ?? "",
      address: json['address'] ?? "",
      inChargeInfos:
          json['incharge_infos'] != null
              ? List<InChargeModel>.from(
                (json['incharge_infos'] as List).map(
                  (e) => InChargeModel.fromJson(e),
                ),
              )
              : <InChargeModel>[],
      publishStatus: json['publish_status'] ?? "",
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : DateTime.now(),
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'order': order,
      'email': email,
      'phone': phone,
      'ipPhone': ipPhone,
      'fax': fax,
      'lng': lng,
      'lag': lat,
      'collection': collection,
      'time': time,
      'address': address,
      'incharge_infos':
          inChargeInfos.map((e) => (e as InChargeModel).toJson()).toList(),
      'publish_status': publishStatus,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
