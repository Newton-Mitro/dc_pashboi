import 'package:pashboi/core/entities/entity.dart';

class WoooTypeEntities extends Entity<int> {
  final int woooTypeId;
  final String woooTypeName;
  final String woooTypeCode;
  final int backDateDays;
  final String fromDate;
  final String toDate;

  WoooTypeEntities({
    super.id,
    required this.woooTypeId,
    required this.woooTypeName,
    required this.woooTypeCode,
    required this.backDateDays,
    required this.fromDate,
    required this.toDate,
  });

  @override
  List<Object?> get props => [
    id,
    woooTypeId,
    woooTypeName,
    woooTypeCode,
    backDateDays,
    fromDate,
    toDate,
  ];
}
