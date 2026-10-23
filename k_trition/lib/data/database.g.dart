// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class Foods extends Table with TableInfo<Foods, Food> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Foods(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _fdcIdMeta = const VerificationMeta('fdcId');
  late final GeneratedColumn<int> fdcId = GeneratedColumn<int>(
    'fdc_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _sourceNameMeta = const VerificationMeta(
    'sourceName',
  );
  late final GeneratedColumn<String> sourceName = GeneratedColumn<String>(
    'source_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _kcalPerGMeta = const VerificationMeta(
    'kcalPerG',
  );
  late final GeneratedColumn<double> kcalPerG = GeneratedColumn<double>(
    'kcal_per_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (kcal_per_g >= 0)',
  );
  static const VerificationMeta _proteinPerGMeta = const VerificationMeta(
    'proteinPerG',
  );
  late final GeneratedColumn<double> proteinPerG = GeneratedColumn<double>(
    'protein_per_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (protein_per_g >= 0)',
  );
  static const VerificationMeta _carbsPerGMeta = const VerificationMeta(
    'carbsPerG',
  );
  late final GeneratedColumn<double> carbsPerG = GeneratedColumn<double>(
    'carbs_per_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (carbs_per_g >= 0)',
  );
  static const VerificationMeta _fatPerGMeta = const VerificationMeta(
    'fatPerG',
  );
  late final GeneratedColumn<double> fatPerG = GeneratedColumn<double>(
    'fat_per_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (fat_per_g >= 0)',
  );
  static const VerificationMeta _isListedMeta = const VerificationMeta(
    'isListed',
  );
  late final GeneratedColumn<bool> isListed = GeneratedColumn<bool>(
    'is_listed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT TRUE',
    defaultValue: const CustomExpression('TRUE'),
  );
  static const VerificationMeta _isCommonMeta = const VerificationMeta(
    'isCommon',
  );
  late final GeneratedColumn<bool> isCommon = GeneratedColumn<bool>(
    'is_common',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT FALSE',
    defaultValue: const CustomExpression('FALSE'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    fdcId,
    name,
    category,
    sourceName,
    kcalPerG,
    proteinPerG,
    carbsPerG,
    fatPerG,
    isListed,
    isCommon,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'foods';
  @override
  VerificationContext validateIntegrity(
    Insertable<Food> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('fdc_id')) {
      context.handle(
        _fdcIdMeta,
        fdcId.isAcceptableOrUnknown(data['fdc_id']!, _fdcIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('source_name')) {
      context.handle(
        _sourceNameMeta,
        sourceName.isAcceptableOrUnknown(data['source_name']!, _sourceNameMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceNameMeta);
    }
    if (data.containsKey('kcal_per_g')) {
      context.handle(
        _kcalPerGMeta,
        kcalPerG.isAcceptableOrUnknown(data['kcal_per_g']!, _kcalPerGMeta),
      );
    } else if (isInserting) {
      context.missing(_kcalPerGMeta);
    }
    if (data.containsKey('protein_per_g')) {
      context.handle(
        _proteinPerGMeta,
        proteinPerG.isAcceptableOrUnknown(
          data['protein_per_g']!,
          _proteinPerGMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_proteinPerGMeta);
    }
    if (data.containsKey('carbs_per_g')) {
      context.handle(
        _carbsPerGMeta,
        carbsPerG.isAcceptableOrUnknown(data['carbs_per_g']!, _carbsPerGMeta),
      );
    } else if (isInserting) {
      context.missing(_carbsPerGMeta);
    }
    if (data.containsKey('fat_per_g')) {
      context.handle(
        _fatPerGMeta,
        fatPerG.isAcceptableOrUnknown(data['fat_per_g']!, _fatPerGMeta),
      );
    } else if (isInserting) {
      context.missing(_fatPerGMeta);
    }
    if (data.containsKey('is_listed')) {
      context.handle(
        _isListedMeta,
        isListed.isAcceptableOrUnknown(data['is_listed']!, _isListedMeta),
      );
    }
    if (data.containsKey('is_common')) {
      context.handle(
        _isCommonMeta,
        isCommon.isAcceptableOrUnknown(data['is_common']!, _isCommonMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {fdcId};
  @override
  Food map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Food(
      fdcId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fdc_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      sourceName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_name'],
      )!,
      kcalPerG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}kcal_per_g'],
      )!,
      proteinPerG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_per_g'],
      )!,
      carbsPerG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs_per_g'],
      )!,
      fatPerG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_per_g'],
      )!,
      isListed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_listed'],
      )!,
      isCommon: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_common'],
      )!,
    );
  }

  @override
  Foods createAlias(String alias) {
    return Foods(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Food extends DataClass implements Insertable<Food> {
  final int fdcId;
  final String name;
  final String category;
  final String sourceName;
  final double kcalPerG;
  final double proteinPerG;
  final double carbsPerG;
  final double fatPerG;
  final bool isListed;
  final bool isCommon;
  const Food({
    required this.fdcId,
    required this.name,
    required this.category,
    required this.sourceName,
    required this.kcalPerG,
    required this.proteinPerG,
    required this.carbsPerG,
    required this.fatPerG,
    required this.isListed,
    required this.isCommon,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['fdc_id'] = Variable<int>(fdcId);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['source_name'] = Variable<String>(sourceName);
    map['kcal_per_g'] = Variable<double>(kcalPerG);
    map['protein_per_g'] = Variable<double>(proteinPerG);
    map['carbs_per_g'] = Variable<double>(carbsPerG);
    map['fat_per_g'] = Variable<double>(fatPerG);
    map['is_listed'] = Variable<bool>(isListed);
    map['is_common'] = Variable<bool>(isCommon);
    return map;
  }

  FoodsCompanion toCompanion(bool nullToAbsent) {
    return FoodsCompanion(
      fdcId: Value(fdcId),
      name: Value(name),
      category: Value(category),
      sourceName: Value(sourceName),
      kcalPerG: Value(kcalPerG),
      proteinPerG: Value(proteinPerG),
      carbsPerG: Value(carbsPerG),
      fatPerG: Value(fatPerG),
      isListed: Value(isListed),
      isCommon: Value(isCommon),
    );
  }

  factory Food.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Food(
      fdcId: serializer.fromJson<int>(json['fdc_id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      sourceName: serializer.fromJson<String>(json['source_name']),
      kcalPerG: serializer.fromJson<double>(json['kcal_per_g']),
      proteinPerG: serializer.fromJson<double>(json['protein_per_g']),
      carbsPerG: serializer.fromJson<double>(json['carbs_per_g']),
      fatPerG: serializer.fromJson<double>(json['fat_per_g']),
      isListed: serializer.fromJson<bool>(json['is_listed']),
      isCommon: serializer.fromJson<bool>(json['is_common']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'fdc_id': serializer.toJson<int>(fdcId),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'source_name': serializer.toJson<String>(sourceName),
      'kcal_per_g': serializer.toJson<double>(kcalPerG),
      'protein_per_g': serializer.toJson<double>(proteinPerG),
      'carbs_per_g': serializer.toJson<double>(carbsPerG),
      'fat_per_g': serializer.toJson<double>(fatPerG),
      'is_listed': serializer.toJson<bool>(isListed),
      'is_common': serializer.toJson<bool>(isCommon),
    };
  }

  Food copyWith({
    int? fdcId,
    String? name,
    String? category,
    String? sourceName,
    double? kcalPerG,
    double? proteinPerG,
    double? carbsPerG,
    double? fatPerG,
    bool? isListed,
    bool? isCommon,
  }) => Food(
    fdcId: fdcId ?? this.fdcId,
    name: name ?? this.name,
    category: category ?? this.category,
    sourceName: sourceName ?? this.sourceName,
    kcalPerG: kcalPerG ?? this.kcalPerG,
    proteinPerG: proteinPerG ?? this.proteinPerG,
    carbsPerG: carbsPerG ?? this.carbsPerG,
    fatPerG: fatPerG ?? this.fatPerG,
    isListed: isListed ?? this.isListed,
    isCommon: isCommon ?? this.isCommon,
  );
  Food copyWithCompanion(FoodsCompanion data) {
    return Food(
      fdcId: data.fdcId.present ? data.fdcId.value : this.fdcId,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      sourceName: data.sourceName.present
          ? data.sourceName.value
          : this.sourceName,
      kcalPerG: data.kcalPerG.present ? data.kcalPerG.value : this.kcalPerG,
      proteinPerG: data.proteinPerG.present
          ? data.proteinPerG.value
          : this.proteinPerG,
      carbsPerG: data.carbsPerG.present ? data.carbsPerG.value : this.carbsPerG,
      fatPerG: data.fatPerG.present ? data.fatPerG.value : this.fatPerG,
      isListed: data.isListed.present ? data.isListed.value : this.isListed,
      isCommon: data.isCommon.present ? data.isCommon.value : this.isCommon,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Food(')
          ..write('fdcId: $fdcId, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('sourceName: $sourceName, ')
          ..write('kcalPerG: $kcalPerG, ')
          ..write('proteinPerG: $proteinPerG, ')
          ..write('carbsPerG: $carbsPerG, ')
          ..write('fatPerG: $fatPerG, ')
          ..write('isListed: $isListed, ')
          ..write('isCommon: $isCommon')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    fdcId,
    name,
    category,
    sourceName,
    kcalPerG,
    proteinPerG,
    carbsPerG,
    fatPerG,
    isListed,
    isCommon,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Food &&
          other.fdcId == this.fdcId &&
          other.name == this.name &&
          other.category == this.category &&
          other.sourceName == this.sourceName &&
          other.kcalPerG == this.kcalPerG &&
          other.proteinPerG == this.proteinPerG &&
          other.carbsPerG == this.carbsPerG &&
          other.fatPerG == this.fatPerG &&
          other.isListed == this.isListed &&
          other.isCommon == this.isCommon);
}

class FoodsCompanion extends UpdateCompanion<Food> {
  final Value<int> fdcId;
  final Value<String> name;
  final Value<String> category;
  final Value<String> sourceName;
  final Value<double> kcalPerG;
  final Value<double> proteinPerG;
  final Value<double> carbsPerG;
  final Value<double> fatPerG;
  final Value<bool> isListed;
  final Value<bool> isCommon;
  const FoodsCompanion({
    this.fdcId = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.sourceName = const Value.absent(),
    this.kcalPerG = const Value.absent(),
    this.proteinPerG = const Value.absent(),
    this.carbsPerG = const Value.absent(),
    this.fatPerG = const Value.absent(),
    this.isListed = const Value.absent(),
    this.isCommon = const Value.absent(),
  });
  FoodsCompanion.insert({
    this.fdcId = const Value.absent(),
    required String name,
    required String category,
    required String sourceName,
    required double kcalPerG,
    required double proteinPerG,
    required double carbsPerG,
    required double fatPerG,
    this.isListed = const Value.absent(),
    this.isCommon = const Value.absent(),
  }) : name = Value(name),
       category = Value(category),
       sourceName = Value(sourceName),
       kcalPerG = Value(kcalPerG),
       proteinPerG = Value(proteinPerG),
       carbsPerG = Value(carbsPerG),
       fatPerG = Value(fatPerG);
  static Insertable<Food> custom({
    Expression<int>? fdcId,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? sourceName,
    Expression<double>? kcalPerG,
    Expression<double>? proteinPerG,
    Expression<double>? carbsPerG,
    Expression<double>? fatPerG,
    Expression<bool>? isListed,
    Expression<bool>? isCommon,
  }) {
    return RawValuesInsertable({
      if (fdcId != null) 'fdc_id': fdcId,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (sourceName != null) 'source_name': sourceName,
      if (kcalPerG != null) 'kcal_per_g': kcalPerG,
      if (proteinPerG != null) 'protein_per_g': proteinPerG,
      if (carbsPerG != null) 'carbs_per_g': carbsPerG,
      if (fatPerG != null) 'fat_per_g': fatPerG,
      if (isListed != null) 'is_listed': isListed,
      if (isCommon != null) 'is_common': isCommon,
    });
  }

  FoodsCompanion copyWith({
    Value<int>? fdcId,
    Value<String>? name,
    Value<String>? category,
    Value<String>? sourceName,
    Value<double>? kcalPerG,
    Value<double>? proteinPerG,
    Value<double>? carbsPerG,
    Value<double>? fatPerG,
    Value<bool>? isListed,
    Value<bool>? isCommon,
  }) {
    return FoodsCompanion(
      fdcId: fdcId ?? this.fdcId,
      name: name ?? this.name,
      category: category ?? this.category,
      sourceName: sourceName ?? this.sourceName,
      kcalPerG: kcalPerG ?? this.kcalPerG,
      proteinPerG: proteinPerG ?? this.proteinPerG,
      carbsPerG: carbsPerG ?? this.carbsPerG,
      fatPerG: fatPerG ?? this.fatPerG,
      isListed: isListed ?? this.isListed,
      isCommon: isCommon ?? this.isCommon,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (fdcId.present) {
      map['fdc_id'] = Variable<int>(fdcId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (sourceName.present) {
      map['source_name'] = Variable<String>(sourceName.value);
    }
    if (kcalPerG.present) {
      map['kcal_per_g'] = Variable<double>(kcalPerG.value);
    }
    if (proteinPerG.present) {
      map['protein_per_g'] = Variable<double>(proteinPerG.value);
    }
    if (carbsPerG.present) {
      map['carbs_per_g'] = Variable<double>(carbsPerG.value);
    }
    if (fatPerG.present) {
      map['fat_per_g'] = Variable<double>(fatPerG.value);
    }
    if (isListed.present) {
      map['is_listed'] = Variable<bool>(isListed.value);
    }
    if (isCommon.present) {
      map['is_common'] = Variable<bool>(isCommon.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodsCompanion(')
          ..write('fdcId: $fdcId, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('sourceName: $sourceName, ')
          ..write('kcalPerG: $kcalPerG, ')
          ..write('proteinPerG: $proteinPerG, ')
          ..write('carbsPerG: $carbsPerG, ')
          ..write('fatPerG: $fatPerG, ')
          ..write('isListed: $isListed, ')
          ..write('isCommon: $isCommon')
          ..write(')'))
        .toString();
  }
}

class Meals extends Table with TableInfo<Meals, Meal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Meals(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _mealTypeMeta = const VerificationMeta(
    'mealType',
  );
  late final GeneratedColumn<String> mealType = GeneratedColumn<String>(
    'meal_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _loggedAtMeta = const VerificationMeta(
    'loggedAt',
  );
  late final GeneratedColumn<int> loggedAt = GeneratedColumn<int>(
    'logged_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, mealType, loggedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Meal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('meal_type')) {
      context.handle(
        _mealTypeMeta,
        mealType.isAcceptableOrUnknown(data['meal_type']!, _mealTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mealTypeMeta);
    }
    if (data.containsKey('logged_at')) {
      context.handle(
        _loggedAtMeta,
        loggedAt.isAcceptableOrUnknown(data['logged_at']!, _loggedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_loggedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Meal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Meal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      mealType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_type'],
      )!,
      loggedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}logged_at'],
      )!,
    );
  }

  @override
  Meals createAlias(String alias) {
    return Meals(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Meal extends DataClass implements Insertable<Meal> {
  final int id;
  final String name;
  final String mealType;
  final int loggedAt;
  const Meal({
    required this.id,
    required this.name,
    required this.mealType,
    required this.loggedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['meal_type'] = Variable<String>(mealType);
    map['logged_at'] = Variable<int>(loggedAt);
    return map;
  }

  MealsCompanion toCompanion(bool nullToAbsent) {
    return MealsCompanion(
      id: Value(id),
      name: Value(name),
      mealType: Value(mealType),
      loggedAt: Value(loggedAt),
    );
  }

  factory Meal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Meal(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      mealType: serializer.fromJson<String>(json['meal_type']),
      loggedAt: serializer.fromJson<int>(json['logged_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'meal_type': serializer.toJson<String>(mealType),
      'logged_at': serializer.toJson<int>(loggedAt),
    };
  }

  Meal copyWith({int? id, String? name, String? mealType, int? loggedAt}) =>
      Meal(
        id: id ?? this.id,
        name: name ?? this.name,
        mealType: mealType ?? this.mealType,
        loggedAt: loggedAt ?? this.loggedAt,
      );
  Meal copyWithCompanion(MealsCompanion data) {
    return Meal(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Meal(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('mealType: $mealType, ')
          ..write('loggedAt: $loggedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, mealType, loggedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Meal &&
          other.id == this.id &&
          other.name == this.name &&
          other.mealType == this.mealType &&
          other.loggedAt == this.loggedAt);
}

class MealsCompanion extends UpdateCompanion<Meal> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> mealType;
  final Value<int> loggedAt;
  const MealsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.mealType = const Value.absent(),
    this.loggedAt = const Value.absent(),
  });
  MealsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String mealType,
    required int loggedAt,
  }) : name = Value(name),
       mealType = Value(mealType),
       loggedAt = Value(loggedAt);
  static Insertable<Meal> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? mealType,
    Expression<int>? loggedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (mealType != null) 'meal_type': mealType,
      if (loggedAt != null) 'logged_at': loggedAt,
    });
  }

  MealsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? mealType,
    Value<int>? loggedAt,
  }) {
    return MealsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      mealType: mealType ?? this.mealType,
      loggedAt: loggedAt ?? this.loggedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (mealType.present) {
      map['meal_type'] = Variable<String>(mealType.value);
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<int>(loggedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('mealType: $mealType, ')
          ..write('loggedAt: $loggedAt')
          ..write(')'))
        .toString();
  }
}

class MealItems extends Table with TableInfo<MealItems, MealItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  MealItems(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _mealIdMeta = const VerificationMeta('mealId');
  late final GeneratedColumn<int> mealId = GeneratedColumn<int>(
    'meal_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES meals(id)ON DELETE CASCADE',
  );
  static const VerificationMeta _foodIdMeta = const VerificationMeta('foodId');
  late final GeneratedColumn<int> foodId = GeneratedColumn<int>(
    'food_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES foods(fdc_id)',
  );
  static const VerificationMeta _foodNameMeta = const VerificationMeta(
    'foodName',
  );
  late final GeneratedColumn<String> foodName = GeneratedColumn<String>(
    'food_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _gramsMeta = const VerificationMeta('grams');
  late final GeneratedColumn<double> grams = GeneratedColumn<double>(
    'grams',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (grams > 0)',
  );
  static const VerificationMeta _kcalPerGMeta = const VerificationMeta(
    'kcalPerG',
  );
  late final GeneratedColumn<double> kcalPerG = GeneratedColumn<double>(
    'kcal_per_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _proteinPerGMeta = const VerificationMeta(
    'proteinPerG',
  );
  late final GeneratedColumn<double> proteinPerG = GeneratedColumn<double>(
    'protein_per_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _carbsPerGMeta = const VerificationMeta(
    'carbsPerG',
  );
  late final GeneratedColumn<double> carbsPerG = GeneratedColumn<double>(
    'carbs_per_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _fatPerGMeta = const VerificationMeta(
    'fatPerG',
  );
  late final GeneratedColumn<double> fatPerG = GeneratedColumn<double>(
    'fat_per_g',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    mealId,
    foodId,
    foodName,
    grams,
    kcalPerG,
    proteinPerG,
    carbsPerG,
    fatPerG,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('meal_id')) {
      context.handle(
        _mealIdMeta,
        mealId.isAcceptableOrUnknown(data['meal_id']!, _mealIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mealIdMeta);
    }
    if (data.containsKey('food_id')) {
      context.handle(
        _foodIdMeta,
        foodId.isAcceptableOrUnknown(data['food_id']!, _foodIdMeta),
      );
    } else if (isInserting) {
      context.missing(_foodIdMeta);
    }
    if (data.containsKey('food_name')) {
      context.handle(
        _foodNameMeta,
        foodName.isAcceptableOrUnknown(data['food_name']!, _foodNameMeta),
      );
    } else if (isInserting) {
      context.missing(_foodNameMeta);
    }
    if (data.containsKey('grams')) {
      context.handle(
        _gramsMeta,
        grams.isAcceptableOrUnknown(data['grams']!, _gramsMeta),
      );
    } else if (isInserting) {
      context.missing(_gramsMeta);
    }
    if (data.containsKey('kcal_per_g')) {
      context.handle(
        _kcalPerGMeta,
        kcalPerG.isAcceptableOrUnknown(data['kcal_per_g']!, _kcalPerGMeta),
      );
    } else if (isInserting) {
      context.missing(_kcalPerGMeta);
    }
    if (data.containsKey('protein_per_g')) {
      context.handle(
        _proteinPerGMeta,
        proteinPerG.isAcceptableOrUnknown(
          data['protein_per_g']!,
          _proteinPerGMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_proteinPerGMeta);
    }
    if (data.containsKey('carbs_per_g')) {
      context.handle(
        _carbsPerGMeta,
        carbsPerG.isAcceptableOrUnknown(data['carbs_per_g']!, _carbsPerGMeta),
      );
    } else if (isInserting) {
      context.missing(_carbsPerGMeta);
    }
    if (data.containsKey('fat_per_g')) {
      context.handle(
        _fatPerGMeta,
        fatPerG.isAcceptableOrUnknown(data['fat_per_g']!, _fatPerGMeta),
      );
    } else if (isInserting) {
      context.missing(_fatPerGMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      mealId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}meal_id'],
      )!,
      foodId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}food_id'],
      )!,
      foodName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_name'],
      )!,
      grams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}grams'],
      )!,
      kcalPerG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}kcal_per_g'],
      )!,
      proteinPerG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_per_g'],
      )!,
      carbsPerG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs_per_g'],
      )!,
      fatPerG: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_per_g'],
      )!,
    );
  }

  @override
  MealItems createAlias(String alias) {
    return MealItems(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class MealItem extends DataClass implements Insertable<MealItem> {
  final int id;
  final int mealId;
  final int foodId;
  final String foodName;
  final double grams;
  final double kcalPerG;
  final double proteinPerG;
  final double carbsPerG;
  final double fatPerG;
  const MealItem({
    required this.id,
    required this.mealId,
    required this.foodId,
    required this.foodName,
    required this.grams,
    required this.kcalPerG,
    required this.proteinPerG,
    required this.carbsPerG,
    required this.fatPerG,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['meal_id'] = Variable<int>(mealId);
    map['food_id'] = Variable<int>(foodId);
    map['food_name'] = Variable<String>(foodName);
    map['grams'] = Variable<double>(grams);
    map['kcal_per_g'] = Variable<double>(kcalPerG);
    map['protein_per_g'] = Variable<double>(proteinPerG);
    map['carbs_per_g'] = Variable<double>(carbsPerG);
    map['fat_per_g'] = Variable<double>(fatPerG);
    return map;
  }

  MealItemsCompanion toCompanion(bool nullToAbsent) {
    return MealItemsCompanion(
      id: Value(id),
      mealId: Value(mealId),
      foodId: Value(foodId),
      foodName: Value(foodName),
      grams: Value(grams),
      kcalPerG: Value(kcalPerG),
      proteinPerG: Value(proteinPerG),
      carbsPerG: Value(carbsPerG),
      fatPerG: Value(fatPerG),
    );
  }

  factory MealItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealItem(
      id: serializer.fromJson<int>(json['id']),
      mealId: serializer.fromJson<int>(json['meal_id']),
      foodId: serializer.fromJson<int>(json['food_id']),
      foodName: serializer.fromJson<String>(json['food_name']),
      grams: serializer.fromJson<double>(json['grams']),
      kcalPerG: serializer.fromJson<double>(json['kcal_per_g']),
      proteinPerG: serializer.fromJson<double>(json['protein_per_g']),
      carbsPerG: serializer.fromJson<double>(json['carbs_per_g']),
      fatPerG: serializer.fromJson<double>(json['fat_per_g']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'meal_id': serializer.toJson<int>(mealId),
      'food_id': serializer.toJson<int>(foodId),
      'food_name': serializer.toJson<String>(foodName),
      'grams': serializer.toJson<double>(grams),
      'kcal_per_g': serializer.toJson<double>(kcalPerG),
      'protein_per_g': serializer.toJson<double>(proteinPerG),
      'carbs_per_g': serializer.toJson<double>(carbsPerG),
      'fat_per_g': serializer.toJson<double>(fatPerG),
    };
  }

  MealItem copyWith({
    int? id,
    int? mealId,
    int? foodId,
    String? foodName,
    double? grams,
    double? kcalPerG,
    double? proteinPerG,
    double? carbsPerG,
    double? fatPerG,
  }) => MealItem(
    id: id ?? this.id,
    mealId: mealId ?? this.mealId,
    foodId: foodId ?? this.foodId,
    foodName: foodName ?? this.foodName,
    grams: grams ?? this.grams,
    kcalPerG: kcalPerG ?? this.kcalPerG,
    proteinPerG: proteinPerG ?? this.proteinPerG,
    carbsPerG: carbsPerG ?? this.carbsPerG,
    fatPerG: fatPerG ?? this.fatPerG,
  );
  MealItem copyWithCompanion(MealItemsCompanion data) {
    return MealItem(
      id: data.id.present ? data.id.value : this.id,
      mealId: data.mealId.present ? data.mealId.value : this.mealId,
      foodId: data.foodId.present ? data.foodId.value : this.foodId,
      foodName: data.foodName.present ? data.foodName.value : this.foodName,
      grams: data.grams.present ? data.grams.value : this.grams,
      kcalPerG: data.kcalPerG.present ? data.kcalPerG.value : this.kcalPerG,
      proteinPerG: data.proteinPerG.present
          ? data.proteinPerG.value
          : this.proteinPerG,
      carbsPerG: data.carbsPerG.present ? data.carbsPerG.value : this.carbsPerG,
      fatPerG: data.fatPerG.present ? data.fatPerG.value : this.fatPerG,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealItem(')
          ..write('id: $id, ')
          ..write('mealId: $mealId, ')
          ..write('foodId: $foodId, ')
          ..write('foodName: $foodName, ')
          ..write('grams: $grams, ')
          ..write('kcalPerG: $kcalPerG, ')
          ..write('proteinPerG: $proteinPerG, ')
          ..write('carbsPerG: $carbsPerG, ')
          ..write('fatPerG: $fatPerG')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    mealId,
    foodId,
    foodName,
    grams,
    kcalPerG,
    proteinPerG,
    carbsPerG,
    fatPerG,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealItem &&
          other.id == this.id &&
          other.mealId == this.mealId &&
          other.foodId == this.foodId &&
          other.foodName == this.foodName &&
          other.grams == this.grams &&
          other.kcalPerG == this.kcalPerG &&
          other.proteinPerG == this.proteinPerG &&
          other.carbsPerG == this.carbsPerG &&
          other.fatPerG == this.fatPerG);
}

class MealItemsCompanion extends UpdateCompanion<MealItem> {
  final Value<int> id;
  final Value<int> mealId;
  final Value<int> foodId;
  final Value<String> foodName;
  final Value<double> grams;
  final Value<double> kcalPerG;
  final Value<double> proteinPerG;
  final Value<double> carbsPerG;
  final Value<double> fatPerG;
  const MealItemsCompanion({
    this.id = const Value.absent(),
    this.mealId = const Value.absent(),
    this.foodId = const Value.absent(),
    this.foodName = const Value.absent(),
    this.grams = const Value.absent(),
    this.kcalPerG = const Value.absent(),
    this.proteinPerG = const Value.absent(),
    this.carbsPerG = const Value.absent(),
    this.fatPerG = const Value.absent(),
  });
  MealItemsCompanion.insert({
    this.id = const Value.absent(),
    required int mealId,
    required int foodId,
    required String foodName,
    required double grams,
    required double kcalPerG,
    required double proteinPerG,
    required double carbsPerG,
    required double fatPerG,
  }) : mealId = Value(mealId),
       foodId = Value(foodId),
       foodName = Value(foodName),
       grams = Value(grams),
       kcalPerG = Value(kcalPerG),
       proteinPerG = Value(proteinPerG),
       carbsPerG = Value(carbsPerG),
       fatPerG = Value(fatPerG);
  static Insertable<MealItem> custom({
    Expression<int>? id,
    Expression<int>? mealId,
    Expression<int>? foodId,
    Expression<String>? foodName,
    Expression<double>? grams,
    Expression<double>? kcalPerG,
    Expression<double>? proteinPerG,
    Expression<double>? carbsPerG,
    Expression<double>? fatPerG,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mealId != null) 'meal_id': mealId,
      if (foodId != null) 'food_id': foodId,
      if (foodName != null) 'food_name': foodName,
      if (grams != null) 'grams': grams,
      if (kcalPerG != null) 'kcal_per_g': kcalPerG,
      if (proteinPerG != null) 'protein_per_g': proteinPerG,
      if (carbsPerG != null) 'carbs_per_g': carbsPerG,
      if (fatPerG != null) 'fat_per_g': fatPerG,
    });
  }

  MealItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? mealId,
    Value<int>? foodId,
    Value<String>? foodName,
    Value<double>? grams,
    Value<double>? kcalPerG,
    Value<double>? proteinPerG,
    Value<double>? carbsPerG,
    Value<double>? fatPerG,
  }) {
    return MealItemsCompanion(
      id: id ?? this.id,
      mealId: mealId ?? this.mealId,
      foodId: foodId ?? this.foodId,
      foodName: foodName ?? this.foodName,
      grams: grams ?? this.grams,
      kcalPerG: kcalPerG ?? this.kcalPerG,
      proteinPerG: proteinPerG ?? this.proteinPerG,
      carbsPerG: carbsPerG ?? this.carbsPerG,
      fatPerG: fatPerG ?? this.fatPerG,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mealId.present) {
      map['meal_id'] = Variable<int>(mealId.value);
    }
    if (foodId.present) {
      map['food_id'] = Variable<int>(foodId.value);
    }
    if (foodName.present) {
      map['food_name'] = Variable<String>(foodName.value);
    }
    if (grams.present) {
      map['grams'] = Variable<double>(grams.value);
    }
    if (kcalPerG.present) {
      map['kcal_per_g'] = Variable<double>(kcalPerG.value);
    }
    if (proteinPerG.present) {
      map['protein_per_g'] = Variable<double>(proteinPerG.value);
    }
    if (carbsPerG.present) {
      map['carbs_per_g'] = Variable<double>(carbsPerG.value);
    }
    if (fatPerG.present) {
      map['fat_per_g'] = Variable<double>(fatPerG.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealItemsCompanion(')
          ..write('id: $id, ')
          ..write('mealId: $mealId, ')
          ..write('foodId: $foodId, ')
          ..write('foodName: $foodName, ')
          ..write('grams: $grams, ')
          ..write('kcalPerG: $kcalPerG, ')
          ..write('proteinPerG: $proteinPerG, ')
          ..write('carbsPerG: $carbsPerG, ')
          ..write('fatPerG: $fatPerG')
          ..write(')'))
        .toString();
  }
}

class WaterEntries extends Table with TableInfo<WaterEntries, WaterEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  WaterEntries(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _ouncesMeta = const VerificationMeta('ounces');
  late final GeneratedColumn<double> ounces = GeneratedColumn<double>(
    'ounces',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (ounces > 0)',
  );
  static const VerificationMeta _loggedAtMeta = const VerificationMeta(
    'loggedAt',
  );
  late final GeneratedColumn<int> loggedAt = GeneratedColumn<int>(
    'logged_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [id, ounces, loggedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'water_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<WaterEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('ounces')) {
      context.handle(
        _ouncesMeta,
        ounces.isAcceptableOrUnknown(data['ounces']!, _ouncesMeta),
      );
    } else if (isInserting) {
      context.missing(_ouncesMeta);
    }
    if (data.containsKey('logged_at')) {
      context.handle(
        _loggedAtMeta,
        loggedAt.isAcceptableOrUnknown(data['logged_at']!, _loggedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_loggedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WaterEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WaterEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ounces: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ounces'],
      )!,
      loggedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}logged_at'],
      )!,
    );
  }

  @override
  WaterEntries createAlias(String alias) {
    return WaterEntries(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class WaterEntry extends DataClass implements Insertable<WaterEntry> {
  final int id;
  final double ounces;
  final int loggedAt;
  const WaterEntry({
    required this.id,
    required this.ounces,
    required this.loggedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['ounces'] = Variable<double>(ounces);
    map['logged_at'] = Variable<int>(loggedAt);
    return map;
  }

  WaterEntriesCompanion toCompanion(bool nullToAbsent) {
    return WaterEntriesCompanion(
      id: Value(id),
      ounces: Value(ounces),
      loggedAt: Value(loggedAt),
    );
  }

  factory WaterEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WaterEntry(
      id: serializer.fromJson<int>(json['id']),
      ounces: serializer.fromJson<double>(json['ounces']),
      loggedAt: serializer.fromJson<int>(json['logged_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ounces': serializer.toJson<double>(ounces),
      'logged_at': serializer.toJson<int>(loggedAt),
    };
  }

  WaterEntry copyWith({int? id, double? ounces, int? loggedAt}) => WaterEntry(
    id: id ?? this.id,
    ounces: ounces ?? this.ounces,
    loggedAt: loggedAt ?? this.loggedAt,
  );
  WaterEntry copyWithCompanion(WaterEntriesCompanion data) {
    return WaterEntry(
      id: data.id.present ? data.id.value : this.id,
      ounces: data.ounces.present ? data.ounces.value : this.ounces,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WaterEntry(')
          ..write('id: $id, ')
          ..write('ounces: $ounces, ')
          ..write('loggedAt: $loggedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ounces, loggedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WaterEntry &&
          other.id == this.id &&
          other.ounces == this.ounces &&
          other.loggedAt == this.loggedAt);
}

class WaterEntriesCompanion extends UpdateCompanion<WaterEntry> {
  final Value<int> id;
  final Value<double> ounces;
  final Value<int> loggedAt;
  const WaterEntriesCompanion({
    this.id = const Value.absent(),
    this.ounces = const Value.absent(),
    this.loggedAt = const Value.absent(),
  });
  WaterEntriesCompanion.insert({
    this.id = const Value.absent(),
    required double ounces,
    required int loggedAt,
  }) : ounces = Value(ounces),
       loggedAt = Value(loggedAt);
  static Insertable<WaterEntry> custom({
    Expression<int>? id,
    Expression<double>? ounces,
    Expression<int>? loggedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ounces != null) 'ounces': ounces,
      if (loggedAt != null) 'logged_at': loggedAt,
    });
  }

  WaterEntriesCompanion copyWith({
    Value<int>? id,
    Value<double>? ounces,
    Value<int>? loggedAt,
  }) {
    return WaterEntriesCompanion(
      id: id ?? this.id,
      ounces: ounces ?? this.ounces,
      loggedAt: loggedAt ?? this.loggedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ounces.present) {
      map['ounces'] = Variable<double>(ounces.value);
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<int>(loggedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WaterEntriesCompanion(')
          ..write('id: $id, ')
          ..write('ounces: $ounces, ')
          ..write('loggedAt: $loggedAt')
          ..write(')'))
        .toString();
  }
}

class Goals extends Table with TableInfo<Goals, Goal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Goals(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _effectiveDateMeta = const VerificationMeta(
    'effectiveDate',
  );
  late final GeneratedColumn<String> effectiveDate = GeneratedColumn<String>(
    'effective_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  late final GeneratedColumn<double> calories = GeneratedColumn<double>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (calories > 0)',
  );
  static const VerificationMeta _waterOuncesMeta = const VerificationMeta(
    'waterOunces',
  );
  late final GeneratedColumn<double> waterOunces = GeneratedColumn<double>(
    'water_ounces',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (water_ounces > 0)',
  );
  @override
  List<GeneratedColumn> get $columns => [effectiveDate, calories, waterOunces];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Goal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('effective_date')) {
      context.handle(
        _effectiveDateMeta,
        effectiveDate.isAcceptableOrUnknown(
          data['effective_date']!,
          _effectiveDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_effectiveDateMeta);
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    } else if (isInserting) {
      context.missing(_caloriesMeta);
    }
    if (data.containsKey('water_ounces')) {
      context.handle(
        _waterOuncesMeta,
        waterOunces.isAcceptableOrUnknown(
          data['water_ounces']!,
          _waterOuncesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_waterOuncesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {effectiveDate};
  @override
  Goal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Goal(
      effectiveDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}effective_date'],
      )!,
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories'],
      )!,
      waterOunces: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}water_ounces'],
      )!,
    );
  }

  @override
  Goals createAlias(String alias) {
    return Goals(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Goal extends DataClass implements Insertable<Goal> {
  final String effectiveDate;
  final double calories;
  final double waterOunces;
  const Goal({
    required this.effectiveDate,
    required this.calories,
    required this.waterOunces,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['effective_date'] = Variable<String>(effectiveDate);
    map['calories'] = Variable<double>(calories);
    map['water_ounces'] = Variable<double>(waterOunces);
    return map;
  }

  GoalsCompanion toCompanion(bool nullToAbsent) {
    return GoalsCompanion(
      effectiveDate: Value(effectiveDate),
      calories: Value(calories),
      waterOunces: Value(waterOunces),
    );
  }

  factory Goal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Goal(
      effectiveDate: serializer.fromJson<String>(json['effective_date']),
      calories: serializer.fromJson<double>(json['calories']),
      waterOunces: serializer.fromJson<double>(json['water_ounces']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'effective_date': serializer.toJson<String>(effectiveDate),
      'calories': serializer.toJson<double>(calories),
      'water_ounces': serializer.toJson<double>(waterOunces),
    };
  }

  Goal copyWith({
    String? effectiveDate,
    double? calories,
    double? waterOunces,
  }) => Goal(
    effectiveDate: effectiveDate ?? this.effectiveDate,
    calories: calories ?? this.calories,
    waterOunces: waterOunces ?? this.waterOunces,
  );
  Goal copyWithCompanion(GoalsCompanion data) {
    return Goal(
      effectiveDate: data.effectiveDate.present
          ? data.effectiveDate.value
          : this.effectiveDate,
      calories: data.calories.present ? data.calories.value : this.calories,
      waterOunces: data.waterOunces.present
          ? data.waterOunces.value
          : this.waterOunces,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Goal(')
          ..write('effectiveDate: $effectiveDate, ')
          ..write('calories: $calories, ')
          ..write('waterOunces: $waterOunces')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(effectiveDate, calories, waterOunces);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Goal &&
          other.effectiveDate == this.effectiveDate &&
          other.calories == this.calories &&
          other.waterOunces == this.waterOunces);
}

class GoalsCompanion extends UpdateCompanion<Goal> {
  final Value<String> effectiveDate;
  final Value<double> calories;
  final Value<double> waterOunces;
  final Value<int> rowid;
  const GoalsCompanion({
    this.effectiveDate = const Value.absent(),
    this.calories = const Value.absent(),
    this.waterOunces = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalsCompanion.insert({
    required String effectiveDate,
    required double calories,
    required double waterOunces,
    this.rowid = const Value.absent(),
  }) : effectiveDate = Value(effectiveDate),
       calories = Value(calories),
       waterOunces = Value(waterOunces);
  static Insertable<Goal> custom({
    Expression<String>? effectiveDate,
    Expression<double>? calories,
    Expression<double>? waterOunces,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (effectiveDate != null) 'effective_date': effectiveDate,
      if (calories != null) 'calories': calories,
      if (waterOunces != null) 'water_ounces': waterOunces,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalsCompanion copyWith({
    Value<String>? effectiveDate,
    Value<double>? calories,
    Value<double>? waterOunces,
    Value<int>? rowid,
  }) {
    return GoalsCompanion(
      effectiveDate: effectiveDate ?? this.effectiveDate,
      calories: calories ?? this.calories,
      waterOunces: waterOunces ?? this.waterOunces,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (effectiveDate.present) {
      map['effective_date'] = Variable<String>(effectiveDate.value);
    }
    if (calories.present) {
      map['calories'] = Variable<double>(calories.value);
    }
    if (waterOunces.present) {
      map['water_ounces'] = Variable<double>(waterOunces.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsCompanion(')
          ..write('effectiveDate: $effectiveDate, ')
          ..write('calories: $calories, ')
          ..write('waterOunces: $waterOunces, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class CatalogState extends Table
    with TableInfo<CatalogState, CatalogStateData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  CatalogState(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  @override
  List<GeneratedColumn> get $columns => [version];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalog_state';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogStateData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {version};
  @override
  CatalogStateData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogStateData(
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
    );
  }

  @override
  CatalogState createAlias(String alias) {
    return CatalogState(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class CatalogStateData extends DataClass
    implements Insertable<CatalogStateData> {
  final int version;
  const CatalogStateData({required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['version'] = Variable<int>(version);
    return map;
  }

  CatalogStateCompanion toCompanion(bool nullToAbsent) {
    return CatalogStateCompanion(version: Value(version));
  }

  factory CatalogStateData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogStateData(version: serializer.fromJson<int>(json['version']));
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{'version': serializer.toJson<int>(version)};
  }

  CatalogStateData copyWith({int? version}) =>
      CatalogStateData(version: version ?? this.version);
  CatalogStateData copyWithCompanion(CatalogStateCompanion data) {
    return CatalogStateData(
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogStateData(')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => version.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogStateData && other.version == this.version);
}

class CatalogStateCompanion extends UpdateCompanion<CatalogStateData> {
  final Value<int> version;
  const CatalogStateCompanion({this.version = const Value.absent()});
  CatalogStateCompanion.insert({this.version = const Value.absent()});
  static Insertable<CatalogStateData> custom({Expression<int>? version}) {
    return RawValuesInsertable({if (version != null) 'version': version});
  }

  CatalogStateCompanion copyWith({Value<int>? version}) {
    return CatalogStateCompanion(version: version ?? this.version);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogStateCompanion(')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final Foods foods = Foods(this);
  late final Index foodsSearch = Index(
    'foods_search',
    'CREATE INDEX foods_search ON foods (name COLLATE NOCASE, fdc_id)',
  );
  late final Meals meals = Meals(this);
  late final Index mealsDate = Index(
    'meals_date',
    'CREATE INDEX meals_date ON meals (logged_at)',
  );
  late final MealItems mealItems = MealItems(this);
  late final Index itemsMeal = Index(
    'items_meal',
    'CREATE INDEX items_meal ON meal_items (meal_id)',
  );
  late final WaterEntries waterEntries = WaterEntries(this);
  late final Index waterDate = Index(
    'water_date',
    'CREATE INDEX water_date ON water_entries (logged_at)',
  );
  late final Goals goals = Goals(this);
  late final CatalogState catalogState = CatalogState(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    foods,
    foodsSearch,
    meals,
    mealsDate,
    mealItems,
    itemsMeal,
    waterEntries,
    waterDate,
    goals,
    catalogState,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'meals',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('meal_items', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $FoodsCreateCompanionBuilder = FoodsCompanion Function({
  Value<int> fdcId,
  required String name,
  required String category,
  required String sourceName,
  required double kcalPerG,
  required double proteinPerG,
  required double carbsPerG,
  required double fatPerG,
  Value<bool> isListed,
  Value<bool> isCommon,
});
typedef $FoodsUpdateCompanionBuilder = FoodsCompanion Function({
  Value<int> fdcId,
  Value<String> name,
  Value<String> category,
  Value<String> sourceName,
  Value<double> kcalPerG,
  Value<double> proteinPerG,
  Value<double> carbsPerG,
  Value<double> fatPerG,
  Value<bool> isListed,
  Value<bool> isCommon,
});

final class $FoodsReferences
    extends BaseReferences<_$AppDatabase, Foods, Food> {
  $FoodsReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<MealItems, List<MealItem>> _mealItemsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.mealItems,
    aliasName: 'foods__fdc_id__meal_items__food_id',
  );

  $MealItemsProcessedTableManager get mealItemsRefs {
    final manager = $MealItemsTableManager(
      $_db,
      $_db.mealItems,
    ).filter((f) => f.foodId.fdcId.sqlEquals($_itemColumn<int>('fdc_id')!));

    final cache = $_typedResult.readTableOrNull(_mealItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $FoodsFilterComposer extends Composer<_$AppDatabase, Foods> {
  $FoodsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get fdcId => $composableBuilder(
    column: $table.fdcId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceName => $composableBuilder(
    column: $table.sourceName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get kcalPerG => $composableBuilder(
    column: $table.kcalPerG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinPerG => $composableBuilder(
    column: $table.proteinPerG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbsPerG => $composableBuilder(
    column: $table.carbsPerG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatPerG => $composableBuilder(
    column: $table.fatPerG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isListed => $composableBuilder(
    column: $table.isListed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCommon => $composableBuilder(
    column: $table.isCommon,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> mealItemsRefs(
    Expression<bool> Function($MealItemsFilterComposer f) f,
  ) {
    final $MealItemsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fdcId,
      referencedTable: $db.mealItems,
      getReferencedColumn: (t) => t.foodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $MealItemsFilterComposer(
            $db: $db,
            $table: $db.mealItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $FoodsOrderingComposer extends Composer<_$AppDatabase, Foods> {
  $FoodsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get fdcId => $composableBuilder(
    column: $table.fdcId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceName => $composableBuilder(
    column: $table.sourceName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get kcalPerG => $composableBuilder(
    column: $table.kcalPerG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinPerG => $composableBuilder(
    column: $table.proteinPerG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbsPerG => $composableBuilder(
    column: $table.carbsPerG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatPerG => $composableBuilder(
    column: $table.fatPerG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isListed => $composableBuilder(
    column: $table.isListed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCommon => $composableBuilder(
    column: $table.isCommon,
    builder: (column) => ColumnOrderings(column),
  );
}

class $FoodsAnnotationComposer extends Composer<_$AppDatabase, Foods> {
  $FoodsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get fdcId =>
      $composableBuilder(column: $table.fdcId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get sourceName => $composableBuilder(
    column: $table.sourceName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get kcalPerG =>
      $composableBuilder(column: $table.kcalPerG, builder: (column) => column);

  GeneratedColumn<double> get proteinPerG => $composableBuilder(
    column: $table.proteinPerG,
    builder: (column) => column,
  );

  GeneratedColumn<double> get carbsPerG =>
      $composableBuilder(column: $table.carbsPerG, builder: (column) => column);

  GeneratedColumn<double> get fatPerG =>
      $composableBuilder(column: $table.fatPerG, builder: (column) => column);

  GeneratedColumn<bool> get isListed =>
      $composableBuilder(column: $table.isListed, builder: (column) => column);

  GeneratedColumn<bool> get isCommon =>
      $composableBuilder(column: $table.isCommon, builder: (column) => column);

  Expression<T> mealItemsRefs<T extends Object>(
    Expression<T> Function($MealItemsAnnotationComposer a) f,
  ) {
    final $MealItemsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fdcId,
      referencedTable: $db.mealItems,
      getReferencedColumn: (t) => t.foodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $MealItemsAnnotationComposer(
            $db: $db,
            $table: $db.mealItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $FoodsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Foods,
          Food,
          $FoodsFilterComposer,
          $FoodsOrderingComposer,
          $FoodsAnnotationComposer,
          $FoodsCreateCompanionBuilder,
          $FoodsUpdateCompanionBuilder,
          (Food, $FoodsReferences),
          Food,
          PrefetchHooks Function({bool mealItemsRefs})
        > {
  $FoodsTableManager(_$AppDatabase db, Foods table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $FoodsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $FoodsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $FoodsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> fdcId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> sourceName = const Value.absent(),
                Value<double> kcalPerG = const Value.absent(),
                Value<double> proteinPerG = const Value.absent(),
                Value<double> carbsPerG = const Value.absent(),
                Value<double> fatPerG = const Value.absent(),
                Value<bool> isListed = const Value.absent(),
                Value<bool> isCommon = const Value.absent(),
              }) => FoodsCompanion(
                fdcId: fdcId,
                name: name,
                category: category,
                sourceName: sourceName,
                kcalPerG: kcalPerG,
                proteinPerG: proteinPerG,
                carbsPerG: carbsPerG,
                fatPerG: fatPerG,
                isListed: isListed,
                isCommon: isCommon,
              ),
          createCompanionCallback:
              ({
                Value<int> fdcId = const Value.absent(),
                required String name,
                required String category,
                required String sourceName,
                required double kcalPerG,
                required double proteinPerG,
                required double carbsPerG,
                required double fatPerG,
                Value<bool> isListed = const Value.absent(),
                Value<bool> isCommon = const Value.absent(),
              }) => FoodsCompanion.insert(
                fdcId: fdcId,
                name: name,
                category: category,
                sourceName: sourceName,
                kcalPerG: kcalPerG,
                proteinPerG: proteinPerG,
                carbsPerG: carbsPerG,
                fatPerG: fatPerG,
                isListed: isListed,
                isCommon: isCommon,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Foods, Food>(table),
                  $FoodsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({mealItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (mealItemsRefs) db.mealItems],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (mealItemsRefs)
                    await $_getPrefetchedDataByColumns<
                      Food,
                      Foods,
                      MealItem,
                      MealItems
                    >(
                      currentTable: table,
                      referencedTable: $FoodsReferences._mealItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $FoodsReferences(db, table, p0).mealItemsRefs,
                      currentColumn: 'fdc_id',
                      referencedColumn: 'food_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $FoodsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Foods,
      Food,
      $FoodsFilterComposer,
      $FoodsOrderingComposer,
      $FoodsAnnotationComposer,
      $FoodsCreateCompanionBuilder,
      $FoodsUpdateCompanionBuilder,
      (Food, $FoodsReferences),
      Food,
      PrefetchHooks Function({bool mealItemsRefs})
    >;
typedef $MealsCreateCompanionBuilder = MealsCompanion Function({
  Value<int> id,
  required String name,
  required String mealType,
  required int loggedAt,
});
typedef $MealsUpdateCompanionBuilder = MealsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> mealType,
  Value<int> loggedAt,
});

final class $MealsReferences
    extends BaseReferences<_$AppDatabase, Meals, Meal> {
  $MealsReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<MealItems, List<MealItem>> _mealItemsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.mealItems,
    aliasName: 'meals__id__meal_items__meal_id',
  );

  $MealItemsProcessedTableManager get mealItemsRefs {
    final manager = $MealItemsTableManager(
      $_db,
      $_db.mealItems,
    ).filter((f) => f.mealId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mealItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $MealsFilterComposer extends Composer<_$AppDatabase, Meals> {
  $MealsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> mealItemsRefs(
    Expression<bool> Function($MealItemsFilterComposer f) f,
  ) {
    final $MealItemsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealItems,
      getReferencedColumn: (t) => t.mealId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $MealItemsFilterComposer(
            $db: $db,
            $table: $db.mealItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $MealsOrderingComposer extends Composer<_$AppDatabase, Meals> {
  $MealsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $MealsAnnotationComposer extends Composer<_$AppDatabase, Meals> {
  $MealsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  GeneratedColumn<int> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);

  Expression<T> mealItemsRefs<T extends Object>(
    Expression<T> Function($MealItemsAnnotationComposer a) f,
  ) {
    final $MealItemsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealItems,
      getReferencedColumn: (t) => t.mealId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $MealItemsAnnotationComposer(
            $db: $db,
            $table: $db.mealItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $MealsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Meals,
          Meal,
          $MealsFilterComposer,
          $MealsOrderingComposer,
          $MealsAnnotationComposer,
          $MealsCreateCompanionBuilder,
          $MealsUpdateCompanionBuilder,
          (Meal, $MealsReferences),
          Meal,
          PrefetchHooks Function({bool mealItemsRefs})
        > {
  $MealsTableManager(_$AppDatabase db, Meals table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $MealsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $MealsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $MealsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> mealType = const Value.absent(),
                Value<int> loggedAt = const Value.absent(),
              }) => MealsCompanion(
                id: id,
                name: name,
                mealType: mealType,
                loggedAt: loggedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String mealType,
                required int loggedAt,
              }) => MealsCompanion.insert(
                id: id,
                name: name,
                mealType: mealType,
                loggedAt: loggedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Meals, Meal>(table),
                  $MealsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({mealItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (mealItemsRefs) db.mealItems],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (mealItemsRefs)
                    await $_getPrefetchedDataByColumns<
                      Meal,
                      Meals,
                      MealItem,
                      MealItems
                    >(
                      currentTable: table,
                      referencedTable: $MealsReferences._mealItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $MealsReferences(db, table, p0).mealItemsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'meal_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $MealsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Meals,
      Meal,
      $MealsFilterComposer,
      $MealsOrderingComposer,
      $MealsAnnotationComposer,
      $MealsCreateCompanionBuilder,
      $MealsUpdateCompanionBuilder,
      (Meal, $MealsReferences),
      Meal,
      PrefetchHooks Function({bool mealItemsRefs})
    >;
typedef $MealItemsCreateCompanionBuilder = MealItemsCompanion Function({
  Value<int> id,
  required int mealId,
  required int foodId,
  required String foodName,
  required double grams,
  required double kcalPerG,
  required double proteinPerG,
  required double carbsPerG,
  required double fatPerG,
});
typedef $MealItemsUpdateCompanionBuilder = MealItemsCompanion Function({
  Value<int> id,
  Value<int> mealId,
  Value<int> foodId,
  Value<String> foodName,
  Value<double> grams,
  Value<double> kcalPerG,
  Value<double> proteinPerG,
  Value<double> carbsPerG,
  Value<double> fatPerG,
});

final class $MealItemsReferences
    extends BaseReferences<_$AppDatabase, MealItems, MealItem> {
  $MealItemsReferences(super.$_db, super.$_table, super.$_typedResult);

  static Meals _mealIdTable(_$AppDatabase db) =>
      db.meals.createAlias('meal_items__meal_id__meals__id');

  $MealsProcessedTableManager get mealId {
    final $_column = $_itemColumn<int>('meal_id')!;

    final manager = $MealsTableManager(
      $_db,
      $_db.meals,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mealIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Foods _foodIdTable(_$AppDatabase db) =>
      db.foods.createAlias('meal_items__food_id__foods__fdc_id');

  $FoodsProcessedTableManager get foodId {
    final $_column = $_itemColumn<int>('food_id')!;

    final manager = $FoodsTableManager(
      $_db,
      $_db.foods,
    ).filter((f) => f.fdcId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_foodIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $MealItemsFilterComposer extends Composer<_$AppDatabase, MealItems> {
  $MealItemsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foodName => $composableBuilder(
    column: $table.foodName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get grams => $composableBuilder(
    column: $table.grams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get kcalPerG => $composableBuilder(
    column: $table.kcalPerG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinPerG => $composableBuilder(
    column: $table.proteinPerG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbsPerG => $composableBuilder(
    column: $table.carbsPerG,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatPerG => $composableBuilder(
    column: $table.fatPerG,
    builder: (column) => ColumnFilters(column),
  );

  $MealsFilterComposer get mealId {
    final $MealsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealId,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $MealsFilterComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $FoodsFilterComposer get foodId {
    final $FoodsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.foodId,
      referencedTable: $db.foods,
      getReferencedColumn: (t) => t.fdcId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $FoodsFilterComposer(
            $db: $db,
            $table: $db.foods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $MealItemsOrderingComposer extends Composer<_$AppDatabase, MealItems> {
  $MealItemsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foodName => $composableBuilder(
    column: $table.foodName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get grams => $composableBuilder(
    column: $table.grams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get kcalPerG => $composableBuilder(
    column: $table.kcalPerG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinPerG => $composableBuilder(
    column: $table.proteinPerG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbsPerG => $composableBuilder(
    column: $table.carbsPerG,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatPerG => $composableBuilder(
    column: $table.fatPerG,
    builder: (column) => ColumnOrderings(column),
  );

  $MealsOrderingComposer get mealId {
    final $MealsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealId,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $MealsOrderingComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $FoodsOrderingComposer get foodId {
    final $FoodsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.foodId,
      referencedTable: $db.foods,
      getReferencedColumn: (t) => t.fdcId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $FoodsOrderingComposer(
            $db: $db,
            $table: $db.foods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $MealItemsAnnotationComposer extends Composer<_$AppDatabase, MealItems> {
  $MealItemsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get foodName =>
      $composableBuilder(column: $table.foodName, builder: (column) => column);

  GeneratedColumn<double> get grams =>
      $composableBuilder(column: $table.grams, builder: (column) => column);

  GeneratedColumn<double> get kcalPerG =>
      $composableBuilder(column: $table.kcalPerG, builder: (column) => column);

  GeneratedColumn<double> get proteinPerG => $composableBuilder(
    column: $table.proteinPerG,
    builder: (column) => column,
  );

  GeneratedColumn<double> get carbsPerG =>
      $composableBuilder(column: $table.carbsPerG, builder: (column) => column);

  GeneratedColumn<double> get fatPerG =>
      $composableBuilder(column: $table.fatPerG, builder: (column) => column);

  $MealsAnnotationComposer get mealId {
    final $MealsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealId,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $MealsAnnotationComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $FoodsAnnotationComposer get foodId {
    final $FoodsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.foodId,
      referencedTable: $db.foods,
      getReferencedColumn: (t) => t.fdcId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $FoodsAnnotationComposer(
            $db: $db,
            $table: $db.foods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $MealItemsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          MealItems,
          MealItem,
          $MealItemsFilterComposer,
          $MealItemsOrderingComposer,
          $MealItemsAnnotationComposer,
          $MealItemsCreateCompanionBuilder,
          $MealItemsUpdateCompanionBuilder,
          (MealItem, $MealItemsReferences),
          MealItem,
          PrefetchHooks Function({bool mealId, bool foodId})
        > {
  $MealItemsTableManager(_$AppDatabase db, MealItems table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $MealItemsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $MealItemsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $MealItemsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> mealId = const Value.absent(),
                Value<int> foodId = const Value.absent(),
                Value<String> foodName = const Value.absent(),
                Value<double> grams = const Value.absent(),
                Value<double> kcalPerG = const Value.absent(),
                Value<double> proteinPerG = const Value.absent(),
                Value<double> carbsPerG = const Value.absent(),
                Value<double> fatPerG = const Value.absent(),
              }) => MealItemsCompanion(
                id: id,
                mealId: mealId,
                foodId: foodId,
                foodName: foodName,
                grams: grams,
                kcalPerG: kcalPerG,
                proteinPerG: proteinPerG,
                carbsPerG: carbsPerG,
                fatPerG: fatPerG,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int mealId,
                required int foodId,
                required String foodName,
                required double grams,
                required double kcalPerG,
                required double proteinPerG,
                required double carbsPerG,
                required double fatPerG,
              }) => MealItemsCompanion.insert(
                id: id,
                mealId: mealId,
                foodId: foodId,
                foodName: foodName,
                grams: grams,
                kcalPerG: kcalPerG,
                proteinPerG: proteinPerG,
                carbsPerG: carbsPerG,
                fatPerG: fatPerG,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<MealItems, MealItem>(table),
                  $MealItemsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({mealId = false, foodId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (mealId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.mealId,
                        referencedTable: $MealItemsReferences._mealIdTable(db),
                        referencedColumn: $MealItemsReferences
                            ._mealIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (foodId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.foodId,
                        referencedTable: $MealItemsReferences._foodIdTable(db),
                        referencedColumn: $MealItemsReferences
                            ._foodIdTable(db)
                            .fdcId,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $MealItemsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      MealItems,
      MealItem,
      $MealItemsFilterComposer,
      $MealItemsOrderingComposer,
      $MealItemsAnnotationComposer,
      $MealItemsCreateCompanionBuilder,
      $MealItemsUpdateCompanionBuilder,
      (MealItem, $MealItemsReferences),
      MealItem,
      PrefetchHooks Function({bool mealId, bool foodId})
    >;
typedef $WaterEntriesCreateCompanionBuilder = WaterEntriesCompanion Function({
  Value<int> id,
  required double ounces,
  required int loggedAt,
});
typedef $WaterEntriesUpdateCompanionBuilder = WaterEntriesCompanion Function({
  Value<int> id,
  Value<double> ounces,
  Value<int> loggedAt,
});

class $WaterEntriesFilterComposer
    extends Composer<_$AppDatabase, WaterEntries> {
  $WaterEntriesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ounces => $composableBuilder(
    column: $table.ounces,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $WaterEntriesOrderingComposer
    extends Composer<_$AppDatabase, WaterEntries> {
  $WaterEntriesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ounces => $composableBuilder(
    column: $table.ounces,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $WaterEntriesAnnotationComposer
    extends Composer<_$AppDatabase, WaterEntries> {
  $WaterEntriesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get ounces =>
      $composableBuilder(column: $table.ounces, builder: (column) => column);

  GeneratedColumn<int> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);
}

class $WaterEntriesTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          WaterEntries,
          WaterEntry,
          $WaterEntriesFilterComposer,
          $WaterEntriesOrderingComposer,
          $WaterEntriesAnnotationComposer,
          $WaterEntriesCreateCompanionBuilder,
          $WaterEntriesUpdateCompanionBuilder,
          (WaterEntry, BaseReferences<_$AppDatabase, WaterEntries, WaterEntry>),
          WaterEntry,
          PrefetchHooks Function()
        > {
  $WaterEntriesTableManager(_$AppDatabase db, WaterEntries table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $WaterEntriesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $WaterEntriesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $WaterEntriesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> ounces = const Value.absent(),
                Value<int> loggedAt = const Value.absent(),
              }) => WaterEntriesCompanion(
                id: id,
                ounces: ounces,
                loggedAt: loggedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required double ounces,
                required int loggedAt,
              }) => WaterEntriesCompanion.insert(
                id: id,
                ounces: ounces,
                loggedAt: loggedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<WaterEntries, WaterEntry>(table),
                  BaseReferences<_$AppDatabase, WaterEntries, WaterEntry>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $WaterEntriesProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      WaterEntries,
      WaterEntry,
      $WaterEntriesFilterComposer,
      $WaterEntriesOrderingComposer,
      $WaterEntriesAnnotationComposer,
      $WaterEntriesCreateCompanionBuilder,
      $WaterEntriesUpdateCompanionBuilder,
      (WaterEntry, BaseReferences<_$AppDatabase, WaterEntries, WaterEntry>),
      WaterEntry,
      PrefetchHooks Function()
    >;
typedef $GoalsCreateCompanionBuilder = GoalsCompanion Function({
  required String effectiveDate,
  required double calories,
  required double waterOunces,
  Value<int> rowid,
});
typedef $GoalsUpdateCompanionBuilder = GoalsCompanion Function({
  Value<String> effectiveDate,
  Value<double> calories,
  Value<double> waterOunces,
  Value<int> rowid,
});

class $GoalsFilterComposer extends Composer<_$AppDatabase, Goals> {
  $GoalsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get effectiveDate => $composableBuilder(
    column: $table.effectiveDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get waterOunces => $composableBuilder(
    column: $table.waterOunces,
    builder: (column) => ColumnFilters(column),
  );
}

class $GoalsOrderingComposer extends Composer<_$AppDatabase, Goals> {
  $GoalsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get effectiveDate => $composableBuilder(
    column: $table.effectiveDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get waterOunces => $composableBuilder(
    column: $table.waterOunces,
    builder: (column) => ColumnOrderings(column),
  );
}

class $GoalsAnnotationComposer extends Composer<_$AppDatabase, Goals> {
  $GoalsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get effectiveDate => $composableBuilder(
    column: $table.effectiveDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<double> get waterOunces => $composableBuilder(
    column: $table.waterOunces,
    builder: (column) => column,
  );
}

class $GoalsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Goals,
          Goal,
          $GoalsFilterComposer,
          $GoalsOrderingComposer,
          $GoalsAnnotationComposer,
          $GoalsCreateCompanionBuilder,
          $GoalsUpdateCompanionBuilder,
          (Goal, BaseReferences<_$AppDatabase, Goals, Goal>),
          Goal,
          PrefetchHooks Function()
        > {
  $GoalsTableManager(_$AppDatabase db, Goals table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $GoalsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $GoalsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $GoalsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> effectiveDate = const Value.absent(),
                Value<double> calories = const Value.absent(),
                Value<double> waterOunces = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalsCompanion(
                effectiveDate: effectiveDate,
                calories: calories,
                waterOunces: waterOunces,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String effectiveDate,
                required double calories,
                required double waterOunces,
                Value<int> rowid = const Value.absent(),
              }) => GoalsCompanion.insert(
                effectiveDate: effectiveDate,
                calories: calories,
                waterOunces: waterOunces,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Goals, Goal>(table),
                  BaseReferences<_$AppDatabase, Goals, Goal>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $GoalsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Goals,
      Goal,
      $GoalsFilterComposer,
      $GoalsOrderingComposer,
      $GoalsAnnotationComposer,
      $GoalsCreateCompanionBuilder,
      $GoalsUpdateCompanionBuilder,
      (Goal, BaseReferences<_$AppDatabase, Goals, Goal>),
      Goal,
      PrefetchHooks Function()
    >;
typedef $CatalogStateCreateCompanionBuilder = CatalogStateCompanion Function({
  Value<int> version,
});
typedef $CatalogStateUpdateCompanionBuilder = CatalogStateCompanion Function({
  Value<int> version,
});

class $CatalogStateFilterComposer
    extends Composer<_$AppDatabase, CatalogState> {
  $CatalogStateFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );
}

class $CatalogStateOrderingComposer
    extends Composer<_$AppDatabase, CatalogState> {
  $CatalogStateOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );
}

class $CatalogStateAnnotationComposer
    extends Composer<_$AppDatabase, CatalogState> {
  $CatalogStateAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);
}

class $CatalogStateTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          CatalogState,
          CatalogStateData,
          $CatalogStateFilterComposer,
          $CatalogStateOrderingComposer,
          $CatalogStateAnnotationComposer,
          $CatalogStateCreateCompanionBuilder,
          $CatalogStateUpdateCompanionBuilder,
          (
            CatalogStateData,
            BaseReferences<_$AppDatabase, CatalogState, CatalogStateData>,
          ),
          CatalogStateData,
          PrefetchHooks Function()
        > {
  $CatalogStateTableManager(_$AppDatabase db, CatalogState table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $CatalogStateFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $CatalogStateOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $CatalogStateAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> version = const Value.absent(),
          }) => CatalogStateCompanion(version: version),
          createCompanionCallback: ({
            Value<int> version = const Value.absent(),
          }) => CatalogStateCompanion.insert(version: version),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<CatalogState, CatalogStateData>(table),
                  BaseReferences<_$AppDatabase, CatalogState, CatalogStateData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $CatalogStateProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      CatalogState,
      CatalogStateData,
      $CatalogStateFilterComposer,
      $CatalogStateOrderingComposer,
      $CatalogStateAnnotationComposer,
      $CatalogStateCreateCompanionBuilder,
      $CatalogStateUpdateCompanionBuilder,
      (
        CatalogStateData,
        BaseReferences<_$AppDatabase, CatalogState, CatalogStateData>,
      ),
      CatalogStateData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $FoodsTableManager get foods => $FoodsTableManager(_db, _db.foods);
  $MealsTableManager get meals => $MealsTableManager(_db, _db.meals);
  $MealItemsTableManager get mealItems =>
      $MealItemsTableManager(_db, _db.mealItems);
  $WaterEntriesTableManager get waterEntries =>
      $WaterEntriesTableManager(_db, _db.waterEntries);
  $GoalsTableManager get goals => $GoalsTableManager(_db, _db.goals);
  $CatalogStateTableManager get catalogState =>
      $CatalogStateTableManager(_db, _db.catalogState);
}
