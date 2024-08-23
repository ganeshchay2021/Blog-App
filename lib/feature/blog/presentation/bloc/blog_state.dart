part of 'blog_bloc.dart';

@immutable
sealed class BlogState {}

final class BlogInitialState extends BlogState {}

final class BlogLoadingState extends BlogState {}

final class BlogSuccesState extends BlogState {}

final class BlogErrorState extends BlogState {
  final String errorMsg;

  BlogErrorState({required this.errorMsg});
}


