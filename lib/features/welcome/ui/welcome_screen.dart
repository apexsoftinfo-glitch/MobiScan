import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/navigation/app_navigator.dart';
import '../../../core/di/injection.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/error_messages.dart';
import '../../auth/presentation/cubit/welcome_cubit.dart';
import '../../../core/design/app_design_system.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WelcomeCubit>(
      create: (_) => getIt<WelcomeCubit>(),
      child: const _WelcomeView(),
    );
  }
}

class _WelcomeView extends StatelessWidget {
  const _WelcomeView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: BlocBuilder<WelcomeCubit, WelcomeState>(
                  builder: (context, state) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _WelcomeAppIcon(),
                        const SizedBox(height: 24),
                        Text(
                          l10n.welcomeTitle,
                          textAlign: TextAlign.center,
                          style: AppDesignSystem.headline(context),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.welcomeBody,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            height: 1.5,
                          ),
                        ),
                        if (state.errorKey != null) ...[
                          const SizedBox(height: 24),
                          SelectableText(
                            messageForErrorKey(l10n, state.errorKey),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ],
                        const SizedBox(height: 32),
                        FilledButton(
                          onPressed: state.isLoading
                              ? null
                              : () => context
                                    .read<WelcomeCubit>()
                                    .continueAsGuest(),
                          child: state.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(l10n.continueAsGuestButtonLabel),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: state.isLoading
                              ? null
                              : () => AppNavigator.goToLogin(context),
                          style: TextButton.styleFrom(
                            foregroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          child: Text(l10n.loginButtonLabel),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WelcomeAppIcon extends StatelessWidget {
  const _WelcomeAppIcon();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Image.asset(
            'assets/images/icon/icon.png',
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
