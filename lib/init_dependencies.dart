import 'package:blogapp/core/common/cubits/app%20user/app_user_cubit.dart';
import 'package:blogapp/core/secretes/app_secretes.dart';
import 'package:blogapp/feature/auth/data/datasource/auth_remote_data_sources.dart';
import 'package:blogapp/feature/auth/data/repositories/auth_repository_imp.dart';
import 'package:blogapp/feature/auth/domain/repository/auth_repository.dart';
import 'package:blogapp/feature/auth/domain/usecases/current_user.dart';
import 'package:blogapp/feature/auth/domain/usecases/user_login.dart';
import 'package:blogapp/feature/auth/domain/usecases/user_sign_up.dart';
import 'package:blogapp/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:blogapp/feature/blog/data/datasources/blog_remote_data_sources.dart';
import 'package:blogapp/feature/blog/data/repository/blog_repository_imp.dart';
import 'package:blogapp/feature/blog/domain/repository/blog_repository.dart';
import 'package:blogapp/feature/blog/domain/usecases/upload_blog.dart';
import 'package:blogapp/feature/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDepedencies() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
    url: AppSecretes.superBaseUrl,
    anonKey: AppSecretes.superBaseKey,
  );
  serviceLocator.registerLazySingleton(() => supabase.client);

  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  //Data Source
  serviceLocator
    ..registerFactory<AuthRemoteDataSources>(
      () => AuthRemoteDataSourcesImp(
        supabaseClient: serviceLocator(),
      ),
    )

    //repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImp(
        authRemoteDataSources: serviceLocator(),
      ),
    )

    //Use Case
    ..registerFactory(
      () => UserSignUp(
        authRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLogin(
        authRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CurrentUser(
        authRepository: serviceLocator(),
      ),
    )

    //Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appuserCubit: serviceLocator(),
      ),
    );
}

void _initBlog() {
  //Data Source
  serviceLocator
    ..registerFactory<BlogRemoteDataSources>(
      () => BlogRemoteDataSourcesImp(
        supabaseClient: serviceLocator(),
      ),
    )

    //repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImp(blogRemoteDataSources: serviceLocator()),
    )

    //Use Case
    ..registerFactory(
      () => UploadBlog(blogRepository: serviceLocator())
    )
       //Bloc
    ..registerLazySingleton(
      () => BlogBloc(serviceLocator())
    );
}