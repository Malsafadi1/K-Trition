import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/nutrition_repository.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({required this.repository, super.key});

  final NutritionRepository repository;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const _orange = Color(0xFFF28C28);
  static const _ink = Color(0xFF171717);
  static const _muted = Color(0xFF707070);
  static const _page = Colors.white;
  static const _border = Color(0xFFE5E5E5);
  static const _softAccent = Color(0xFFFFF1E3);
  static const _panel = Color(0xFFF5F5F5);
  static const _track = Color(0xFFECECEC);
  static const _mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];
  static const _waterChoices = [8, 16, 24, 32];

  final _foodNameController = TextEditingController();
  final _servingController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _waterController = TextEditingController();
  final List<_FoodEntry> _foodEntries = [];
  final List<_WaterEntry> _waterEntries = [];
  final List<_FoodEntry> _historyFoodEntries = [];
  final List<_WaterEntry> _historyWaterEntries = [];
  final List<Food> _foodSuggestions = [];

  int _goalCalories = 2000;
  int _goalWater = 64;
  double _totalCalories = 0;
  double _waterAmount = 0;
  Food? _selectedFood;
  Timer? _foodSearchTimer;
  int _refreshRequest = 0;
  int _foodSearchRequest = 0;
  String? _loadError;
  String? _foodSearchError;
  bool _isSearchingFoods = false;
  bool _isSaving = false;
  DateTime _selectedDate = DateTime.now();
  String _selectedMeal = _mealTypes.first;
  int _selectedWaterChoice = 8;
  int _selectedTab = 0;
  bool _showAllFood = false;
  _HistoryRange _historyRange = _HistoryRange.day;

  List<_FoodEntry> get _selectedFoodEntries => _historyFoodEntries;

  List<_WaterEntry> get _selectedWaterEntries => _historyWaterEntries;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  void dispose() {
    _foodNameController.dispose();
    _servingController.dispose();
    _caloriesController.dispose();
    _waterController.dispose();
    _foodSearchTimer?.cancel();
    super.dispose();
  }

  Future<List<_FoodEntry>> _foodsForDay(DateTime day) async {
    final entries = <_FoodEntry>[];
    for (final meal in await widget.repository.mealsForDay(day)) {
      final loggedAt = DateTime.fromMillisecondsSinceEpoch(meal.loggedAt);
      for (final item in await widget.repository.getMealItems(meal.id)) {
        entries.add(
          _FoodEntry(
            id: meal.id,
            meal: meal.mealType,
            name: item.foodName,
            servingGrams: item.grams,
            calories: item.grams * item.kcalPerG,
            loggedAt: loggedAt,
          ),
        );
      }
    }
    return entries;
  }

  Future<List<_WaterEntry>> _waterForDay(DateTime day) async =>
      (await widget.repository.waterForDay(day))
          .map(
            (entry) => _WaterEntry(
              id: entry.id,
              amountOz: entry.ounces,
              loggedAt: DateTime.fromMillisecondsSinceEpoch(entry.loggedAt),
            ),
          )
          .toList();

  Future<void> _refreshData() async {
    final request = ++_refreshRequest;
    try {
      final progress = await widget.repository.progressForDay(_selectedDate);
      final foods = await _foodsForDay(_selectedDate);
      final waters = await _waterForDay(_selectedDate);
      final rangeStart = _historyRangeStart;
      final rangeEnd = _historyRangeEnd;
      final historyFoods = <_FoodEntry>[];
      final historyWaters = <_WaterEntry>[];
      for (var day = rangeStart; day.isBefore(rangeEnd); day = nextDay(day)) {
        historyFoods.addAll(await _foodsForDay(day));
        historyWaters.addAll(await _waterForDay(day));
      }
      if (!mounted || request != _refreshRequest) return;
      setState(() {
        _foodEntries
          ..clear()
          ..addAll(foods);
        _waterEntries
          ..clear()
          ..addAll(waters);
        _historyFoodEntries
          ..clear()
          ..addAll(historyFoods);
        _historyWaterEntries
          ..clear()
          ..addAll(historyWaters);
        _totalCalories = progress.nutrition.calories;
        _waterAmount = progress.waterOunces;
        _goalCalories = (progress.calorieGoal ?? 2000).round();
        _goalWater = (progress.waterGoalOunces ?? 64).round();
        _loadError = null;
      });
    } catch (error) {
      if (!mounted || request != _refreshRequest) return;
      setState(() => _loadError = 'Could not load dashboard data: $error');
    }
  }

  DateTime get _historyRangeStart => switch (_historyRange) {
    _HistoryRange.day => DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    ),
    _HistoryRange.week => _weekStart(_selectedDate),
    _HistoryRange.month => DateTime(_selectedDate.year, _selectedDate.month),
  };

  DateTime get _historyRangeEnd => switch (_historyRange) {
    _HistoryRange.day => _historyRangeStart.add(const Duration(days: 1)),
    _HistoryRange.week => _historyRangeStart.add(const Duration(days: 7)),
    _HistoryRange.month => DateTime(
      _selectedDate.year,
      _selectedDate.month + 1,
    ),
  };

  Widget _buildLoadError() => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_loadError!, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: _refreshData, child: const Text('Retry')),
        ],
      ),
    ),
  );

  void _onFoodSearchChanged(String query) {
    _foodSearchTimer?.cancel();
    final request = ++_foodSearchRequest;
    if (_selectedFood != null && query.trim() != _selectedFood!.name) {
      _selectedFood = null;
      _caloriesController.clear();
    }
    final trimmed = query.trim();
    if (trimmed.length < 2) {
      setState(() {
        _foodSuggestions.clear();
        _isSearchingFoods = false;
        _foodSearchError = null;
      });
      return;
    }
    setState(() {
      _foodSuggestions.clear();
      _isSearchingFoods = true;
      _foodSearchError = null;
    });
    _foodSearchTimer = Timer(const Duration(milliseconds: 250), () async {
      try {
        final foods = await widget.repository.searchFoods(
          query: trimmed,
          limit: 6,
        );
        if (!mounted || request != _foodSearchRequest) return;
        setState(() {
          _foodSuggestions
            ..clear()
            ..addAll(foods);
          _isSearchingFoods = false;
        });
      } catch (error) {
        if (!mounted || request != _foodSearchRequest) return;
        setState(() {
          _isSearchingFoods = false;
          _foodSearchError = 'Food search failed: $error';
        });
      }
    });
  }

  void _selectFood(Food food) {
    setState(() {
      _selectedFood = food;
      _foodNameController.text = food.name;
      _foodSuggestions.clear();
      _foodSearchError = null;
      _isSearchingFoods = false;
      _servingController.text = '100';
      _updateCalculatedCalories();
    });
  }

  void _updateCalculatedCalories() {
    final food = _selectedFood;
    final grams = double.tryParse(_servingController.text.trim());
    if (food == null || grams == null || grams <= 0 || !grams.isFinite) {
      _caloriesController.clear();
      return;
    }
    _caloriesController.text = widget.repository
        .calculate(food, grams)
        .calories
        .round()
        .toString();
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
                child: _loadError != null
                    ? _buildLoadError()
                    : _selectedTab == 0
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
                    color: _orange,
                  ),
                  const Spacer(),
                  const Text(
                    'K-Trition',
                    style: TextStyle(
                      color: _orange,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Settings',
                    onPressed: () => _showMessage('Settings are coming soon.'),
                    icon: const Icon(Icons.settings_outlined),
                    color: _orange,
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
                color: _orange,
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
              color: _orange,
              icon: Icons.restaurant,
              label: 'Calories',
              value: _formatNumber(_totalCalories),
              unit: 'Cal',
              goal: _goalCalories,
              progress: _totalCalories / _goalCalories,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _ProgressCard(
              color: _orange,
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
      const SizedBox(height: 10),
      OutlinedButton.icon(
        onPressed: _editGoals,
        icon: const Icon(Icons.track_changes_outlined, size: 17),
        label: const Text('Edit Goals'),
        style: OutlinedButton.styleFrom(
          foregroundColor: _ink,
          side: const BorderSide(color: _orange),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
          visualDensity: VisualDensity.compact,
        ),
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
              foregroundColor: _orange,
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

  Future<void> _editGoals() async {
    final formKey = GlobalKey<FormState>();
    var caloriesGoal = _goalCalories;
    var waterGoal = _goalWater;

    String? validateGoal(String? value, String label) {
      final goal = int.tryParse(value?.trim() ?? '');
      if (goal == null || goal <= 0) {
        return '$label must be a whole number greater than zero.';
      }
      return null;
    }

    final goals = await showDialog<(int, int)>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit daily goals'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: _goalCalories.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Calories (Cal)'),
                validator: (value) => validateGoal(value, 'Calorie goal'),
                onSaved: (value) => caloriesGoal = int.parse(value!.trim()),
              ),
              TextFormField(
                initialValue: _goalWater.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Water (Oz)'),
                validator: (value) => validateGoal(value, 'Water goal'),
                onSaved: (value) => waterGoal = int.parse(value!.trim()),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                Navigator.of(dialogContext).pop((caloriesGoal, waterGoal));
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (goals == null || !mounted) return;
    try {
      await widget.repository.setGoals(
        calories: goals.$1.toDouble(),
        waterOunces: goals.$2.toDouble(),
        effectiveDate: _selectedDate,
      );
      await _refreshData();
    } catch (error) {
      if (mounted) _showMessage('Could not save goals: $error');
    }
  }

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
          hint: 'Type a food name',
          textCapitalization: TextCapitalization.words,
          onChanged: _onFoodSearchChanged,
        ),
        if (_isSearchingFoods ||
            _foodSearchError != null ||
            _foodSuggestions.isNotEmpty ||
            (_foodNameController.text.trim().length >= 2 &&
                _selectedFood == null))
          _buildFoodSuggestions(),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: _inputField(
                controller: _servingController,
                hint: 'Serving size (g)',
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(_updateCalculatedCalories),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _inputField(
                controller: _caloriesController,
                hint: 'Calories (auto)',
                keyboardType: TextInputType.number,
                readOnly: true,
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
                    color: selected ? _orange : _ink,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  backgroundColor: Colors.white,
                  selectedColor: _softAccent,
                  side: BorderSide(color: selected ? _orange : _border),
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
            onPressed: _isSaving ? null : _addFood,
            style: FilledButton.styleFrom(
              backgroundColor: _orange,
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

  Widget _buildFoodSuggestions() {
    final message =
        _foodSearchError ??
        (_isSearchingFoods
            ? 'Searching foods...'
            : _foodSuggestions.isEmpty
            ? 'No matching foods found.'
            : null);
    if (message != null) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 6, 5, 2),
          child: Text(
            message,
            style: const TextStyle(color: _muted, fontSize: 10),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: _border),
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            for (var index = 0; index < _foodSuggestions.length; index++) ...[
              ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                title: Text(
                  _foodSuggestions[index].name,
                  style: const TextStyle(fontSize: 11, color: _ink),
                ),
                subtitle: Text(
                  '${_foodSuggestions[index].category} · '
                  '${(_foodSuggestions[index].kcalPerG * 100).round()} Cal / 100 g',
                  style: const TextStyle(fontSize: 9, color: _muted),
                ),
                onTap: () => _selectFood(_foodSuggestions[index]),
              ),
              if (index < _foodSuggestions.length - 1)
                const Divider(height: 1, indent: 8, endIndent: 8),
            ],
          ],
        ),
      ),
    );
  }

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
                    foregroundColor: selected ? _orange : _ink,
                    backgroundColor: selected ? _softAccent : Colors.white,
                    side: BorderSide(color: selected ? _orange : _border),
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
              backgroundColor: _orange,
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
    bool readOnly = false,
  }) => TextField(
    controller: controller,
    keyboardType: keyboardType,
    textCapitalization: textCapitalization,
    onChanged: onChanged,
    readOnly: readOnly,
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
        borderSide: const BorderSide(color: _border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: _border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: _orange),
      ),
    ),
  );

  Widget _buildFoodList({int? limit}) {
    final entries = limit == null
        ? _foodEntries
        : _foodEntries.take(limit).toList();
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
        border: Border.all(color: _border),
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
                '${entry.name} - ${_formatGrams(entry.servingGrams)} g',
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
          '${_formatNumber(entry.calories)} Cal',
          style: const TextStyle(color: _ink, fontSize: 10),
        ),
        PopupMenuButton<String>(
          tooltip: 'Food entry options',
          icon: const Icon(Icons.more_horiz, size: 18, color: _muted),
          padding: EdgeInsets.zero,
          onSelected: (action) {
            if (action == 'delete') {
              _deleteFood(entry);
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
      border: Border.all(color: _border),
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
            onTap: () {
              setState(() => _selectedDate = date);
              _refreshData();
            },
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
                    backgroundColor: selected ? _orange : Colors.transparent,
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
                  onTap: () {
                    setState(() => _selectedDate = date);
                    _refreshData();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: CircleAvatar(
                      radius: 13,
                      backgroundColor: selected ? _orange : Colors.transparent,
                      child: Text(
                        '${date.day}',
                        style: TextStyle(
                          color: selected
                              ? Colors.white
                              : inMonth
                              ? _ink
                              : _muted,
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
      border: Border.all(color: _border),
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
        const Icon(Icons.water_drop_outlined, color: _orange, size: 18),
        const SizedBox(width: 9),
        Text(
          '${_formatAmount(entry.amountOz)} Oz',
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
              _deleteWater(entry);
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
            _refreshData();
          },
          style: ButtonStyle(
            textStyle: const WidgetStatePropertyAll(
              TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
            foregroundColor: WidgetStateProperty.resolveWith(
              (states) =>
                  states.contains(WidgetState.selected) ? _orange : _ink,
            ),
            backgroundColor: WidgetStateProperty.resolveWith(
              (states) =>
                  states.contains(WidgetState.selected) ? Colors.white : _panel,
            ),
            side: const WidgetStatePropertyAll(BorderSide(color: _border)),
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
          summary: '${_formatNumber(_sumCalories(foods))} Cal',
          summaryColor: _orange,
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
          summaryColor: _orange,
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
    selectedItemColor: _orange,
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
      _refreshData();
    }
  }

  void _changeDate(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
    });
    _refreshData();
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

  static double _sumCalories(List<_FoodEntry> entries) =>
      entries.fold(0.0, (total, entry) => total + entry.calories);

  static double _sumWater(List<_WaterEntry> entries) =>
      entries.fold(0.0, (total, entry) => total + entry.amountOz);

  static String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  static String _formatGrams(double grams) =>
      grams == grams.roundToDouble() ? grams.toInt().toString() : '$grams';

  static String _formatAmount(double amount) =>
      amount == amount.roundToDouble() ? amount.round().toString() : '$amount';

  Future<void> _addFood() async {
    final name = _foodNameController.text.trim();
    final food = _selectedFood;
    final servingText = _servingController.text.trim();
    final servingGrams = servingText.isEmpty
        ? null
        : double.tryParse(servingText);
    if (food == null || name != food.name) {
      _showMessage('Choose a food from the database suggestions.');
      return;
    }
    if (servingGrams == null || !servingGrams.isFinite || servingGrams <= 0) {
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
    setState(() => _isSaving = true);
    try {
      await widget.repository.saveMeal(
        name: name,
        mealType: _selectedMeal,
        loggedAt: loggedAt,
        portions: [MealPortion(foodId: food.fdcId, grams: servingGrams)],
      );
      if (!mounted) return;
      setState(() {
        _foodNameController.clear();
        _servingController.clear();
        _caloriesController.clear();
        _selectedFood = null;
        _foodSuggestions.clear();
        _showAllFood = false;
      });
      FocusScope.of(context).unfocus();
      await _refreshData();
    } catch (error) {
      if (mounted) _showMessage('Could not save food: $error');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _addWater() async {
    final amountText = _waterController.text.trim();
    final amount = amountText.isEmpty
        ? _selectedWaterChoice.toDouble()
        : double.tryParse(amountText);
    if (amount == null || !amount.isFinite || amount <= 0) {
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
    try {
      await widget.repository.saveWater(ounces: amount, loggedAt: loggedAt);
      if (!mounted) return;
      setState(() {
        _waterController.clear();
        _selectedWaterChoice = 8;
      });
      FocusScope.of(context).unfocus();
      await _refreshData();
    } catch (error) {
      if (mounted) _showMessage('Could not save water: $error');
    }
  }

  Future<void> _deleteFood(_FoodEntry entry) async {
    try {
      await widget.repository.deleteMeal(entry.id);
      await _refreshData();
    } catch (error) {
      if (mounted) _showMessage('Could not delete food: $error');
    }
  }

  Future<void> _deleteWater(_WaterEntry entry) async {
    try {
      await widget.repository.deleteWater(entry.id);
      await _refreshData();
    } catch (error) {
      if (mounted) _showMessage('Could not delete water: $error');
    }
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

  static String _formatNumber(num value) {
    final digits = value.round().toString();
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
      border: Border.all(color: _DashboardScreenState._border),
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
                      color: _DashboardScreenState._muted,
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
                          color: _DashboardScreenState._ink,
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
            style: const TextStyle(
              color: _DashboardScreenState._muted,
              fontSize: 9,
            ),
          ),
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress.clamp(0, 1),
            minHeight: 5,
            backgroundColor: _DashboardScreenState._track,
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
      color: _DashboardScreenState._panel,
      borderRadius: BorderRadius.circular(12),
    ),
    child: child,
  );
}

class _FoodEntry {
  const _FoodEntry({
    required this.id,
    required this.meal,
    required this.name,
    required this.calories,
    required this.loggedAt,
    required this.servingGrams,
  });

  final int id;
  final String meal;
  final String name;
  final double calories;
  final double servingGrams;
  final DateTime loggedAt;
}

class _WaterEntry {
  const _WaterEntry({
    required this.id,
    required this.amountOz,
    required this.loggedAt,
  });

  final int id;
  final double amountOz;
  final DateTime loggedAt;
}

enum _HistoryRange { day, week, month }
