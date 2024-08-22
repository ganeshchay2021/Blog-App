import 'package:blogapp/core/common/cubits/app%20user/app_user_cubit.dart';
import 'package:blogapp/core/usecase/usecase.dart';
import 'package:blogapp/core/common/entities/user.dart';
import 'package:blogapp/feature/auth/domain/usecases/current_user.dart';
import 'package:blogapp/feature/auth/domain/usecases/user_login.dart';
import 'package:blogapp/feature/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  AuthBloc(
      {required UserSignUp userSignUp,
      required UserLogin userLogin,
      required AppUserCubit appuserCubit,
      required CurrentUser currentUser})
      : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _appUserCubit = appuserCubit,
        super(AuthInitialState()) {
    on<AuthEvent>((_, emit) => emit(AuthLoadingState()));
    //on Signup Event
    on<AuthSignUpEvent>((event, emit) async {
      final result = await _userSignUp(
        UserSignUpParams(
            email: event.email, name: event.name, password: event.password),
      );

      result.fold((error) => emit(AuthErrorState(message: error.message)),
          (user) => _emitAuthSuccess(user, emit));
    });

    //on login event
    on<AuthLoginEvent>((event, emit) async {
      final result = await _userLogin(
        UserLoginParams(email: event.email, password: event.password),
      );
      result.fold((error) => emit(AuthErrorState(message: error.message)),
          (user) => _emitAuthSuccess(user, emit));
    });

    on<AuthIsUserLoggin>((event, emit) async {
      final result = await _currentUser(NoParams());
      result.fold((error) => emit(AuthErrorState(message: error.message)),
          (user) => _emitAuthSuccess(user, emit));
    });
  }
  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccessState(user: user));
  }
}
