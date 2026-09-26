import 'package:blog_app_supabase/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app_supabase/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app_supabase/features/auth/presentation/pages/login_page.dart';
import 'package:blog_app_supabase/features/auth/presentation/pages/sign_up.dart';
import 'package:blog_app_supabase/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app_supabase/features/blog/presentation/pages/blog_pages.dart';
import 'package:blog_app_supabase/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  //   we can not pass AuthRepository because , it can't be instantiated
  runApp(
    MultiBlocProvider(
      providers: [
        // these are get_it singletons, so use `value` (not `create`) so that
        // BlocProvider does not close an instance it does not own
        BlocProvider<AuthBloc>.value(value: serviceLocator<AuthBloc>()),
        BlocProvider<AppUserCubit>.value(value: serviceLocator<AppUserCubit>()),
        BlocProvider<BlogBloc>.value(value: serviceLocator<BlogBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLogin());
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.darkThemeMode,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, state) {
          if (state) {
            return BlogPage();
          }
          return LoginPage();
        },
      ),
    );
  }
}
