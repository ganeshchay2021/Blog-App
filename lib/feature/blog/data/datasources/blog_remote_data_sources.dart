import 'dart:io';

import 'package:blogapp/core/error/exception.dart';
import 'package:blogapp/feature/blog/data/model/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSources {
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<String> uploadBlogImage({ required File image, required BlogModel blog});

}

class BlogRemoteDataSourcesImp extends BlogRemoteDataSources {
  final SupabaseClient supabaseClient;

  BlogRemoteDataSourcesImp({required this.supabaseClient});

  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      final blogData =
          await supabaseClient.from('blogs').insert(blog.toJson()).select();
print("This is Blog $blogData" );
      return BlogModel.fromJson(blogData.first);
    } catch (e) {
      throw ServerException(
        message: e.toString(),
      );
    }
  }
  
  @override
  Future<String> uploadBlogImage({required File image, required BlogModel blog}) async{
    try{
    await supabaseClient.storage.from("blogs_images").upload(blog.id, image);
    return supabaseClient.storage.from("blogs_images").getPublicUrl(blog.id);
    }catch(e){
      throw ServerException(message: e.toString());
    }
  }
}
