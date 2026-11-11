import 'package:flutter_test/flutter_test.dart';
import 'package:pashboi/features/public/loan_policies/data/models/loan_policy_model.dart';
import 'package:pashboi/features/public/loan_policies/domain/entites/loan_policy_entity.dart';

void main() {
  const createdAt = '2025-01-01T10:00:00.000Z';
  const updatedAt = '2025-01-02T10:00:00.000Z';
  final json = {
    'id': 'policy-1',
    'title': 'Personal Loan',
    'slug': 'personal-loan',
    'order': 3,
    'short_description': 'Personal loan terms',
    'long_description': 'Full personal loan policy',
    'attachment_url': 'https://example.com/policy.pdf',
    'attachment_path': 'policies',
    'attachment_name': 'policy.pdf',
    'attachment_mime': 'application/pdf',
    'publish_status': 'Published',
    'product_categories_id': 'category-1',
    'created_at': createdAt,
    'updated_at': updatedAt,
  };

  test('maps policy API fields to the loan policy entity', () {
    final model = LoanPolicyModel.fromJson(json);

    expect(model, isA<LoanPolicyEntity>());
    expect(model.id, 'policy-1');
    expect(model.title, 'Personal Loan');
    expect(model.order, 3);
    expect(model.longDescription, 'Full personal loan policy');
    expect(model.categoryId, 'category-1');
    expect(model.createdAt, DateTime.parse(createdAt));
  });

  test('serializes policy fields and supports a description round trip', () {
    final model = LoanPolicyModel.fromJson(json);
    final serialized = model.toJson();

    expect(serialized['long_description'], 'Full personal loan policy');
    expect(serialized['product_categories_id'], 'category-1');
    expect(
      LoanPolicyModel.fromJson(serialized).longDescription,
      model.longDescription,
    );
    expect(serialized['order'], 3);
  });

  test('defaults a missing order to integer zero', () {
    final model = LoanPolicyModel.fromJson({...json, 'order': null});

    expect(model.order, 0);
  });
}
