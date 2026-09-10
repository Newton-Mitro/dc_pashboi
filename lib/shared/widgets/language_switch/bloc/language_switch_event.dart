part of 'language_switch_bloc.dart';

abstract class LanguageSwitchEvent extends Equatable {
  const LanguageSwitchEvent();

  @override
  List<Object?> get props => [];
}

class SwitchLanguage extends LanguageSwitchEvent {
  final String language;

  const SwitchLanguage({required this.language});

  @override
  List<Object?> get props => [language];
}

class LoadLocaleEvent extends LanguageSwitchEvent {
  const LoadLocaleEvent();
}
