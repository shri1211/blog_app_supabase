import 'package:blog_app_supabase/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app_supabase/features/auth/data/datasources/auth_remote_data_sources.dart';
import 'package:blog_app_supabase/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog_app_supabase/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app_supabase/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app_supabase/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_app_supabase/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app_supabase/features/blog/data/datasources/blog_local_data_sources.dart';
import 'package:blog_app_supabase/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blog_app_supabase/features/blog/data/repositories/blog_repositories_impl.dart';
import 'package:blog_app_supabase/features/blog/domain/repositories/blog_repositories.dart';
import 'package:blog_app_supabase/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/networks/connection_checker.dart';
import 'core/secrets/app_secrets.dart';
import 'features/blog/domain/usecases/upload_blog.dart';
import 'features/blog/presentation/bloc/blog_bloc.dart';
import 'init_dependencies.dart' as Hive;

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    publishableKey: AppSecrets.supabaseAnon,
  );

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  serviceLocator.registerSingleton(() => supabase.client);
  serviceLocator.registerLazySingleton(() => Hive.box(name: 'blogs'));
  serviceLocator.registerFactory(() => InternetConnection());
  //core
  serviceLocator.registerSingleton(() => AppUserCubit());
  // new instance have to be created every single time
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(serviceLocator()),
  );
}

void _initAuth() {
  serviceLocator.registerFactory<AuthRemoteDataSources>(
    () => AuthRemoteDataSourcesImpl(serviceLocator()),
  );

  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(serviceLocator(), serviceLocator()),
  );

  serviceLocator.registerFactory(() => UserSignUp(serviceLocator()));

  serviceLocator.registerFactory(() => CurrentUser(serviceLocator()));

  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator(),
      userLogin: serviceLocator(),
      currentUser: serviceLocator(),
      appUserCubit: serviceLocator(),
    ),
  );
}

//  datasource , repository , usecase, bloc    ( take serviceLocator as common )
void _initBlog() {
  //  Datasource
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(serviceLocator()),
    )
    // repository
    ..registerFactory<BlogRepositories>(
      () => BlogRepositoriesImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )
    ..registerFactory(() => UploadBlog(serviceLocator()))
    ..registerFactory(() => GetAllBlogs(serviceLocator()))
    ..registerLazySingleton(
      () =>
          BlogBloc(uploadBlog: serviceLocator(), getAllBlogs: serviceLocator()),
    );

  // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  // // datasource
  // serviceLocator.registerFactory<BlogRemoteDataSource>(
  //   () => BlogRemoteDataSourceImpl(serviceLocator()),
  // );
  //
  // // repository
  // serviceLocator.registerFactory<BlogRepositories>(
  //   () => BlogRepositoriesImpl(serviceLocator()),
  // );
  //
  // // usecase
  // serviceLocator.registerFactory(() => UploadBlog(serviceLocator()));
  //
  // // bloc
  // serviceLocator.registerLazySingleton(() => BlogBloc(serviceLocator()));
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
