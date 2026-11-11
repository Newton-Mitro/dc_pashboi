import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pashboi/core/locale/services/app_localization_service.dart';
import 'package:pashboi/features/auth/domain/usecases/get_auth_user_usecase.dart';
import 'package:pashboi/features/authenticated/family_and_friends/domain/usecases/add_family_and_friend_usecase.dart';
import 'package:pashboi/features/authenticated/family_and_friends/presentation/pages/bloc/add_family_and_relative_bloc/add_family_and_relative_bloc.dart';

class _MockGetAuthUserUseCase extends Mock implements GetAuthUserUseCase {}

class _MockAddFamilyAndFriendUseCase extends Mock
    implements AddFamilyAndFriendUsecase {}

class _MockLocalizationService extends Mock implements AppLocalizationService {}

void main() {
  late _MockGetAuthUserUseCase getAuthUserUseCase;
  late _MockAddFamilyAndFriendUseCase addFamilyAndFriendUseCase;
  late _MockLocalizationService localizationService;

  setUp(() {
    getAuthUserUseCase = _MockGetAuthUserUseCase();
    addFamilyAndFriendUseCase = _MockAddFamilyAndFriendUseCase();
    localizationService = _MockLocalizationService();
    when(() => localizationService.t(any())).thenAnswer(
      (invocation) => invocation.positionalArguments.single as String,
    );
  });

  AddFamilyAndRelativeBloc createBloc() => AddFamilyAndRelativeBloc(
    getAuthUserUseCase: getAuthUserUseCase,
    addFamilyAndFriendUseCase: addFamilyAndFriendUseCase,
    appLocalizationService: localizationService,
  );

  blocTest<AddFamilyAndRelativeBloc, AddFamilyAndRelativeState>(
    'validates search number, relationship, and matched member',
    build: createBloc,
    act:
        (bloc) => bloc.add(
          const AddFamilyAndRelativeSubmitted(
            childPersonId: 0,
            relationTypeCode: '',
            searchAccountNumber: '',
          ),
        ),
    expect:
        () => [
          const AddFamilyAndRelativeLoading(),
          const AddFamilyAndRelativeValidationErrorState({
            'searchAccountNumber': 'please_enter_account_number',
            'relationTypeCode': 'please_enter_relationship',
            'memberName': 'please_search_with_a_valid_account_number',
          }),
        ],
    verify: (_) {
      verifyNever(() => getAuthUserUseCase.call(any()));
    },
  );
}
