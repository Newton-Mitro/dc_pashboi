import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/features/public/pages/domain/enities/page_entity.dart';
import 'package:pashboi/features/public/pages/domain/repositories/page_repository.dart';
import 'package:pashboi/features/public/pages/domain/usecases/fetch_page_usecase.dart';

class _MockPageRepository extends Mock implements PageRepository {}

void main() {
  late _MockPageRepository repository;
  late PageUseCase useCase;
  const props = PageProps(pageSlug: 'about-us');

  setUp(() {
    repository = _MockPageRepository();
    useCase = PageUseCase(pageRepository: repository);
  });

  test('delegates page lookup with the supplied slug', () async {
    final page = PageEntity(
      id: 'page-1',
      title: 'About Us',
      slug: 'about-us',
      order: 1,
      shortDescription: '',
      longDescription: 'Our background',
      attachmentUrl: '',
      attachmentPath: '',
      attachmentName: '',
      attachmentMimeType: '',
      publishStatus: 'Published',
      createdAt: DateTime(2025),
      updatedAt: DateTime(2025, 1, 2),
    );
    when(
      () => repository.findPageByPageSlug(props),
    ).thenAnswer((_) async => Right<Failure, PageEntity>(page));

    final result = await useCase(props);

    expect(
      result.fold((_) => false, (value) => identical(value, page)),
      isTrue,
    );
    verify(() => repository.findPageByPageSlug(props)).called(1);
  });
}
