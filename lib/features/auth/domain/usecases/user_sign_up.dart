import 'package:blog_app_supabase/core/error/failure.dart';
import 'package:blog_app_supabase/core/usecase/usecase.dart';
import 'package:blog_app_supabase/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/entities/user.dart';

//  generics takes only one as parameter
class UserSignUp implements UseCases<User, UserSignUpParams> {
  final AuthRepository authRepository;
  UserSignUp(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserSignUpParams params) async {
    // TODO: implement call
    return await authRepository.signUpWithEmailPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

// signUp has 3 patrameter
class UserSignUpParams {
  final String name;
  final String email;
  final String password;

  UserSignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });
}
