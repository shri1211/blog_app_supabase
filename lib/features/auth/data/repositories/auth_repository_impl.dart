import 'package:blog_app_supabase/core/error/exceptions.dart';
import 'package:blog_app_supabase/core/error/failure.dart';
import 'package:blog_app_supabase/features/auth/data/datasources/auth_remote_data_sources.dart';
import 'package:blog_app_supabase/features/auth/data/models/user_model.dart';
import 'package:fpdart/fpdart.dart'; //   import entire fpdart package
import 'package:blog_app_supabase/core/entities/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../../../../core/networks/connection_checker.dart';
import '../../domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSources remoteDataSources;
  final ConnectionChecker internetConnection;
  const AuthRepositoryImpl(this.remoteDataSources, this.internetConnection);
  @override
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    // try {
    //   final user = await remoteDataSources.loginWithEmailPassword(
    //     email: email,
    //     password: password,
    //   );
    //   return Right(user);
    // } on ServerExceptions catch (e) {
    //   return left(Failure(e.message));
    // }
    return _getUser(
      () async => await remoteDataSources.loginWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSources.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  //  this function used mainly for re-usability
  Future<Either<Failure, User>> _getUser(Future<User> Function() fn) async {
    try {
      if (!await (internetConnection.isConnected)) {
        return Left(Failure("No Internet Connection"));
      }

      final user = await fn();
      return right(user);
    } on sb.AuthException catch (e) {
      return left(Failure(e.message));
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }

  // user can be null , so we didn't re-used above functions
  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      //  need to hide first and run
      if (!await (internetConnection.isConnected)) {
        final session = remoteDataSources.currentUserSession;
        if (session == null) {
          return left(Failure("User is not Logged Inn"));
        }
        return Right(
          UserModel(
            id: session.user.id,
            email: session.user.email ?? '',
            name: '',
          ),
        );
      }

      final user = await remoteDataSources.getCurrentUserData();
      if (user == null) {
        return left(Failure("User is not Logged Inn"));
      }
      return Right(user);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }
}
