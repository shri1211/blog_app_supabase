import 'package:blog_app_supabase/core/error/failure.dart';
import 'package:blog_app_supabase/core/usecase/usecase.dart';
import 'package:blog_app_supabase/features/auth/domain/repository/auth_repository.dart';

import 'package:fpdart/fpdart.dart';

import '../../../../core/entities/user.dart';

class CurrentUser implements UseCases<User, NoParams> {
  // here AuthRepository is coming from Domain Layer only
  final AuthRepository authRepository;
  CurrentUser(this.authRepository);
  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return authRepository.currentUser();
  }
}

// here if no parameter found , just put it in interface in core useCases
