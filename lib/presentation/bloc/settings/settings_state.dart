part of 'settings_cubit.dart';

@immutable
abstract class SettingsState extends Equatable {}

class STInitial extends SettingsState {
  @override
  List<Object?> get props => [];
}

class STInitialDone extends SettingsState {
  @override
  List<Object?> get props => [];
}

class STLoginSuccess extends SettingsState {
  @override
  List<Object?> get props => [];
}

class STMessageClosed extends SettingsState {
  @override
  List<Object?> get props => [];
}

class STLoginFailed extends SettingsState {
  final String message;

  STLoginFailed(this.message);

  @override
  List<Object?> get props => [];
}
