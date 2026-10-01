import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/theme.dart';
import '../../core/widgets/daybook_button.dart';
import '../../data/local/database_provider.dart';
import '../../data/sync/sync_status.dart';
import '../auth/auth_providers.dart';
import '../sync/sync_providers.dart';

/// Account email + sign out (M4), plus a sync status section (M5): last
/// synced time, pending/failed counts, and a manual "Sync now" (SPEC
/// §7.5). The rest of SPEC §7.5 (theme, notifications, categories
/// management) comes in later milestones.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final engine = ref.read(syncEngineProvider);
    await engine.push();
    final status = engine.status.value;
    final unsynced = status.pendingCount + status.failedCount;

    if (unsynced > 0 && context.mounted) {
      final proceed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Some changes aren\'t uploaded yet'),
          content: Text(
            '$unsynced change${unsynced == 1 ? '' : 's'} on this device '
            'could not be uploaded. Signing out now will leave them '
            'un-synced until you sign back in.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Sign out anyway'),
            ),
          ],
        ),
      );
      if (proceed != true) return;
    }

    engine.stopRealtime();
    await ref.read(appDatabaseProvider).clearForSignOut();
    await ref.read(authRepositoryProvider).signOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = context.daybookText;
    final colors = context.daybookColors;
    final email = ref.watch(authRepositoryProvider).currentUser?.email;
    final engine = ref.watch(syncEngineProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(DaybookSpacing.lg),
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
            onPressed: () => _signOut(context, ref),
          ),
          const SizedBox(height: DaybookSpacing.xl),
          Text(
            'SYNC',
            style: text.sectionTitle.copyWith(color: colors.inkMuted),
          ),
          const SizedBox(height: DaybookSpacing.sm),
          ValueListenableBuilder<SyncStatus>(
            valueListenable: engine.status,
            builder: (context, status, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_lastSyncedLabel(status.lastSyncedAt), style: text.body),
                  const SizedBox(height: DaybookSpacing.xs),
                  Text(
                    'Pending: ${status.pendingCount} · Failed: '
                    '${status.failedCount}',
                    style: text.taskMeta,
                  ),
                  if (!status.isOnline) ...[
                    const SizedBox(height: DaybookSpacing.xs),
                    Text(
                      'Offline',
                      style: text.taskMeta.copyWith(color: colors.warning),
                    ),
                  ],
                  const SizedBox(height: DaybookSpacing.md),
                  SizedBox(
                    width: 160,
                    child: DaybookButton(
                      label: status.isSyncing ? 'Syncing…' : 'Sync now',
                      variant: DaybookButtonVariant.secondary,
                      onPressed: status.isSyncing
                          ? null
                          : () {
                              engine.schedulePush(immediate: true);
                              engine.pull();
                            },
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  String _lastSyncedLabel(DateTime? lastSyncedAt) {
    if (lastSyncedAt == null) return 'Last synced: never';
    return 'Last synced: ${DateFormat('MMM d, HH:mm').format(lastSyncedAt.toLocal())}';
  }
}
