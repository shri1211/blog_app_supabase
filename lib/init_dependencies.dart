import 'package:blog_app_supabase/features/auth/data/datasources/auth_remote_data_sources.dart';
import 'package:blog_app_supabase/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog_app_supabase/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app_supabase/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app_supabase/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_app_supabase/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/secrets/app_secrets.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    publishableKey: AppSecrets.supabaseAnon,
  );
  serviceLocator.registerSingleton(() => supabase.client);
}

void initAuth() {
  serviceLocator.registerFactory<AuthRemoteDataSources>(
    () => AuthRemoteDataSourcesImpl(serviceLocator()),
  );

  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(serviceLocator()),
  );

  serviceLocator.registerFactory(() => UserSignUp(serviceLocator()));

  serviceLocator.registerFactory(() => CurrentUser(serviceLocator()));

  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator(),
      userLogin: serviceLocator(),
      currentUser: serviceLocator(),
    ),
  );
}

// try to optimize this code
//
// ..registerFactory<AuthRemoteDataSources>(
// () => AuthRemoteDataSourcesImpl(serviceLocator(),)
//
// ..registerFactory<AuthRepository>(
// () => AuthRepositoryImpl(serviceLocator(),)
//
// //  for signup
// ..registerFactory(() => UserSignUp(serviceLocator())
//
// //  for login
// ..registerFactory(() => UserLogin(serviceLocator()))
//
// ..registerLazySingleton(
// () => AuthBloc(userSignUp: serviceLocator(), userLogin: serviceLocator()),
// );
