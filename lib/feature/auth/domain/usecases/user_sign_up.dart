import 'package:blogapp/core/common/entities/user.dart';
import 'package:fpdart/fpdart.dart';
import 'package:blogapp/core/error/failure.dart';
import 'package:blogapp/core/usecase/usecase.dart';
import 'package:blogapp/feature/auth/domain/repository/auth_repository.dart';

class UserSignUp implements Usecase<User, UserSignUpParams> {
  final AuthRepository authRepository;
  UserSignUp({
    required this.authRepository,
  });

  @override
  Future<Either<Failure, User>> call(UserSignUpParams params) async{
    return await authRepository.signUp(name: params.name, email:    
      params.email, password: params.password);
  }
}

class UserSignUpParams {
  final String email;
  final String name;
  final String password;
  UserSignUpParams({
    required this.email,
    required this.name,
    required this.password,
  });
}
