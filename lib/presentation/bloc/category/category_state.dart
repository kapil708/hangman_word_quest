part of 'category_bloc.dart';

@immutable
abstract class CategoryState extends Equatable {}

class CategoryInitial extends CategoryState {
  @override
  List<Object?> get props => [];
}

class CategoryLoadingState extends CategoryState {
  @override
  List<Object?> get props => [];
}

class CategoryFailed extends CategoryState {
  final String message;

  CategoryFailed(this.message);

  @override
  List<Object?> get props => [message];
}

class CategoryLoaded extends CategoryState {
  final List<CategoryEntity> categoryList;

  CategoryLoaded(this.categoryList);

  @override
  List<Object?> get props => [categoryList];
}
