import 'package:blogapp/core/error/exception.dart';
import 'package:blogapp/core/error/failure.dart';
import 'package:blogapp/feature/auth/data/datasource/auth_remote_data_sources.dart';
import 'package:blogapp/core/common/entities/user.dart';
import 'package:blogapp/feature/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthRepositoryImp implements AuthRepository {
  final AuthRemoteDataSources authRemoteDataSources;

  AuthRepositoryImp({
    required this.authRemoteDataSources,
  });

  @override
  Future<Either<Failure, User>> login(
      {required String email, required String password}) async {
    return _getUser(
      () async =>
          await authRemoteDataSources.login(email: email, password: password, ),
    );
  }

  Future<Either<Failure, User>> _getUser(
    Future<User> Function() fn,
  ) async {
    try {
      final user = await fn();
      return Right(user);
    } on sb.AuthException catch(e){
      return Left(
        Failure(
          e.toString(),
        ),
      );
    } on ServerException catch (e) {
      return Left(
        Failure(
          e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, User>> signUp(
      {required String name,
      required String email,
      required String password}) async {
    try {
      final user = await authRemoteDataSources.signUp(
          name: name, email: email, password: password);
      return Right(user);
    } on ServerException catch (e) {
      return Left(Failure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, User>> getCurrentUser() async{
    
    try{
      final user = await authRemoteDataSources.getCurrentUserData();
      if(user ==null){
        return Left(Failure("User not logged in!"));
      }
      return Right(user);
    }on ServerException catch(e){
      return Left(Failure(e.toString()));
    }
  }
}
