part of 'leave_application_bloc.dart';

class LeaveApplicationState extends Equatable {
  final Map<String, dynamic> validationErrors;
  final Map<String, dynamic> leaveApplicationData;

  final bool isLoading;
  final String? error;
  final String? successMessage;

  const LeaveApplicationState({
    Map<String, dynamic>? validationErrors,
    Map<String, dynamic>? leaveApplicationData,
    bool? isLoading,
    String? error,
    String? successMessage,
  }) : validationErrors = validationErrors ?? const {},
       leaveApplicationData = leaveApplicationData ?? const {},
       isLoading = isLoading ?? false,
       error = error ?? '',
       successMessage = successMessage ?? '';

  LeaveApplicationState copyWith({
    Map<String, dynamic>? validationErrors,
    Map<String, dynamic>? leaveApplicationData,
    bool? isLoading,
    String? error,
    String? successMessage,
  }) {
    return LeaveApplicationState(
      validationErrors: validationErrors ?? this.validationErrors,
      leaveApplicationData: leaveApplicationData ?? this.leaveApplicationData,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [
    validationErrors,
    leaveApplicationData,
    isLoading,
    error,
    successMessage,
  ];
}
