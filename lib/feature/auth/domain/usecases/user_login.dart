import 'package:blogapp/core/common/entities/user.dart';
import 'package:fpdart/fpdart.dart';
import 'package:blogapp/core/error/failure.dart';
import 'package:blogapp/core/usecase/usecase.dart';
import 'package:blogapp/feature/auth/domain/repository/auth_repository.dart';

class UserLogin implements Usecase<User, UserLoginParams> {
  final AuthRepository authRepository;
  UserLogin({
    required this.authRepository,
  });

  @override
  Future<Either<Failure, User>> call(UserLoginParams params) async {
    return await authRepository.login(
        email: params.email, password: params.password);
  }
}

class UserLoginParams {
  final String email;
  final String password;
  UserLoginParams({
    required this.email,
    required this.password,
  });
}
