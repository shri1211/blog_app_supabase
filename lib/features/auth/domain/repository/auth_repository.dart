import 'package:blog_app_supabase/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/entities/user.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  // we are not returning String ..   returning model instead of String  ,, first String  then Model
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> currentUser();
}
