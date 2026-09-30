import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/theme.dart';
import 'date_picker_sheet.dart';
import 'day_debug_seed.dart';
import 'day_page.dart';
import 'day_page_index.dart';
import 'day_providers.dart';

/// Full-screen single-day view (SPEC §7.2): swipe left/right between days
/// via a `PageView`, "Today" pill, calendar date-picker.
class DayScreen extends ConsumerStatefulWidget {
  const DayScreen({super.key});

  @override
  ConsumerState<DayScreen> createState() => _DayScreenState();
}

class _DayScreenState extends ConsumerState<DayScreen> {
  late final int _todayIndex = controllerIndexForDate(DateTime.now());
  late final PageController _controller = PageController(
    initialPage: _todayIndex,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentDayPageIndexProvider.notifier).set(_todayIndex);
      ref.read(debugSeedProvider.future);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToToday() {
    _controller.animateToPage(
      _todayIndex,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  Future<void> _openDatePicker() async {
    final currentIndex = ref.read(currentDayPageIndexProvider);
    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DaybookRadii.sheet),
        ),
      ),
      builder: (_) =>
          DatePickerSheet(initialDate: dateForControllerIndex(currentIndex)),
    );
    if (picked != null) {
      _controller.animateToPage(
        controllerIndexForDate(picked),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(currentDayPageIndexProvider);
    final isToday = currentIndex == _todayIndex;

    return Scaffold(
      appBar: AppBar(
        actions: [
          if (!isToday)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DaybookSpacing.xs,
              ),
              child: Center(
                child: TextButton(
                  onPressed: _goToToday,
                  child: const Text('Today'),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined),
            tooltip: 'Pick a date',
            onPressed: _openDatePicker,
          ),
        ],
      ),
      body: PageView.builder(
        controller: _controller,
        itemCount: dayPageCount,
        onPageChanged: (index) =>
            ref.read(currentDayPageIndexProvider.notifier).set(index),
        itemBuilder: (context, index) {
          return DayPage(date: dateForControllerIndex(index));
        },
      ),
    );
  }
}
