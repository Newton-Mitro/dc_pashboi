import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'submit_deposit_loan_application_event.dart';
part 'submit_deposit_loan_application_state.dart';

class SubmitDepositLoanApplicationBloc extends Bloc<SubmitDepositLoanApplicationEvent, SubmitDepositLoanApplicationState> {
  SubmitDepositLoanApplicationBloc() : super(SubmitDepositLoanApplicationInitial()) {
    on<SubmitDepositLoanApplicationEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
