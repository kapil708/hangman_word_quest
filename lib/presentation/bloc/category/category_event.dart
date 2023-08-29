part of 'category_bloc.dart';

@immutable
abstract class CategoryEvent extends Equatable {}

class CategoryLoading extends CategoryEvent {
  @override
  List<Object?> get props => [];
}
