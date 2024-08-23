import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blogapp/feature/blog/domain/usecases/upload_blog.dart';
part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog uploadBlog;
  BlogBloc(
    this.uploadBlog,
  ) : super(BlogInitialState()) {
    on<BlogEvent>(
      (event, emit) => emit(
        BlogLoadingState(),
      ),
    );
    on<BlogUploaEvent>(_onBlogUpload);
  }

  void _onBlogUpload(BlogUploaEvent event, Emitter<BlogState> emit) async {
    final res = await uploadBlog(UploadBlogParams(
      posterId: event.posterId,
      title: event.title,
      content: event.content,
      image: event.image,
      topics: event.topics,
    ));
    res.fold((error) => emit(BlogErrorState(errorMsg: error.message)),
        (data) => emit(BlogSuccesState()));
  }
}
