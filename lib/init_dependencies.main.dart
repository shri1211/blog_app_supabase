part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    publishableKey: AppSecrets.supabaseAnon,
  );

  // Initialize Hive
  await Hive.initFlutter();

  // Open Hive box
  await Hive.openBox('blogs');

  // Register core dependencies
  serviceLocator.registerSingleton(supabase.client);

  serviceLocator.registerLazySingleton<Box>(() => Hive.box('blogs'));

  serviceLocator.registerFactory(() => InternetConnection());
  //core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
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
  serviceLocator.registerFactory(() => UserLogin(serviceLocator()));

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
      () => BlogRemoteDataSourceImpl(serviceLocator(),serviceLocator()),
    )
    ..registerFactory<BlogLocalDataSources>(
      () => BlogLocalDataSourcesImpl(serviceLocator()),
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
