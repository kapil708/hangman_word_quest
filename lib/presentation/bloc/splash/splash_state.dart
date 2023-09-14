part of 'splash_bloc.dart';

@immutable
abstract class SplashState extends Equatable {}

class STInitial extends SplashState {
  @override
  List<Object?> get props => [];
}

class STLoginSuccess extends SplashState {
  @override
  List<Object?> get props => [];
}

class STLoginFailed extends SplashState {
  @override
  List<Object?> get props => [];
}
