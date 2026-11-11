import 'package:flutter_test/flutter_test.dart';
import 'package:pashboi/features/authenticated/family_and_friends/data/models/family_and_friend_model.dart';
import 'package:pashboi/features/authenticated/family_and_friends/data/models/realtionship_model.dart';

void main() {
  test('FamilyAndFriendModel maps relation and member fields', () {
    final model = FamilyAndFriendModel.fromJson({
      'RelationMapId': 4,
      'RelationName': 'Sibling',
      'PersonId': 10,
      'ParentPersonId': 12,
      'FullName': 'Family Member',
      'Age': 28,
      'Gender': 'Female',
      'RequestStatus': 'Approved',
    });

    expect(model.id, 4);
    expect(model.relationName, 'Sibling');
    expect(model.userPersonId, 10);
    expect(model.familyMemberId, 12);
    expect(model.familyMemberName, 'Family Member');
    expect(model.familyMemberAge, 28);
    expect(model.familyMemberGender, 'Female');
    expect(model.requestStatus, 'Approved');
    expect(model.toEntity(), same(model));
  });

  test('RelationshipModel maps relationship type fields', () {
    final model = RelationshipModel.fromJson({
      'Id': 2,
      'RelationName': 'Parent',
      'Gender': 'Any',
      'RelationTypeCode': 'P',
    });

    expect(model.id, 2);
    expect(model.name, 'Parent');
    expect(model.gender, 'Any');
    expect(model.code, 'P');
    expect(model.toJson(), {
      'id': 2,
      'name': 'Parent',
      'gender': 'Any',
      'code': 'P',
    });
  });
}
