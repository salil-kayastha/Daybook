import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme.dart';
import '../../core/widgets/daybook_button.dart';
import '../auth/auth_providers.dart';

/// Minimal Settings (M4): account email + sign out. The rest of SPEC §7.5
/// (theme, notifications, categories management, sync status) comes in
/// later milestones.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = context.daybookText;
    final colors = context.daybookColors;
    final email = ref.watch(authRepositoryProvider).currentUser?.email;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(DaybookSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ACCOUNT',
              style: text.sectionTitle.copyWith(color: colors.inkMuted),
            ),
            const SizedBox(height: DaybookSpacing.sm),
            Text(email ?? '—', style: text.body),
            const SizedBox(height: DaybookSpacing.lg),
            DaybookButton(
              label: 'Sign out',
              variant: DaybookButtonVariant.danger,
              onPressed: () => ref.read(authRepositoryProvider).signOut(),
            ),
          ],
        ),
      ),
    );
  }
}
