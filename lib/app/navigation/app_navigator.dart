import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../developer/ui/developer_screen.dart';
import '../session/presentation/cubit/session_cubit.dart';
import '../ui/delete_account_setup_required_screen.dart';
import '../../features/auth/presentation/ui/login_screen.dart';
import '../../features/auth/presentation/ui/register_screen.dart';
import '../../features/profiles/presentation/ui/profile_screen.dart';

abstract final class AppNavigator {
  static Future<T?> goToLogin<T>(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<T>(
        builder: (_) => BlocProvider<SessionCubit>.value(
          value: context.read<SessionCubit>(),
          child: const LoginScreen(),
        ),
      ),
    );
  }

  static Future<T?> goToRegister<T>(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<T>(
        builder: (_) => BlocProvider<SessionCubit>.value(
          value: context.read<SessionCubit>(),
          child: const RegisterScreen(),
        ),
      ),
    );
  }

  static Future<T?> goToProfile<T>(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<T>(
        builder: (_) => BlocProvider<SessionCubit>.value(
          value: context.read<SessionCubit>(),
          child: const ProfileScreen(),
        ),
      ),
    );
  }

  static Future<T?> goToDeveloper<T>(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<T>(
        builder: (_) => BlocProvider<SessionCubit>.value(
          value: context.read<SessionCubit>(),
          child: const DeveloperScreen(),
        ),
      ),
    );
  }

  static Future<T?> goToDeleteAccountSetup<T>(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<T>(
        builder: (_) => const DeleteAccountSetupRequiredScreen(),
      ),
    );
  }
}
