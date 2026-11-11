import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/errors/failures.dart';
import 'package:pashboi/features/public/pages/data/models/page_model.dart';
import 'package:pashboi/features/public/pages/domain/enities/page_entity.dart';
import 'package:pashboi/features/public/pages/domain/usecases/fetch_page_usecase.dart';
import 'package:pashboi/features/public/pages/presentation/bloc/page_bloc.dart';

class _MockPageUseCase extends Mock implements PageUseCase {}

void main() {
  late _MockPageUseCase useCase;
  const props = PageProps(pageSlug: 'about-us');
  final page = PageModel.fromJson({
    'id': 'page-1',
    'title': 'About Us',
    'slug': 'about-us',
    'order': 1,
    'description': 'Our background',
    'created_at': '2025-01-01T10:00:00.000Z',
    'updated_at': '2025-01-02T10:00:00.000Z',
  });

  setUpAll(() {
    registerFallbackValue(props);
  });

  setUp(() {
    useCase = _MockPageUseCase();
  });

  PageBloc buildBloc() => PageBloc(pageUseCase: useCase);

  blocTest<PageBloc, PageState>(
    'emits loading then the requested page',
    setUp: () {
      when(
        () => useCase.call(props),
      ).thenAnswer((_) async => Right<Failure, PageEntity>(page));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const FetchPageEvent(props)),
    expect: () => [const PageLoading(), PageSuccess(pageData: page)],
    verify: (_) => verify(() => useCase.call(props)).called(1),
  );

  blocTest<PageBloc, PageState>(
    'emits an error when the requested page cannot be loaded',
    setUp: () {
      when(() => useCase.call(props)).thenAnswer(
        (_) async => const Left<Failure, PageEntity>(
          ServerFailure(message: 'Page unavailable'),
        ),
      );
    },
    build: buildBloc,
    act: (bloc) => bloc.add(const FetchPageEvent(props)),
    expect:
        () => [const PageLoading(), const PageError(error: 'Page unavailable')],
  );
}
