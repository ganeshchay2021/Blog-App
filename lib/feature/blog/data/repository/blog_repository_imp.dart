import 'dart:io';

import 'package:blogapp/core/error/exception.dart';
import 'package:blogapp/core/error/failure.dart';
import 'package:blogapp/feature/blog/data/datasources/blog_remote_data_sources.dart';
import 'package:blogapp/feature/blog/data/model/blog_model.dart';
import 'package:blogapp/feature/blog/domain/entities/blog.dart';
import 'package:blogapp/feature/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImp implements BlogRepository {
  final BlogRemoteDataSources blogRemoteDataSources;

  BlogRepositoryImp({required this.blogRemoteDataSources});
  @override
  Future<Either<Failure, Blog>> uploadBlog(
      {required File image,
      required String title,
      required String content,
      required String posterId,
      required List<String> topics}) async {

   try{
     BlogModel blogModel = BlogModel(
      id: const Uuid().v1(),
      posterId: posterId,
      title: title,
      content: content,
      imageUrl: "",
      topics: topics,
      updatedAt: DateTime.now(),
    );
    final imageUrl= await blogRemoteDataSources.uploadBlogImage(image: image, blog: blogModel);
    blogModel=blogModel.copyWith(
      imageUrl: imageUrl
    );
   final uploadedBlog = await blogRemoteDataSources.uploadBlog(blogModel);
   return Right(uploadedBlog);
   }on ServerException catch(e){
     return Left(Failure(e.toString()));
   }
  }
}
