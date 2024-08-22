import 'package:blogapp/core/error/failure.dart';
import 'package:blogapp/core/common/entities/user.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> login(
      {required String email, required String password});

  Future<Either<Failure, User>> signUp(
      {required String name,
      required String email,
      required String password});
  
  Future<Either<Failure, User>> getCurrentUser();
}
