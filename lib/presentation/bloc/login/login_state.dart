part of 'login_cubit.dart';

@immutable
abstract class LoginState extends Equatable {}

class LoginInitial extends LoginState {
  @override
  List<Object?> get props => [];
}

class STLoading extends LoginState {
  @override
  List<Object?> get props => [];
}

class STLoginFailed extends LoginState {
  final String message;

  STLoginFailed(this.message);

  @override
  List<Object?> get props => [message];
}

class STLoginSuccess extends LoginState {
  @override
  List<Object?> get props => [];
}
