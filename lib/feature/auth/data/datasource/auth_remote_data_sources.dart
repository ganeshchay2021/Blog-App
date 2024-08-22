import 'package:blogapp/core/error/exception.dart';
import 'package:blogapp/feature/auth/data/model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSources {

  Session? get currentUserSession;

  Future<UserModel> login({required String email, required String password});

  Future<UserModel> signUp(
      {required String name, required String email, required String password});
    
  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDataSourcesImp implements AuthRemoteDataSources {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourcesImp({
    required this.supabaseClient,
  });


  
  @override
   Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth
          .signInWithPassword(password: password, email: email);
      if (response.user == null) {
        throw ServerException(message: "User is null");
      }
      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {
          "name": name,
        },
      );
      if (response.user == null) {
        throw ServerException(message: "User is null");
      }
      final result = UserModel.fromJson(response.user!.toJson());
      return result;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  
  @override
  Future<UserModel?> getCurrentUserData() async{
    try{
      if(currentUserSession !=null){
         final userData= await supabaseClient.from("profiles").select().eq("id", currentUserSession!.user.id);
         return UserModel.fromJson(userData.first).copyWith(email: currentUserSession!.user.email);
    }
    return null;
    }catch(e){
      throw ServerException(message: e.toString());
    }
 
  }
  
}
