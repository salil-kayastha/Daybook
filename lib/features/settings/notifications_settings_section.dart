import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme.dart';
import '../../core/widgets/daybook_button.dart';
import '../../domain/user_settings.dart';
import '../auth/auth_providers.dart';
import '../day/day_providers.dart';
import '../notifications/notification_providers.dart';

/// SPEC §8 (M6): morning/evening toggles + time pickers (synced via the
/// existing `user_settings` table from M5), the Android-only exact-alarm
/// toggle, a permission-denied banner, and debug-only test tools.
class NotificationsSettingsSection extends ConsumerStatefulWidget {
  const NotificationsSettingsSection({super.key});

  @override
  ConsumerState<NotificationsSettingsSection> createState() =>
      _NotificationsSettingsSectionState();
}

class _NotificationsSettingsSectionState
    extends ConsumerState<NotificationsSettingsSection> {
  bool _notificationsEnabled = true;
  bool _showScheduled = false;
  List<String> _scheduledSummary = const [];

  @override
  void initState() {
    super.initState();
    _refreshPermissionState();
  }

  Future<void> _refreshPermissionState() async {
    final enabled = await ref
        .read(notificationSchedulerProvider)
        .areNotificationsEnabled();
    if (mounted) setState(() => _notificationsEnabled = enabled);
  }

  Future<void> _save(
    UserSettings? current,
    UserSettings Function(UserSettings) update,
  ) async {
    final userId = ref.read(authRepositoryProvider).currentUser?.id;
    if (userId == null) return;
    final now = DateTime.now().toUtc();
    final base =
        current ??
        UserSettings(userId: userId, updatedAt: now, localChangedAt: now);
    await ref.read(userSettingsRepositoryProvider).upsert(update(base));
  }

  Future<void> _pickTime(
    UserSettings? current,
    String currentValue,
    UserSettings Function(UserSettings, String) apply,
  ) async {
    final parts = currentValue.split(':');
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      ),
    );
    if (picked == null) return;
    final formatted =
        '${picked.hour.toString().padLeft(2, '0')}:'
        '${picked.minute.toString().padLeft(2, '0')}:00';
    await _save(current, (s) => apply(s, formatted));
  }

  Future<void> _toggleScheduledList() async {
    if (!_showScheduled) {
      final pending = await ref
          .read(notificationSchedulerProvider)
          .pendingNotifications();
      _scheduledSummary = pending
          .map((p) => '#${p.id}  ${_dateLabelForId(p.id)}  ${p.title ?? ''}')
          .toList();
    }
    if (mounted) setState(() => _showScheduled = !_showScheduled);
  }

  /// The plugin's `pendingNotificationRequests()` doesn't return the
  /// actual AlarmManager trigger time (the OS/plugin API doesn't expose
  /// it) — this decodes the date from our own `yyyyMMdd*10+1/+2` id
  /// scheme instead, which is the next best thing for "is this the day I
  /// expect".
  String _dateLabelForId(int id) {
    if (id == 999999997) return '(test, inexact)';
    if (id == 999999998) return '(test, exact)';
    if (id == 999999999) return '(test, immediate)';
    final yyyymmdd = id ~/ 10;
    final kind = id % 10 == 1 ? 'morning' : 'evening';
    final y = yyyymmdd ~/ 10000;
    final m = (yyyymmdd ~/ 100) % 100;
    final d = yyyymmdd % 100;
    return '$y-${m.toString().padLeft(2, '0')}-${d.toString().padLeft(2, '0')} $kind';
  }

  @override
  Widget build(BuildContext context) {
    final text = context.daybookText;
    final colors = context.daybookColors;
    final settingsAsync = ref.watch(currentUserSettingsProvider);
    final localSettingsAsync = ref.watch(localSettingsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'NOTIFICATIONS',
          style: text.sectionTitle.copyWith(color: colors.inkMuted),
        ),
        const SizedBox(height: DaybookSpacing.sm),
        Text(
          'Reminders are delivered on your phone. Web notifications are '
          'best-effort.',
          style: text.taskMeta,
        ),
        const SizedBox(height: DaybookSpacing.md),
        if (!_notificationsEnabled) ...[
          _PermissionDeniedBanner(onOpenSettings: _openSystemSettings),
          const SizedBox(height: DaybookSpacing.md),
        ],
        settingsAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
          data: (settings) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Morning summary'),
                subtitle: Text(_timeLabel(settings?.morningTime ?? '07:30:00')),
                value: settings?.morningEnabled ?? true,
                onChanged: (v) =>
                    _save(settings, (s) => s.copyWith(morningEnabled: v)),
              ),
              OutlinedButton(
                onPressed: () => _pickTime(
                  settings,
                  settings?.morningTime ?? '07:30:00',
                  (s, v) => s.copyWith(morningTime: v),
                ),
                child: Text(
                  'Change time (${_timeLabel(settings?.morningTime ?? '07:30:00')})',
                ),
              ),
              const SizedBox(height: DaybookSpacing.md),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Evening planning'),
                subtitle: Text(_timeLabel(settings?.eveningTime ?? '21:00:00')),
                value: settings?.eveningEnabled ?? true,
                onChanged: (v) =>
                    _save(settings, (s) => s.copyWith(eveningEnabled: v)),
              ),
              OutlinedButton(
                onPressed: () => _pickTime(
                  settings,
                  settings?.eveningTime ?? '21:00:00',
                  (s, v) => s.copyWith(eveningTime: v),
                ),
                child: Text(
                  'Change time (${_timeLabel(settings?.eveningTime ?? '21:00:00')})',
                ),
              ),
            ],
          ),
        ),
        if (defaultTargetPlatform == TargetPlatform.android) ...[
          const SizedBox(height: DaybookSpacing.md),
          localSettingsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (local) => SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Exact time (uses more battery)'),
              value: local.useExactAlarms,
              onChanged: (v) async {
                await ref.read(settingsRepositoryProvider).setUseExactAlarms(v);
                if (v) {
                  await ref
                      .read(notificationSchedulerProvider)
                      .requestExactAlarmPermission();
                }
              },
            ),
          ),
        ],
        if (kDebugMode) ...[
          const SizedBox(height: DaybookSpacing.xl),
          Text(
            'DEBUG',
            style: text.sectionTitle.copyWith(color: colors.inkMuted),
          ),
          const SizedBox(height: DaybookSpacing.sm),
          Wrap(
            spacing: DaybookSpacing.sm,
            runSpacing: DaybookSpacing.sm,
            children: [
              DaybookButton(
                label: 'Send test notification now',
                variant: DaybookButtonVariant.secondary,
                onPressed: () => ref
                    .read(notificationSchedulerProvider)
                    .showTestNotificationNow(),
              ),
              DaybookButton(
                label: 'Schedule test in 1 minute',
                variant: DaybookButtonVariant.secondary,
                onPressed: () => ref
                    .read(notificationSchedulerProvider)
                    .scheduleTestNotification(
                      delay: const Duration(minutes: 1),
                      exact: false,
                    ),
              ),
              DaybookButton(
                label: 'Schedule test in 2 min (exact)',
                variant: DaybookButtonVariant.secondary,
                onPressed: () => ref
                    .read(notificationSchedulerProvider)
                    .scheduleTestNotification(
                      delay: const Duration(minutes: 2),
                      exact: true,
                    ),
              ),
              DaybookButton(
                label: _showScheduled ? 'Hide scheduled' : 'Show scheduled',
                variant: DaybookButtonVariant.secondary,
                onPressed: _toggleScheduledList,
              ),
            ],
          ),
          if (_showScheduled) ...[
            const SizedBox(height: DaybookSpacing.sm),
            if (_scheduledSummary.isEmpty)
              Text('Nothing scheduled.', style: text.taskMeta)
            else
              for (final line in _scheduledSummary)
                Text(line, style: text.taskMeta),
          ],
        ],
      ],
    );
  }

  Future<void> _openSystemSettings() async {
    await ref.read(notificationSchedulerProvider).openNotificationSettings();
  }

  String _timeLabel(String hhmmss) {
    final parts = hhmmss.split(':');
    return '${parts[0]}:${parts[1]}';
  }
}

class _PermissionDeniedBanner extends StatelessWidget {
  const _PermissionDeniedBanner({required this.onOpenSettings});

  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final colors = context.daybookColors;
    final text = context.daybookText;
    return Container(
      padding: const EdgeInsets.all(DaybookSpacing.md),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(DaybookRadii.card),
        border: Border.all(color: colors.line),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Notifications are turned off for Daybook.',
              style: text.body,
            ),
          ),
          const SizedBox(width: DaybookSpacing.sm),
          TextButton(
            onPressed: onOpenSettings,
            child: const Text('Open settings'),
          ),
        ],
      ),
    );
  }
}
