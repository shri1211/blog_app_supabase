import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../entities/user.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());

  void updateUser(User? user) {
    if (user == null) {
      // why are we doing AppUserInitial when already we written above
      // because if we logout , we should update the user and should show login page , means login page
      emit(AppUserInitial()); //  logout state
    } else {
      emit(AppUserLoggedIn(user));
    }
  }
}
