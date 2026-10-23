import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const _green = Color(0xFF39794A);
  static const _blue = Color(0xFF4D9BCB);
  static const _ink = Color(0xFF24352A);
  static const _muted = Color(0xFF7B877F);
  static const _page = Color(0xFFFCFAF6);
  static const _goalCalories = 2000;
  static const _goalWater = 64;
  static const _mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];
  static const _waterChoices = [8, 16, 24, 32];

  final _foodNameController = TextEditingController();
  final _servingController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _waterController = TextEditingController();
  final List<_FoodEntry> _foodEntries = [];
  final List<_WaterEntry> _waterEntries = [];

  DateTime _selectedDate = DateTime.now();
  String _selectedMeal = _mealTypes.first;
  int _selectedWaterChoice = 8;
  int _selectedTab = 0;
  bool _showAllFood = false;
  _HistoryRange _historyRange = _HistoryRange.day;

  List<_FoodEntry> get _dailyFoodEntries =>
      _foodEntries
          .where(
            (entry) =>
                entry.loggedAt.year == _selectedDate.year &&
                entry.loggedAt.month == _selectedDate.month &&
                entry.loggedAt.day == _selectedDate.day,
          )
          .toList()
        ..sort((a, b) => b.loggedAt.compareTo(a.loggedAt));

  List<_WaterEntry> get _dailyWaterEntries =>
      _waterEntries
          .where(
            (entry) =>
                entry.loggedAt.year == _selectedDate.year &&
                entry.loggedAt.month == _selectedDate.month &&
                entry.loggedAt.day == _selectedDate.day,
          )
          .toList()
        ..sort((a, b) => b.loggedAt.compareTo(a.loggedAt));

  List<_FoodEntry> get _selectedFoodEntries =>
      _foodEntries.where((entry) => _isInSelectedRange(entry.loggedAt)).toList()
        ..sort((a, b) => b.loggedAt.compareTo(a.loggedAt));

  List<_WaterEntry> get _selectedWaterEntries =>
      _waterEntries
          .where((entry) => _isInSelectedRange(entry.loggedAt))
          .toList()
        ..sort((a, b) => b.loggedAt.compareTo(a.loggedAt));

  int get _totalCalories =>
      _dailyFoodEntries.fold(0, (total, entry) => total + entry.calories);

  int get _waterAmount =>
      _dailyWaterEntries.fold(0, (total, entry) => total + entry.amountOz);

  @override
  void dispose() {
    _foodNameController.dispose();
    _servingController.dispose();
    _caloriesController.dispose();
    _waterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _page,
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _selectedTab == 0
                    ? _buildHomeContent()
                    : _buildHistoryContent(),
              ),
            ],
          ),
        ),
      ),
    ),
    bottomNavigationBar: _buildBottomNavigation(),
  );

  Widget _buildHeader() => Padding(
    padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
    child: _selectedTab == 0
        ? Column(
            children: [
              Row(
                children: [
                  IconButton(
                    tooltip: 'Choose date',
                    onPressed: _chooseDate,
                    icon: const Icon(Icons.calendar_month_outlined),
                    color: _green,
                  ),
                  const Spacer(),
                  const Text(
                    'K-Trition',
                    style: TextStyle(
                      color: _green,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Settings',
                    onPressed: () => _showMessage('Settings are coming soon.'),
                    icon: const Icon(Icons.settings_outlined),
                    color: _green,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    tooltip: 'Previous day',
                    visualDensity: VisualDensity.compact,
                    onPressed: () => _changeDate(-1),
                    icon: const Icon(Icons.chevron_left, size: 20),
                    color: _muted,
                  ),
                  Text(
                    '${_isToday ? 'Today, ' : ''}${_formatDate(_selectedDate)}',
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Next day',
                    visualDensity: VisualDensity.compact,
                    onPressed: () => _changeDate(1),
                    icon: const Icon(Icons.chevron_right, size: 20),
                    color: _muted,
                  ),
                ],
              ),
            ],
          )
        : const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'History',
              style: TextStyle(
                color: _green,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
  );

  bool get _isToday {
    final now = DateTime.now();
    return _selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day;
  }

  Widget _buildHomeContent() => ListView(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
    children: [
      Row(
        children: [
          Expanded(
            child: _ProgressCard(
              color: _green,
              icon: Icons.restaurant,
              label: 'Calories',
              value: _formatNumber(_totalCalories),
              unit: 'kcal',
              goal: _goalCalories,
              progress: _totalCalories / _goalCalories,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _ProgressCard(
              color: _blue,
              icon: Icons.water_drop,
              label: 'Water',
              value: _formatNumber(_waterAmount),
              unit: 'Oz',
              goal: _goalWater,
              progress: _waterAmount / _goalWater,
            ),
          ),
        ],
      ),
      const SizedBox(height: 14),
      _sectionLabel('Log Food'),
      const SizedBox(height: 7),
      _buildFoodForm(),
      const SizedBox(height: 14),
      _sectionLabel('Log Water'),
      const SizedBox(height: 7),
      _buildWaterForm(),
      const SizedBox(height: 16),
      Row(
        children: [
          _sectionLabel("Today's Food"),
          const Spacer(),
          TextButton(
            onPressed: () => setState(() => _showAllFood = !_showAllFood),
            style: TextButton.styleFrom(
              foregroundColor: _blue,
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 6),
            ),
            child: Text(_showAllFood ? 'Show less' : 'View All'),
          ),
        ],
      ),
      const SizedBox(height: 2),
      _buildFoodList(limit: _showAllFood ? null : 2),
    ],
  );

  Widget _sectionLabel(String label) => Text(
    label,
    style: const TextStyle(
      color: _ink,
      fontSize: 14,
      fontWeight: FontWeight.w700,
    ),
  );

  Widget _buildFoodForm() => _SectionPanel(
    child: Column(
      children: [
        _inputField(
          controller: _foodNameController,
          hint: 'Food name',
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: _inputField(
                controller: _servingController,
                hint: 'Serving size (g)',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _inputField(
                controller: _caloriesController,
                hint: 'Calories (optional)',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _mealTypes.map((meal) {
              final selected = _selectedMeal == meal;
              return Padding(
                padding: const EdgeInsets.only(right: 5),
                child: ChoiceChip(
                  label: Text(meal),
                  selected: selected,
                  showCheckmark: false,
                  onSelected: (_) => setState(() => _selectedMeal = meal),
                  labelStyle: TextStyle(
                    color: selected ? _green : _ink,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  backgroundColor: Colors.white,
                  selectedColor: const Color(0xFFEAF2E9),
                  side: BorderSide(
                    color: selected ? _green : const Color(0xFFE5E8E3),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 36,
          child: FilledButton(
            onPressed: _addFood,
            style: FilledButton.styleFrom(
              backgroundColor: _green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            child: const Text('Add Food', style: TextStyle(fontSize: 12)),
          ),
        ),
      ],
    ),
  );

  Widget _buildWaterForm() => _SectionPanel(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 115,
          child: _inputField(
            controller: _waterController,
            hint: 'Amount (Oz)',
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() => _selectedWaterChoice = 0),
          ),
        ),
        const SizedBox(height: 7),
        Row(
          children: _waterChoices.map((amount) {
            final selected = _selectedWaterChoice == amount;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 5),
                child: OutlinedButton(
                  onPressed: () => setState(() {
                    _selectedWaterChoice = amount;
                    _waterController.text = amount.toString();
                  }),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: selected ? _blue : _ink,
                    backgroundColor: selected
                        ? const Color(0xFFEAF5FA)
                        : Colors.white,
                    side: BorderSide(
                      color: selected ? _blue : const Color(0xFFE5E8E3),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    minimumSize: const Size(0, 31),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '$amount Oz',
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 36,
          child: FilledButton.icon(
            onPressed: _addWater,
            icon: const Icon(Icons.water_drop, size: 15),
            label: const Text('Add Water', style: TextStyle(fontSize: 12)),
            style: FilledButton.styleFrom(
              backgroundColor: _blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    ValueChanged<String>? onChanged,
  }) => TextField(
    controller: controller,
    keyboardType: keyboardType,
    textCapitalization: textCapitalization,
    onChanged: onChanged,
    style: const TextStyle(color: _ink, fontSize: 11),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _muted, fontSize: 10),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: Color(0xFFE8EAE6)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: Color(0xFFE8EAE6)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: _green),
      ),
    ),
  );

  Widget _buildFoodList({int? limit}) {
    final selectedEntries = _dailyFoodEntries;
    final entries = limit == null
        ? selectedEntries
        : selectedEntries.take(limit).toList();
    if (entries.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 14),
        child: Text(
          'No food logged yet. Add your first meal above.',
          style: TextStyle(color: _muted, fontSize: 12),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFECEEEA)),
      ),
      child: Column(
        children: [
          for (var index = 0; index < entries.length; index++) ...[
            _foodEntryTile(entries[index]),
            if (index < entries.length - 1)
              const Divider(height: 1, indent: 12, endIndent: 12),
          ],
        ],
      ),
    );
  }

  Widget _foodEntryTile(_FoodEntry entry, {bool showTime = false}) => Padding(
    padding: const EdgeInsets.fromLTRB(11, 8, 5, 8),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.meal,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                entry.servingGrams == null
                    ? entry.name
                    : '${entry.name} - ${_formatGrams(entry.servingGrams!)} g',
                style: const TextStyle(color: _ink, fontSize: 10),
              ),
              if (showTime)
                Text(
                  _formatTime(entry.loggedAt),
                  style: const TextStyle(color: _muted, fontSize: 9),
                ),
            ],
          ),
        ),
        Text(
          '${_formatNumber(entry.calories)} kcal',
          style: const TextStyle(color: _ink, fontSize: 10),
        ),
        PopupMenuButton<String>(
          tooltip: 'Food entry options',
          icon: const Icon(Icons.more_horiz, size: 18, color: _muted),
          padding: EdgeInsets.zero,
          onSelected: (action) {
            if (action == 'delete') {
              setState(() => _foodEntries.remove(entry));
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ],
    ),
  );

  Widget _buildHistoryCalendar() => Container(
    padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xFFECEEEA)),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      children: [
        Row(
          children: [
            IconButton(
              tooltip: 'Previous ${_historyRange.name}',
              visualDensity: VisualDensity.compact,
              onPressed: () => _navigateHistory(-1),
              icon: const Icon(Icons.chevron_left, size: 20),
              color: _muted,
            ),
            Expanded(
              child: Center(
                child: Text(
                  _calendarTitle,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            IconButton(
              tooltip: 'Next ${_historyRange.name}',
              visualDensity: VisualDensity.compact,
              onPressed: () => _navigateHistory(1),
              icon: const Icon(Icons.chevron_right, size: 20),
              color: _muted,
            ),
          ],
        ),
        if (_historyRange == _HistoryRange.month)
          _buildMonthCalendar()
        else
          _buildWeekCalendar(),
      ],
    ),
  );

  Widget _buildWeekCalendar() {
    final firstDay = _weekStart(_selectedDate);
    const weekdays = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
    return Row(
      children: List.generate(7, (index) {
        final date = firstDay.add(Duration(days: index));
        final selected = _sameDate(date, _selectedDate);
        return Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => setState(() => _selectedDate = date),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                children: [
                  Text(
                    weekdays[index],
                    style: const TextStyle(color: _muted, fontSize: 8),
                  ),
                  const SizedBox(height: 4),
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: selected ? _green : Colors.transparent,
                    child: Text(
                      '${date.day}',
                      style: TextStyle(
                        color: selected ? Colors.white : _ink,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildMonthCalendar() {
    const weekdays = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
    final monthStart = DateTime(_selectedDate.year, _selectedDate.month);
    final gridStart = monthStart.subtract(
      Duration(days: monthStart.weekday % 7),
    );
    return Column(
      children: [
        Row(
          children: weekdays
              .map(
                (day) => Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: const TextStyle(color: _muted, fontSize: 8),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 4),
        for (var week = 0; week < 6; week++)
          Row(
            children: List.generate(7, (weekday) {
              final date = gridStart.add(Duration(days: week * 7 + weekday));
              final inMonth = date.month == _selectedDate.month;
              final selected = _sameDate(date, _selectedDate);
              return Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => setState(() => _selectedDate = date),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: CircleAvatar(
                      radius: 13,
                      backgroundColor: selected ? _green : Colors.transparent,
                      child: Text(
                        '${date.day}',
                        style: TextStyle(
                          color: selected
                              ? Colors.white
                              : inMonth
                              ? _ink
                              : const Color(0xFFB9C0BB),
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
      ],
    );
  }

  Widget _buildHistorySection({
    required String title,
    required String summary,
    required Color summaryColor,
    required Widget child,
  }) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xFFECEEEA)),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(11, 10, 11, 5),
          child: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                summary,
                style: TextStyle(
                  color: summaryColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        child,
      ],
    ),
  );

  Widget _emptyHistoryMessage(String message) => Padding(
    padding: const EdgeInsets.fromLTRB(11, 8, 11, 12),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(message, style: const TextStyle(color: _muted, fontSize: 11)),
    ),
  );

  Widget _waterEntryTile(_WaterEntry entry) => Padding(
    padding: const EdgeInsets.fromLTRB(11, 5, 5, 5),
    child: Row(
      children: [
        const Icon(Icons.water_drop_outlined, color: _blue, size: 18),
        const SizedBox(width: 9),
        Text(
          '${entry.amountOz} Oz',
          style: const TextStyle(color: _ink, fontSize: 10),
        ),
        const Spacer(),
        Text(
          _formatTime(entry.loggedAt),
          style: const TextStyle(color: _ink, fontSize: 10),
        ),
        PopupMenuButton<String>(
          tooltip: 'Water entry options',
          icon: const Icon(Icons.more_vert, size: 17, color: _muted),
          padding: EdgeInsets.zero,
          onSelected: (action) {
            if (action == 'delete') {
              setState(() => _waterEntries.remove(entry));
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ],
    ),
  );

  String get _historyTitle => switch (_historyRange) {
    _HistoryRange.day => _formatLongDate(_selectedDate),
    _HistoryRange.week =>
      '${_formatShortDate(_weekStart(_selectedDate))} - '
          '${_formatShortDate(_weekStart(_selectedDate).add(const Duration(days: 6)))}',
    _HistoryRange.month => _formatMonthYear(_selectedDate),
  };

  String get _calendarTitle => switch (_historyRange) {
    _ => _formatMonthYear(_selectedDate),
  };

  bool _isInSelectedRange(DateTime date) {
    final start = switch (_historyRange) {
      _HistoryRange.day => DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
      ),
      _HistoryRange.week => _weekStart(_selectedDate),
      _HistoryRange.month => DateTime(_selectedDate.year, _selectedDate.month),
    };
    final end = switch (_historyRange) {
      _HistoryRange.day => start.add(const Duration(days: 1)),
      _HistoryRange.week => start.add(const Duration(days: 7)),
      _HistoryRange.month => DateTime(start.year, start.month + 1),
    };
    return !date.isBefore(start) && date.isBefore(end);
  }

  void _navigateHistory(int direction) {
    setState(() {
      switch (_historyRange) {
        case _HistoryRange.day:
          _selectedDate = _selectedDate.add(Duration(days: direction));
          break;
        case _HistoryRange.week:
          _selectedDate = _selectedDate.add(Duration(days: 7 * direction));
          break;
        case _HistoryRange.month:
          final targetMonth = DateTime(
            _selectedDate.year,
            _selectedDate.month + direction,
          );
          final lastDay = DateTime(
            targetMonth.year,
            targetMonth.month + 1,
            0,
          ).day;
          _selectedDate = DateTime(
            targetMonth.year,
            targetMonth.month,
            _selectedDate.day.clamp(1, lastDay),
          );
          break;
      }
    });
  }

  Widget _buildHistoryContent() {
    final foods = _selectedFoodEntries;
    final waters = _selectedWaterEntries;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
      children: [
        SegmentedButton<_HistoryRange>(
          segments: const [
            ButtonSegment(value: _HistoryRange.day, label: Text('Day')),
            ButtonSegment(value: _HistoryRange.week, label: Text('Week')),
            ButtonSegment(value: _HistoryRange.month, label: Text('Month')),
          ],
          selected: {_historyRange},
          showSelectedIcon: false,
          onSelectionChanged: (selection) {
            setState(() => _historyRange = selection.first);
          },
          style: ButtonStyle(
            textStyle: const WidgetStatePropertyAll(
              TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
            foregroundColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected) ? _green : _ink,
            ),
            backgroundColor: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.selected)
                  ? Colors.white
                  : const Color(0xFFF3F2ED),
            ),
            side: const WidgetStatePropertyAll(
              BorderSide(color: Color(0xFFE6E8E3)),
            ),
          ),
        ),
        const SizedBox(height: 10),
        _buildHistoryCalendar(),
        const SizedBox(height: 14),
        Text(
          _historyTitle,
          style: const TextStyle(
            color: _ink,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        _buildHistorySection(
          title: 'Food',
          summary: '${_formatNumber(_sumCalories(foods))} kcal',
          summaryColor: _green,
          child: foods.isEmpty
              ? _emptyHistoryMessage('No food logged for this period.')
              : Column(
                  children: [
                    for (var index = 0; index < foods.length; index++) ...[
                      _foodEntryTile(foods[index], showTime: true),
                      if (index < foods.length - 1)
                        const Divider(height: 1, indent: 10, endIndent: 10),
                    ],
                  ],
                ),
        ),
        const SizedBox(height: 12),
        _buildHistorySection(
          title: 'Water',
          summary: '${_formatNumber(_sumWater(waters))} Oz',
          summaryColor: _blue,
          child: waters.isEmpty
              ? _emptyHistoryMessage('No water logged for this period.')
              : Column(
                  children: [
                    for (var index = 0; index < waters.length; index++) ...[
                      _waterEntryTile(waters[index]),
                      if (index < waters.length - 1)
                        const Divider(height: 1, indent: 10, endIndent: 10),
                    ],
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation() => BottomNavigationBar(
    currentIndex: _selectedTab,
    onTap: (index) => setState(() => _selectedTab = index),
    backgroundColor: Colors.white,
    selectedItemColor: _green,
    unselectedItemColor: _muted,
    selectedFontSize: 10,
    unselectedFontSize: 10,
    iconSize: 19,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'History'),
    ],
  );

  Future<void> _chooseDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _changeDate(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
    });
  }

  static DateTime _weekStart(DateTime date) => DateTime(
    date.year,
    date.month,
    date.day,
  ).subtract(Duration(days: date.weekday % 7));

  static bool _sameDate(DateTime first, DateTime second) =>
      first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;

  static int _sumCalories(List<_FoodEntry> entries) =>
      entries.fold(0, (total, entry) => total + entry.calories);

  static int _sumWater(List<_WaterEntry> entries) =>
      entries.fold(0, (total, entry) => total + entry.amountOz);

  static String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  static String _formatGrams(double grams) =>
      grams == grams.roundToDouble() ? grams.toInt().toString() : '$grams';

  void _addFood() {
    final name = _foodNameController.text.trim();
    final caloriesText = _caloriesController.text.trim();
    final calories = caloriesText.isEmpty ? 0 : int.tryParse(caloriesText);
    final servingText = _servingController.text.trim();
    final servingGrams = servingText.isEmpty
        ? null
        : double.tryParse(servingText);
    if (name.isEmpty) {
      _showMessage('Enter a food name to add it.');
      return;
    }
    if (calories == null || calories < 0) {
      _showMessage('Enter a valid non-negative calorie amount.');
      return;
    }
    if (servingText.isNotEmpty && (servingGrams == null || servingGrams <= 0)) {
      _showMessage('Enter a valid serving size in grams.');
      return;
    }

    final now = DateTime.now();
    final loggedAt = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      now.hour,
      now.minute,
    );
    setState(() {
      _foodEntries.insert(
        0,
        _FoodEntry(
          meal: _selectedMeal,
          name: name,
          servingGrams: servingGrams,
          calories: calories,
          loggedAt: loggedAt,
        ),
      );
      _foodNameController.clear();
      _servingController.clear();
      _caloriesController.clear();
      _showAllFood = false;
    });
    FocusScope.of(context).unfocus();
  }

  void _addWater() {
    final amountText = _waterController.text.trim();
    final amount = amountText.isEmpty
        ? _selectedWaterChoice
        : int.tryParse(amountText);
    if (amount == null || amount <= 0) {
      _showMessage('Enter a valid water amount greater than zero.');
      return;
    }

    final now = DateTime.now();
    final loggedAt = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      now.hour,
      now.minute,
    );
    setState(() {
      _waterEntries.insert(
        0,
        _WaterEntry(amountOz: amount, loggedAt: loggedAt),
      );
      _waterController.clear();
      _selectedWaterChoice = 8;
    });
    FocusScope.of(context).unfocus();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  static String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  static String _formatLongDate(DateTime date) =>
      '${_formatDate(date)}, ${date.year}';

  static String _formatShortDate(DateTime date) =>
      '${_formatDate(date)} ${date.year}';

  static String _formatMonthYear(DateTime date) =>
      '${_monthName(date.month)} ${date.year}';

  static String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  static String _formatNumber(int value) {
    final digits = value.toString();
    final result = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        result.write(',');
      }
      result.write(digits[i]);
    }
    return result.toString();
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.color,
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.goal,
    required this.progress,
  });

  final Color color;
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final int goal;
  final double progress;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xFFECEEEA)),
      borderRadius: BorderRadius.circular(13),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: color,
              child: Icon(icon, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Color(0xFF7B877F),
                      fontSize: 9,
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text.rich(
                      TextSpan(
                        text: value,
                        style: const TextStyle(
                          color: Color(0xFF24352A),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                        children: [
                          TextSpan(
                            text: ' $unit',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '/ ${_DashboardScreenState._formatNumber(goal)} $unit',
            style: const TextStyle(color: Color(0xFF7B877F), fontSize: 9),
          ),
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress.clamp(0, 1),
            minHeight: 5,
            backgroundColor: const Color(0xFFEFF1ED),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    ),
  );
}

class _SectionPanel extends StatelessWidget {
  const _SectionPanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: const Color(0xFFF4F6EF),
      borderRadius: BorderRadius.circular(12),
    ),
    child: child,
  );
}

class _FoodEntry {
  const _FoodEntry({
    required this.meal,
    required this.name,
    required this.calories,
    required this.loggedAt,
    this.servingGrams,
  });

  final String meal;
  final String name;
  final int calories;
  final double? servingGrams;
  final DateTime loggedAt;
}

class _WaterEntry {
  const _WaterEntry({required this.amountOz, required this.loggedAt});

  final int amountOz;
  final DateTime loggedAt;
}

enum _HistoryRange { day, week, month }
