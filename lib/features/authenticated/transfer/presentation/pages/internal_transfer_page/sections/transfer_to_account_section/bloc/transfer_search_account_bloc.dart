import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'transfer_search_account_event.dart';
part 'transfer_search_account_state.dart';

class TransferSearchAccountBloc extends Bloc<TransferSearchAccountEvent, TransferSearchAccountState> {
  TransferSearchAccountBloc() : super(TransferSearchAccountInitial()) {
    on<TransferSearchAccountEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
