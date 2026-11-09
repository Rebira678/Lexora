// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $WordsTable extends Words with TableInfo<$WordsTable, Word> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _lemmaMeta = const VerificationMeta('lemma');
  @override
  late final GeneratedColumn<String> lemma = GeneratedColumn<String>(
    'lemma',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _posMeta = const VerificationMeta('pos');
  @override
  late final GeneratedColumn<String> pos = GeneratedColumn<String>(
    'pos',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ipaMeta = const VerificationMeta('ipa');
  @override
  late final GeneratedColumn<String> ipa = GeneratedColumn<String>(
    'ipa',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cefrMeta = const VerificationMeta('cefr');
  @override
  late final GeneratedColumn<String> cefr = GeneratedColumn<String>(
    'cefr',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _freqRankMeta = const VerificationMeta(
    'freqRank',
  );
  @override
  late final GeneratedColumn<int> freqRank = GeneratedColumn<int>(
    'freq_rank',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _definitionEnMeta = const VerificationMeta(
    'definitionEn',
  );
  @override
  late final GeneratedColumn<String> definitionEn = GeneratedColumn<String>(
    'definition_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _definitionNativeMeta = const VerificationMeta(
    'definitionNative',
  );
  @override
  late final GeneratedColumn<String> definitionNative = GeneratedColumn<String>(
    'definition_native',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioPathMeta = const VerificationMeta(
    'audioPath',
  );
  @override
  late final GeneratedColumn<String> audioPath = GeneratedColumn<String>(
    'audio_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _registerMeta = const VerificationMeta(
    'register',
  );
  @override
  late final GeneratedColumn<String> register = GeneratedColumn<String>(
    'register',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nuanceNoteMeta = const VerificationMeta(
    'nuanceNote',
  );
  @override
  late final GeneratedColumn<String> nuanceNote = GeneratedColumn<String>(
    'nuance_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userMnemonicMeta = const VerificationMeta(
    'userMnemonic',
  );
  @override
  late final GeneratedColumn<String> userMnemonic = GeneratedColumn<String>(
    'user_mnemonic',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userSentenceMeta = const VerificationMeta(
    'userSentence',
  );
  @override
  late final GeneratedColumn<String> userSentence = GeneratedColumn<String>(
    'user_sentence',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    lemma,
    pos,
    ipa,
    cefr,
    freqRank,
    definitionEn,
    definitionNative,
    audioPath,
    tags,
    register,
    nuanceNote,
    source,
    userMnemonic,
    userSentence,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'words';
  @override
  VerificationContext validateIntegrity(
    Insertable<Word> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('lemma')) {
      context.handle(
        _lemmaMeta,
        lemma.isAcceptableOrUnknown(data['lemma']!, _lemmaMeta),
      );
    } else if (isInserting) {
      context.missing(_lemmaMeta);
    }
    if (data.containsKey('pos')) {
      context.handle(
        _posMeta,
        pos.isAcceptableOrUnknown(data['pos']!, _posMeta),
      );
    }
    if (data.containsKey('ipa')) {
      context.handle(
        _ipaMeta,
        ipa.isAcceptableOrUnknown(data['ipa']!, _ipaMeta),
      );
    }
    if (data.containsKey('cefr')) {
      context.handle(
        _cefrMeta,
        cefr.isAcceptableOrUnknown(data['cefr']!, _cefrMeta),
      );
    }
    if (data.containsKey('freq_rank')) {
      context.handle(
        _freqRankMeta,
        freqRank.isAcceptableOrUnknown(data['freq_rank']!, _freqRankMeta),
      );
    }
    if (data.containsKey('definition_en')) {
      context.handle(
        _definitionEnMeta,
        definitionEn.isAcceptableOrUnknown(
          data['definition_en']!,
          _definitionEnMeta,
        ),
      );
    }
    if (data.containsKey('definition_native')) {
      context.handle(
        _definitionNativeMeta,
        definitionNative.isAcceptableOrUnknown(
          data['definition_native']!,
          _definitionNativeMeta,
        ),
      );
    }
    if (data.containsKey('audio_path')) {
      context.handle(
        _audioPathMeta,
        audioPath.isAcceptableOrUnknown(data['audio_path']!, _audioPathMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('register')) {
      context.handle(
        _registerMeta,
        register.isAcceptableOrUnknown(data['register']!, _registerMeta),
      );
    }
    if (data.containsKey('nuance_note')) {
      context.handle(
        _nuanceNoteMeta,
        nuanceNote.isAcceptableOrUnknown(data['nuance_note']!, _nuanceNoteMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('user_mnemonic')) {
      context.handle(
        _userMnemonicMeta,
        userMnemonic.isAcceptableOrUnknown(
          data['user_mnemonic']!,
          _userMnemonicMeta,
        ),
      );
    }
    if (data.containsKey('user_sentence')) {
      context.handle(
        _userSentenceMeta,
        userSentence.isAcceptableOrUnknown(
          data['user_sentence']!,
          _userSentenceMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Word map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Word(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      lemma:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}lemma'],
          )!,
      pos: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pos'],
      ),
      ipa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ipa'],
      ),
      cefr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cefr'],
      ),
      freqRank: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}freq_rank'],
      ),
      definitionEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}definition_en'],
      ),
      definitionNative: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}definition_native'],
      ),
      audioPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_path'],
      ),
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      ),
      register: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}register'],
      ),
      nuanceNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nuance_note'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      ),
      userMnemonic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_mnemonic'],
      ),
      userSentence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_sentence'],
      ),
    );
  }

  @override
  $WordsTable createAlias(String alias) {
    return $WordsTable(attachedDatabase, alias);
  }
}

class Word extends DataClass implements Insertable<Word> {
  final int id;
  final String lemma;
  final String? pos;
  final String? ipa;
  final String? cefr;
  final int? freqRank;
  final String? definitionEn;
  final String? definitionNative;
  final String? audioPath;
  final String? tags;
  final String? register;
  final String? nuanceNote;
  final String? source;
  final String? userMnemonic;
  final String? userSentence;
  const Word({
    required this.id,
    required this.lemma,
    this.pos,
    this.ipa,
    this.cefr,
    this.freqRank,
    this.definitionEn,
    this.definitionNative,
    this.audioPath,
    this.tags,
    this.register,
    this.nuanceNote,
    this.source,
    this.userMnemonic,
    this.userSentence,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['lemma'] = Variable<String>(lemma);
    if (!nullToAbsent || pos != null) {
      map['pos'] = Variable<String>(pos);
    }
    if (!nullToAbsent || ipa != null) {
      map['ipa'] = Variable<String>(ipa);
    }
    if (!nullToAbsent || cefr != null) {
      map['cefr'] = Variable<String>(cefr);
    }
    if (!nullToAbsent || freqRank != null) {
      map['freq_rank'] = Variable<int>(freqRank);
    }
    if (!nullToAbsent || definitionEn != null) {
      map['definition_en'] = Variable<String>(definitionEn);
    }
    if (!nullToAbsent || definitionNative != null) {
      map['definition_native'] = Variable<String>(definitionNative);
    }
    if (!nullToAbsent || audioPath != null) {
      map['audio_path'] = Variable<String>(audioPath);
    }
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    if (!nullToAbsent || register != null) {
      map['register'] = Variable<String>(register);
    }
    if (!nullToAbsent || nuanceNote != null) {
      map['nuance_note'] = Variable<String>(nuanceNote);
    }
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    if (!nullToAbsent || userMnemonic != null) {
      map['user_mnemonic'] = Variable<String>(userMnemonic);
    }
    if (!nullToAbsent || userSentence != null) {
      map['user_sentence'] = Variable<String>(userSentence);
    }
    return map;
  }

  WordsCompanion toCompanion(bool nullToAbsent) {
    return WordsCompanion(
      id: Value(id),
      lemma: Value(lemma),
      pos: pos == null && nullToAbsent ? const Value.absent() : Value(pos),
      ipa: ipa == null && nullToAbsent ? const Value.absent() : Value(ipa),
      cefr: cefr == null && nullToAbsent ? const Value.absent() : Value(cefr),
      freqRank:
          freqRank == null && nullToAbsent
              ? const Value.absent()
              : Value(freqRank),
      definitionEn:
          definitionEn == null && nullToAbsent
              ? const Value.absent()
              : Value(definitionEn),
      definitionNative:
          definitionNative == null && nullToAbsent
              ? const Value.absent()
              : Value(definitionNative),
      audioPath:
          audioPath == null && nullToAbsent
              ? const Value.absent()
              : Value(audioPath),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
      register:
          register == null && nullToAbsent
              ? const Value.absent()
              : Value(register),
      nuanceNote:
          nuanceNote == null && nullToAbsent
              ? const Value.absent()
              : Value(nuanceNote),
      source:
          source == null && nullToAbsent ? const Value.absent() : Value(source),
      userMnemonic:
          userMnemonic == null && nullToAbsent
              ? const Value.absent()
              : Value(userMnemonic),
      userSentence:
          userSentence == null && nullToAbsent
              ? const Value.absent()
              : Value(userSentence),
    );
  }

  factory Word.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Word(
      id: serializer.fromJson<int>(json['id']),
      lemma: serializer.fromJson<String>(json['lemma']),
      pos: serializer.fromJson<String?>(json['pos']),
      ipa: serializer.fromJson<String?>(json['ipa']),
      cefr: serializer.fromJson<String?>(json['cefr']),
      freqRank: serializer.fromJson<int?>(json['freqRank']),
      definitionEn: serializer.fromJson<String?>(json['definitionEn']),
      definitionNative: serializer.fromJson<String?>(json['definitionNative']),
      audioPath: serializer.fromJson<String?>(json['audioPath']),
      tags: serializer.fromJson<String?>(json['tags']),
      register: serializer.fromJson<String?>(json['register']),
      nuanceNote: serializer.fromJson<String?>(json['nuanceNote']),
      source: serializer.fromJson<String?>(json['source']),
      userMnemonic: serializer.fromJson<String?>(json['userMnemonic']),
      userSentence: serializer.fromJson<String?>(json['userSentence']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lemma': serializer.toJson<String>(lemma),
      'pos': serializer.toJson<String?>(pos),
      'ipa': serializer.toJson<String?>(ipa),
      'cefr': serializer.toJson<String?>(cefr),
      'freqRank': serializer.toJson<int?>(freqRank),
      'definitionEn': serializer.toJson<String?>(definitionEn),
      'definitionNative': serializer.toJson<String?>(definitionNative),
      'audioPath': serializer.toJson<String?>(audioPath),
      'tags': serializer.toJson<String?>(tags),
      'register': serializer.toJson<String?>(register),
      'nuanceNote': serializer.toJson<String?>(nuanceNote),
      'source': serializer.toJson<String?>(source),
      'userMnemonic': serializer.toJson<String?>(userMnemonic),
      'userSentence': serializer.toJson<String?>(userSentence),
    };
  }

  Word copyWith({
    int? id,
    String? lemma,
    Value<String?> pos = const Value.absent(),
    Value<String?> ipa = const Value.absent(),
    Value<String?> cefr = const Value.absent(),
    Value<int?> freqRank = const Value.absent(),
    Value<String?> definitionEn = const Value.absent(),
    Value<String?> definitionNative = const Value.absent(),
    Value<String?> audioPath = const Value.absent(),
    Value<String?> tags = const Value.absent(),
    Value<String?> register = const Value.absent(),
    Value<String?> nuanceNote = const Value.absent(),
    Value<String?> source = const Value.absent(),
    Value<String?> userMnemonic = const Value.absent(),
    Value<String?> userSentence = const Value.absent(),
  }) => Word(
    id: id ?? this.id,
    lemma: lemma ?? this.lemma,
    pos: pos.present ? pos.value : this.pos,
    ipa: ipa.present ? ipa.value : this.ipa,
    cefr: cefr.present ? cefr.value : this.cefr,
    freqRank: freqRank.present ? freqRank.value : this.freqRank,
    definitionEn: definitionEn.present ? definitionEn.value : this.definitionEn,
    definitionNative:
        definitionNative.present
            ? definitionNative.value
            : this.definitionNative,
    audioPath: audioPath.present ? audioPath.value : this.audioPath,
    tags: tags.present ? tags.value : this.tags,
    register: register.present ? register.value : this.register,
    nuanceNote: nuanceNote.present ? nuanceNote.value : this.nuanceNote,
    source: source.present ? source.value : this.source,
    userMnemonic: userMnemonic.present ? userMnemonic.value : this.userMnemonic,
    userSentence: userSentence.present ? userSentence.value : this.userSentence,
  );
  Word copyWithCompanion(WordsCompanion data) {
    return Word(
      id: data.id.present ? data.id.value : this.id,
      lemma: data.lemma.present ? data.lemma.value : this.lemma,
      pos: data.pos.present ? data.pos.value : this.pos,
      ipa: data.ipa.present ? data.ipa.value : this.ipa,
      cefr: data.cefr.present ? data.cefr.value : this.cefr,
      freqRank: data.freqRank.present ? data.freqRank.value : this.freqRank,
      definitionEn:
          data.definitionEn.present
              ? data.definitionEn.value
              : this.definitionEn,
      definitionNative:
          data.definitionNative.present
              ? data.definitionNative.value
              : this.definitionNative,
      audioPath: data.audioPath.present ? data.audioPath.value : this.audioPath,
      tags: data.tags.present ? data.tags.value : this.tags,
      register: data.register.present ? data.register.value : this.register,
      nuanceNote:
          data.nuanceNote.present ? data.nuanceNote.value : this.nuanceNote,
      source: data.source.present ? data.source.value : this.source,
      userMnemonic:
          data.userMnemonic.present
              ? data.userMnemonic.value
              : this.userMnemonic,
      userSentence:
          data.userSentence.present
              ? data.userSentence.value
              : this.userSentence,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Word(')
          ..write('id: $id, ')
          ..write('lemma: $lemma, ')
          ..write('pos: $pos, ')
          ..write('ipa: $ipa, ')
          ..write('cefr: $cefr, ')
          ..write('freqRank: $freqRank, ')
          ..write('definitionEn: $definitionEn, ')
          ..write('definitionNative: $definitionNative, ')
          ..write('audioPath: $audioPath, ')
          ..write('tags: $tags, ')
          ..write('register: $register, ')
          ..write('nuanceNote: $nuanceNote, ')
          ..write('source: $source, ')
          ..write('userMnemonic: $userMnemonic, ')
          ..write('userSentence: $userSentence')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    lemma,
    pos,
    ipa,
    cefr,
    freqRank,
    definitionEn,
    definitionNative,
    audioPath,
    tags,
    register,
    nuanceNote,
    source,
    userMnemonic,
    userSentence,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Word &&
          other.id == this.id &&
          other.lemma == this.lemma &&
          other.pos == this.pos &&
          other.ipa == this.ipa &&
          other.cefr == this.cefr &&
          other.freqRank == this.freqRank &&
          other.definitionEn == this.definitionEn &&
          other.definitionNative == this.definitionNative &&
          other.audioPath == this.audioPath &&
          other.tags == this.tags &&
          other.register == this.register &&
          other.nuanceNote == this.nuanceNote &&
          other.source == this.source &&
          other.userMnemonic == this.userMnemonic &&
          other.userSentence == this.userSentence);
}

class WordsCompanion extends UpdateCompanion<Word> {
  final Value<int> id;
  final Value<String> lemma;
  final Value<String?> pos;
  final Value<String?> ipa;
  final Value<String?> cefr;
  final Value<int?> freqRank;
  final Value<String?> definitionEn;
  final Value<String?> definitionNative;
  final Value<String?> audioPath;
  final Value<String?> tags;
  final Value<String?> register;
  final Value<String?> nuanceNote;
  final Value<String?> source;
  final Value<String?> userMnemonic;
  final Value<String?> userSentence;
  const WordsCompanion({
    this.id = const Value.absent(),
    this.lemma = const Value.absent(),
    this.pos = const Value.absent(),
    this.ipa = const Value.absent(),
    this.cefr = const Value.absent(),
    this.freqRank = const Value.absent(),
    this.definitionEn = const Value.absent(),
    this.definitionNative = const Value.absent(),
    this.audioPath = const Value.absent(),
    this.tags = const Value.absent(),
    this.register = const Value.absent(),
    this.nuanceNote = const Value.absent(),
    this.source = const Value.absent(),
    this.userMnemonic = const Value.absent(),
    this.userSentence = const Value.absent(),
  });
  WordsCompanion.insert({
    this.id = const Value.absent(),
    required String lemma,
    this.pos = const Value.absent(),
    this.ipa = const Value.absent(),
    this.cefr = const Value.absent(),
    this.freqRank = const Value.absent(),
    this.definitionEn = const Value.absent(),
    this.definitionNative = const Value.absent(),
    this.audioPath = const Value.absent(),
    this.tags = const Value.absent(),
    this.register = const Value.absent(),
    this.nuanceNote = const Value.absent(),
    this.source = const Value.absent(),
    this.userMnemonic = const Value.absent(),
    this.userSentence = const Value.absent(),
  }) : lemma = Value(lemma);
  static Insertable<Word> custom({
    Expression<int>? id,
    Expression<String>? lemma,
    Expression<String>? pos,
    Expression<String>? ipa,
    Expression<String>? cefr,
    Expression<int>? freqRank,
    Expression<String>? definitionEn,
    Expression<String>? definitionNative,
    Expression<String>? audioPath,
    Expression<String>? tags,
    Expression<String>? register,
    Expression<String>? nuanceNote,
    Expression<String>? source,
    Expression<String>? userMnemonic,
    Expression<String>? userSentence,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lemma != null) 'lemma': lemma,
      if (pos != null) 'pos': pos,
      if (ipa != null) 'ipa': ipa,
      if (cefr != null) 'cefr': cefr,
      if (freqRank != null) 'freq_rank': freqRank,
      if (definitionEn != null) 'definition_en': definitionEn,
      if (definitionNative != null) 'definition_native': definitionNative,
      if (audioPath != null) 'audio_path': audioPath,
      if (tags != null) 'tags': tags,
      if (register != null) 'register': register,
      if (nuanceNote != null) 'nuance_note': nuanceNote,
      if (source != null) 'source': source,
      if (userMnemonic != null) 'user_mnemonic': userMnemonic,
      if (userSentence != null) 'user_sentence': userSentence,
    });
  }

  WordsCompanion copyWith({
    Value<int>? id,
    Value<String>? lemma,
    Value<String?>? pos,
    Value<String?>? ipa,
    Value<String?>? cefr,
    Value<int?>? freqRank,
    Value<String?>? definitionEn,
    Value<String?>? definitionNative,
    Value<String?>? audioPath,
    Value<String?>? tags,
    Value<String?>? register,
    Value<String?>? nuanceNote,
    Value<String?>? source,
    Value<String?>? userMnemonic,
    Value<String?>? userSentence,
  }) {
    return WordsCompanion(
      id: id ?? this.id,
      lemma: lemma ?? this.lemma,
      pos: pos ?? this.pos,
      ipa: ipa ?? this.ipa,
      cefr: cefr ?? this.cefr,
      freqRank: freqRank ?? this.freqRank,
      definitionEn: definitionEn ?? this.definitionEn,
      definitionNative: definitionNative ?? this.definitionNative,
      audioPath: audioPath ?? this.audioPath,
      tags: tags ?? this.tags,
      register: register ?? this.register,
      nuanceNote: nuanceNote ?? this.nuanceNote,
      source: source ?? this.source,
      userMnemonic: userMnemonic ?? this.userMnemonic,
      userSentence: userSentence ?? this.userSentence,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lemma.present) {
      map['lemma'] = Variable<String>(lemma.value);
    }
    if (pos.present) {
      map['pos'] = Variable<String>(pos.value);
    }
    if (ipa.present) {
      map['ipa'] = Variable<String>(ipa.value);
    }
    if (cefr.present) {
      map['cefr'] = Variable<String>(cefr.value);
    }
    if (freqRank.present) {
      map['freq_rank'] = Variable<int>(freqRank.value);
    }
    if (definitionEn.present) {
      map['definition_en'] = Variable<String>(definitionEn.value);
    }
    if (definitionNative.present) {
      map['definition_native'] = Variable<String>(definitionNative.value);
    }
    if (audioPath.present) {
      map['audio_path'] = Variable<String>(audioPath.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (register.present) {
      map['register'] = Variable<String>(register.value);
    }
    if (nuanceNote.present) {
      map['nuance_note'] = Variable<String>(nuanceNote.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (userMnemonic.present) {
      map['user_mnemonic'] = Variable<String>(userMnemonic.value);
    }
    if (userSentence.present) {
      map['user_sentence'] = Variable<String>(userSentence.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WordsCompanion(')
          ..write('id: $id, ')
          ..write('lemma: $lemma, ')
          ..write('pos: $pos, ')
          ..write('ipa: $ipa, ')
          ..write('cefr: $cefr, ')
          ..write('freqRank: $freqRank, ')
          ..write('definitionEn: $definitionEn, ')
          ..write('definitionNative: $definitionNative, ')
          ..write('audioPath: $audioPath, ')
          ..write('tags: $tags, ')
          ..write('register: $register, ')
          ..write('nuanceNote: $nuanceNote, ')
          ..write('source: $source, ')
          ..write('userMnemonic: $userMnemonic, ')
          ..write('userSentence: $userSentence')
          ..write(')'))
        .toString();
  }
}

class $ExamplesTable extends Examples with TableInfo<$ExamplesTable, Example> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExamplesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<int> wordId = GeneratedColumn<int>(
    'word_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES words (id)',
    ),
  );
  static const VerificationMeta _sentenceMeta = const VerificationMeta(
    'sentence',
  );
  @override
  late final GeneratedColumn<String> sentence = GeneratedColumn<String>(
    'sentence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _translationMeta = const VerificationMeta(
    'translation',
  );
  @override
  late final GeneratedColumn<String> translation = GeneratedColumn<String>(
    'translation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioPathMeta = const VerificationMeta(
    'audioPath',
  );
  @override
  late final GeneratedColumn<String> audioPath = GeneratedColumn<String>(
    'audio_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    wordId,
    sentence,
    translation,
    audioPath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'examples';
  @override
  VerificationContext validateIntegrity(
    Insertable<Example> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('word_id')) {
      context.handle(
        _wordIdMeta,
        wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('sentence')) {
      context.handle(
        _sentenceMeta,
        sentence.isAcceptableOrUnknown(data['sentence']!, _sentenceMeta),
      );
    } else if (isInserting) {
      context.missing(_sentenceMeta);
    }
    if (data.containsKey('translation')) {
      context.handle(
        _translationMeta,
        translation.isAcceptableOrUnknown(
          data['translation']!,
          _translationMeta,
        ),
      );
    }
    if (data.containsKey('audio_path')) {
      context.handle(
        _audioPathMeta,
        audioPath.isAcceptableOrUnknown(data['audio_path']!, _audioPathMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Example map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Example(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      wordId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}word_id'],
          )!,
      sentence:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}sentence'],
          )!,
      translation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation'],
      ),
      audioPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_path'],
      ),
    );
  }

  @override
  $ExamplesTable createAlias(String alias) {
    return $ExamplesTable(attachedDatabase, alias);
  }
}

class Example extends DataClass implements Insertable<Example> {
  final int id;
  final int wordId;
  final String sentence;
  final String? translation;
  final String? audioPath;
  const Example({
    required this.id,
    required this.wordId,
    required this.sentence,
    this.translation,
    this.audioPath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['word_id'] = Variable<int>(wordId);
    map['sentence'] = Variable<String>(sentence);
    if (!nullToAbsent || translation != null) {
      map['translation'] = Variable<String>(translation);
    }
    if (!nullToAbsent || audioPath != null) {
      map['audio_path'] = Variable<String>(audioPath);
    }
    return map;
  }

  ExamplesCompanion toCompanion(bool nullToAbsent) {
    return ExamplesCompanion(
      id: Value(id),
      wordId: Value(wordId),
      sentence: Value(sentence),
      translation:
          translation == null && nullToAbsent
              ? const Value.absent()
              : Value(translation),
      audioPath:
          audioPath == null && nullToAbsent
              ? const Value.absent()
              : Value(audioPath),
    );
  }

  factory Example.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Example(
      id: serializer.fromJson<int>(json['id']),
      wordId: serializer.fromJson<int>(json['wordId']),
      sentence: serializer.fromJson<String>(json['sentence']),
      translation: serializer.fromJson<String?>(json['translation']),
      audioPath: serializer.fromJson<String?>(json['audioPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'wordId': serializer.toJson<int>(wordId),
      'sentence': serializer.toJson<String>(sentence),
      'translation': serializer.toJson<String?>(translation),
      'audioPath': serializer.toJson<String?>(audioPath),
    };
  }

  Example copyWith({
    int? id,
    int? wordId,
    String? sentence,
    Value<String?> translation = const Value.absent(),
    Value<String?> audioPath = const Value.absent(),
  }) => Example(
    id: id ?? this.id,
    wordId: wordId ?? this.wordId,
    sentence: sentence ?? this.sentence,
    translation: translation.present ? translation.value : this.translation,
    audioPath: audioPath.present ? audioPath.value : this.audioPath,
  );
  Example copyWithCompanion(ExamplesCompanion data) {
    return Example(
      id: data.id.present ? data.id.value : this.id,
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      sentence: data.sentence.present ? data.sentence.value : this.sentence,
      translation:
          data.translation.present ? data.translation.value : this.translation,
      audioPath: data.audioPath.present ? data.audioPath.value : this.audioPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Example(')
          ..write('id: $id, ')
          ..write('wordId: $wordId, ')
          ..write('sentence: $sentence, ')
          ..write('translation: $translation, ')
          ..write('audioPath: $audioPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, wordId, sentence, translation, audioPath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Example &&
          other.id == this.id &&
          other.wordId == this.wordId &&
          other.sentence == this.sentence &&
          other.translation == this.translation &&
          other.audioPath == this.audioPath);
}

class ExamplesCompanion extends UpdateCompanion<Example> {
  final Value<int> id;
  final Value<int> wordId;
  final Value<String> sentence;
  final Value<String?> translation;
  final Value<String?> audioPath;
  const ExamplesCompanion({
    this.id = const Value.absent(),
    this.wordId = const Value.absent(),
    this.sentence = const Value.absent(),
    this.translation = const Value.absent(),
    this.audioPath = const Value.absent(),
  });
  ExamplesCompanion.insert({
    this.id = const Value.absent(),
    required int wordId,
    required String sentence,
    this.translation = const Value.absent(),
    this.audioPath = const Value.absent(),
  }) : wordId = Value(wordId),
       sentence = Value(sentence);
  static Insertable<Example> custom({
    Expression<int>? id,
    Expression<int>? wordId,
    Expression<String>? sentence,
    Expression<String>? translation,
    Expression<String>? audioPath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (wordId != null) 'word_id': wordId,
      if (sentence != null) 'sentence': sentence,
      if (translation != null) 'translation': translation,
      if (audioPath != null) 'audio_path': audioPath,
    });
  }

  ExamplesCompanion copyWith({
    Value<int>? id,
    Value<int>? wordId,
    Value<String>? sentence,
    Value<String?>? translation,
    Value<String?>? audioPath,
  }) {
    return ExamplesCompanion(
      id: id ?? this.id,
      wordId: wordId ?? this.wordId,
      sentence: sentence ?? this.sentence,
      translation: translation ?? this.translation,
      audioPath: audioPath ?? this.audioPath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (wordId.present) {
      map['word_id'] = Variable<int>(wordId.value);
    }
    if (sentence.present) {
      map['sentence'] = Variable<String>(sentence.value);
    }
    if (translation.present) {
      map['translation'] = Variable<String>(translation.value);
    }
    if (audioPath.present) {
      map['audio_path'] = Variable<String>(audioPath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExamplesCompanion(')
          ..write('id: $id, ')
          ..write('wordId: $wordId, ')
          ..write('sentence: $sentence, ')
          ..write('translation: $translation, ')
          ..write('audioPath: $audioPath')
          ..write(')'))
        .toString();
  }
}

class $WordFamiliesTable extends WordFamilies
    with TableInfo<$WordFamiliesTable, WordFamily> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WordFamiliesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _rootMeta = const VerificationMeta('root');
  @override
  late final GeneratedColumn<String> root = GeneratedColumn<String>(
    'root',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memberWordIdMeta = const VerificationMeta(
    'memberWordId',
  );
  @override
  late final GeneratedColumn<int> memberWordId = GeneratedColumn<int>(
    'member_word_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES words (id)',
    ),
  );
  static const VerificationMeta _formTypeMeta = const VerificationMeta(
    'formType',
  );
  @override
  late final GeneratedColumn<String> formType = GeneratedColumn<String>(
    'form_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, root, memberWordId, formType];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'word_families';
  @override
  VerificationContext validateIntegrity(
    Insertable<WordFamily> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('root')) {
      context.handle(
        _rootMeta,
        root.isAcceptableOrUnknown(data['root']!, _rootMeta),
      );
    } else if (isInserting) {
      context.missing(_rootMeta);
    }
    if (data.containsKey('member_word_id')) {
      context.handle(
        _memberWordIdMeta,
        memberWordId.isAcceptableOrUnknown(
          data['member_word_id']!,
          _memberWordIdMeta,
        ),
      );
    }
    if (data.containsKey('form_type')) {
      context.handle(
        _formTypeMeta,
        formType.isAcceptableOrUnknown(data['form_type']!, _formTypeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WordFamily map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WordFamily(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      root:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}root'],
          )!,
      memberWordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}member_word_id'],
      ),
      formType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}form_type'],
      ),
    );
  }

  @override
  $WordFamiliesTable createAlias(String alias) {
    return $WordFamiliesTable(attachedDatabase, alias);
  }
}

class WordFamily extends DataClass implements Insertable<WordFamily> {
  final int id;
  final String root;
  final int? memberWordId;
  final String? formType;
  const WordFamily({
    required this.id,
    required this.root,
    this.memberWordId,
    this.formType,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['root'] = Variable<String>(root);
    if (!nullToAbsent || memberWordId != null) {
      map['member_word_id'] = Variable<int>(memberWordId);
    }
    if (!nullToAbsent || formType != null) {
      map['form_type'] = Variable<String>(formType);
    }
    return map;
  }

  WordFamiliesCompanion toCompanion(bool nullToAbsent) {
    return WordFamiliesCompanion(
      id: Value(id),
      root: Value(root),
      memberWordId:
          memberWordId == null && nullToAbsent
              ? const Value.absent()
              : Value(memberWordId),
      formType:
          formType == null && nullToAbsent
              ? const Value.absent()
              : Value(formType),
    );
  }

  factory WordFamily.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WordFamily(
      id: serializer.fromJson<int>(json['id']),
      root: serializer.fromJson<String>(json['root']),
      memberWordId: serializer.fromJson<int?>(json['memberWordId']),
      formType: serializer.fromJson<String?>(json['formType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'root': serializer.toJson<String>(root),
      'memberWordId': serializer.toJson<int?>(memberWordId),
      'formType': serializer.toJson<String?>(formType),
    };
  }

  WordFamily copyWith({
    int? id,
    String? root,
    Value<int?> memberWordId = const Value.absent(),
    Value<String?> formType = const Value.absent(),
  }) => WordFamily(
    id: id ?? this.id,
    root: root ?? this.root,
    memberWordId: memberWordId.present ? memberWordId.value : this.memberWordId,
    formType: formType.present ? formType.value : this.formType,
  );
  WordFamily copyWithCompanion(WordFamiliesCompanion data) {
    return WordFamily(
      id: data.id.present ? data.id.value : this.id,
      root: data.root.present ? data.root.value : this.root,
      memberWordId:
          data.memberWordId.present
              ? data.memberWordId.value
              : this.memberWordId,
      formType: data.formType.present ? data.formType.value : this.formType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WordFamily(')
          ..write('id: $id, ')
          ..write('root: $root, ')
          ..write('memberWordId: $memberWordId, ')
          ..write('formType: $formType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, root, memberWordId, formType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WordFamily &&
          other.id == this.id &&
          other.root == this.root &&
          other.memberWordId == this.memberWordId &&
          other.formType == this.formType);
}

class WordFamiliesCompanion extends UpdateCompanion<WordFamily> {
  final Value<int> id;
  final Value<String> root;
  final Value<int?> memberWordId;
  final Value<String?> formType;
  const WordFamiliesCompanion({
    this.id = const Value.absent(),
    this.root = const Value.absent(),
    this.memberWordId = const Value.absent(),
    this.formType = const Value.absent(),
  });
  WordFamiliesCompanion.insert({
    this.id = const Value.absent(),
    required String root,
    this.memberWordId = const Value.absent(),
    this.formType = const Value.absent(),
  }) : root = Value(root);
  static Insertable<WordFamily> custom({
    Expression<int>? id,
    Expression<String>? root,
    Expression<int>? memberWordId,
    Expression<String>? formType,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (root != null) 'root': root,
      if (memberWordId != null) 'member_word_id': memberWordId,
      if (formType != null) 'form_type': formType,
    });
  }

  WordFamiliesCompanion copyWith({
    Value<int>? id,
    Value<String>? root,
    Value<int?>? memberWordId,
    Value<String?>? formType,
  }) {
    return WordFamiliesCompanion(
      id: id ?? this.id,
      root: root ?? this.root,
      memberWordId: memberWordId ?? this.memberWordId,
      formType: formType ?? this.formType,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (root.present) {
      map['root'] = Variable<String>(root.value);
    }
    if (memberWordId.present) {
      map['member_word_id'] = Variable<int>(memberWordId.value);
    }
    if (formType.present) {
      map['form_type'] = Variable<String>(formType.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WordFamiliesCompanion(')
          ..write('id: $id, ')
          ..write('root: $root, ')
          ..write('memberWordId: $memberWordId, ')
          ..write('formType: $formType')
          ..write(')'))
        .toString();
  }
}

class $CollocationsTable extends Collocations
    with TableInfo<$CollocationsTable, Collocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CollocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<int> wordId = GeneratedColumn<int>(
    'word_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES words (id)',
    ),
  );
  static const VerificationMeta _phraseMeta = const VerificationMeta('phrase');
  @override
  late final GeneratedColumn<String> phrase = GeneratedColumn<String>(
    'phrase',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _registerMeta = const VerificationMeta(
    'register',
  );
  @override
  late final GeneratedColumn<String> register = GeneratedColumn<String>(
    'register',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, wordId, phrase, register];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'collocations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Collocation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('word_id')) {
      context.handle(
        _wordIdMeta,
        wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('phrase')) {
      context.handle(
        _phraseMeta,
        phrase.isAcceptableOrUnknown(data['phrase']!, _phraseMeta),
      );
    } else if (isInserting) {
      context.missing(_phraseMeta);
    }
    if (data.containsKey('register')) {
      context.handle(
        _registerMeta,
        register.isAcceptableOrUnknown(data['register']!, _registerMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Collocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Collocation(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      wordId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}word_id'],
          )!,
      phrase:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}phrase'],
          )!,
      register: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}register'],
      ),
    );
  }

  @override
  $CollocationsTable createAlias(String alias) {
    return $CollocationsTable(attachedDatabase, alias);
  }
}

class Collocation extends DataClass implements Insertable<Collocation> {
  final int id;
  final int wordId;
  final String phrase;
  final String? register;
  const Collocation({
    required this.id,
    required this.wordId,
    required this.phrase,
    this.register,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['word_id'] = Variable<int>(wordId);
    map['phrase'] = Variable<String>(phrase);
    if (!nullToAbsent || register != null) {
      map['register'] = Variable<String>(register);
    }
    return map;
  }

  CollocationsCompanion toCompanion(bool nullToAbsent) {
    return CollocationsCompanion(
      id: Value(id),
      wordId: Value(wordId),
      phrase: Value(phrase),
      register:
          register == null && nullToAbsent
              ? const Value.absent()
              : Value(register),
    );
  }

  factory Collocation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Collocation(
      id: serializer.fromJson<int>(json['id']),
      wordId: serializer.fromJson<int>(json['wordId']),
      phrase: serializer.fromJson<String>(json['phrase']),
      register: serializer.fromJson<String?>(json['register']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'wordId': serializer.toJson<int>(wordId),
      'phrase': serializer.toJson<String>(phrase),
      'register': serializer.toJson<String?>(register),
    };
  }

  Collocation copyWith({
    int? id,
    int? wordId,
    String? phrase,
    Value<String?> register = const Value.absent(),
  }) => Collocation(
    id: id ?? this.id,
    wordId: wordId ?? this.wordId,
    phrase: phrase ?? this.phrase,
    register: register.present ? register.value : this.register,
  );
  Collocation copyWithCompanion(CollocationsCompanion data) {
    return Collocation(
      id: data.id.present ? data.id.value : this.id,
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      phrase: data.phrase.present ? data.phrase.value : this.phrase,
      register: data.register.present ? data.register.value : this.register,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Collocation(')
          ..write('id: $id, ')
          ..write('wordId: $wordId, ')
          ..write('phrase: $phrase, ')
          ..write('register: $register')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, wordId, phrase, register);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Collocation &&
          other.id == this.id &&
          other.wordId == this.wordId &&
          other.phrase == this.phrase &&
          other.register == this.register);
}

class CollocationsCompanion extends UpdateCompanion<Collocation> {
  final Value<int> id;
  final Value<int> wordId;
  final Value<String> phrase;
  final Value<String?> register;
  const CollocationsCompanion({
    this.id = const Value.absent(),
    this.wordId = const Value.absent(),
    this.phrase = const Value.absent(),
    this.register = const Value.absent(),
  });
  CollocationsCompanion.insert({
    this.id = const Value.absent(),
    required int wordId,
    required String phrase,
    this.register = const Value.absent(),
  }) : wordId = Value(wordId),
       phrase = Value(phrase);
  static Insertable<Collocation> custom({
    Expression<int>? id,
    Expression<int>? wordId,
    Expression<String>? phrase,
    Expression<String>? register,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (wordId != null) 'word_id': wordId,
      if (phrase != null) 'phrase': phrase,
      if (register != null) 'register': register,
    });
  }

  CollocationsCompanion copyWith({
    Value<int>? id,
    Value<int>? wordId,
    Value<String>? phrase,
    Value<String?>? register,
  }) {
    return CollocationsCompanion(
      id: id ?? this.id,
      wordId: wordId ?? this.wordId,
      phrase: phrase ?? this.phrase,
      register: register ?? this.register,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (wordId.present) {
      map['word_id'] = Variable<int>(wordId.value);
    }
    if (phrase.present) {
      map['phrase'] = Variable<String>(phrase.value);
    }
    if (register.present) {
      map['register'] = Variable<String>(register.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CollocationsCompanion(')
          ..write('id: $id, ')
          ..write('wordId: $wordId, ')
          ..write('phrase: $phrase, ')
          ..write('register: $register')
          ..write(')'))
        .toString();
  }
}

class $SrsCardsTable extends SrsCards with TableInfo<$SrsCardsTable, SrsCard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SrsCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _itemTypeMeta = const VerificationMeta(
    'itemType',
  );
  @override
  late final GeneratedColumn<String> itemType = GeneratedColumn<String>(
    'item_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _skillMeta = const VerificationMeta('skill');
  @override
  late final GeneratedColumn<String> skill = GeneratedColumn<String>(
    'skill',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _easeMeta = const VerificationMeta('ease');
  @override
  late final GeneratedColumn<double> ease = GeneratedColumn<double>(
    'ease',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(2.5),
  );
  static const VerificationMeta _intervalDaysMeta = const VerificationMeta(
    'intervalDays',
  );
  @override
  late final GeneratedColumn<int> intervalDays = GeneratedColumn<int>(
    'interval_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _repetitionsMeta = const VerificationMeta(
    'repetitions',
  );
  @override
  late final GeneratedColumn<int> repetitions = GeneratedColumn<int>(
    'repetitions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lapsesMeta = const VerificationMeta('lapses');
  @override
  late final GeneratedColumn<int> lapses = GeneratedColumn<int>(
    'lapses',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<int> dueAt = GeneratedColumn<int>(
    'due_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastReviewedAtMeta = const VerificationMeta(
    'lastReviewedAt',
  );
  @override
  late final GeneratedColumn<int> lastReviewedAt = GeneratedColumn<int>(
    'last_reviewed_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    itemType,
    itemId,
    skill,
    ease,
    intervalDays,
    repetitions,
    lapses,
    dueAt,
    lastReviewedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'srs_cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<SrsCard> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item_type')) {
      context.handle(
        _itemTypeMeta,
        itemType.isAcceptableOrUnknown(data['item_type']!, _itemTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_itemTypeMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('skill')) {
      context.handle(
        _skillMeta,
        skill.isAcceptableOrUnknown(data['skill']!, _skillMeta),
      );
    } else if (isInserting) {
      context.missing(_skillMeta);
    }
    if (data.containsKey('ease')) {
      context.handle(
        _easeMeta,
        ease.isAcceptableOrUnknown(data['ease']!, _easeMeta),
      );
    }
    if (data.containsKey('interval_days')) {
      context.handle(
        _intervalDaysMeta,
        intervalDays.isAcceptableOrUnknown(
          data['interval_days']!,
          _intervalDaysMeta,
        ),
      );
    }
    if (data.containsKey('repetitions')) {
      context.handle(
        _repetitionsMeta,
        repetitions.isAcceptableOrUnknown(
          data['repetitions']!,
          _repetitionsMeta,
        ),
      );
    }
    if (data.containsKey('lapses')) {
      context.handle(
        _lapsesMeta,
        lapses.isAcceptableOrUnknown(data['lapses']!, _lapsesMeta),
      );
    }
    if (data.containsKey('due_at')) {
      context.handle(
        _dueAtMeta,
        dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta),
      );
    } else if (isInserting) {
      context.missing(_dueAtMeta);
    }
    if (data.containsKey('last_reviewed_at')) {
      context.handle(
        _lastReviewedAtMeta,
        lastReviewedAt.isAcceptableOrUnknown(
          data['last_reviewed_at']!,
          _lastReviewedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SrsCard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SrsCard(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      itemType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}item_type'],
          )!,
      itemId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}item_id'],
          )!,
      skill:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}skill'],
          )!,
      ease:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}ease'],
          )!,
      intervalDays:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}interval_days'],
          )!,
      repetitions:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}repetitions'],
          )!,
      lapses:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}lapses'],
          )!,
      dueAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}due_at'],
          )!,
      lastReviewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_reviewed_at'],
      ),
    );
  }

  @override
  $SrsCardsTable createAlias(String alias) {
    return $SrsCardsTable(attachedDatabase, alias);
  }
}

class SrsCard extends DataClass implements Insertable<SrsCard> {
  final int id;
  final String itemType;
  final int itemId;
  final String skill;
  final double ease;
  final int intervalDays;
  final int repetitions;
  final int lapses;
  final int dueAt;
  final int? lastReviewedAt;
  const SrsCard({
    required this.id,
    required this.itemType,
    required this.itemId,
    required this.skill,
    required this.ease,
    required this.intervalDays,
    required this.repetitions,
    required this.lapses,
    required this.dueAt,
    this.lastReviewedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['item_type'] = Variable<String>(itemType);
    map['item_id'] = Variable<int>(itemId);
    map['skill'] = Variable<String>(skill);
    map['ease'] = Variable<double>(ease);
    map['interval_days'] = Variable<int>(intervalDays);
    map['repetitions'] = Variable<int>(repetitions);
    map['lapses'] = Variable<int>(lapses);
    map['due_at'] = Variable<int>(dueAt);
    if (!nullToAbsent || lastReviewedAt != null) {
      map['last_reviewed_at'] = Variable<int>(lastReviewedAt);
    }
    return map;
  }

  SrsCardsCompanion toCompanion(bool nullToAbsent) {
    return SrsCardsCompanion(
      id: Value(id),
      itemType: Value(itemType),
      itemId: Value(itemId),
      skill: Value(skill),
      ease: Value(ease),
      intervalDays: Value(intervalDays),
      repetitions: Value(repetitions),
      lapses: Value(lapses),
      dueAt: Value(dueAt),
      lastReviewedAt:
          lastReviewedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(lastReviewedAt),
    );
  }

  factory SrsCard.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SrsCard(
      id: serializer.fromJson<int>(json['id']),
      itemType: serializer.fromJson<String>(json['itemType']),
      itemId: serializer.fromJson<int>(json['itemId']),
      skill: serializer.fromJson<String>(json['skill']),
      ease: serializer.fromJson<double>(json['ease']),
      intervalDays: serializer.fromJson<int>(json['intervalDays']),
      repetitions: serializer.fromJson<int>(json['repetitions']),
      lapses: serializer.fromJson<int>(json['lapses']),
      dueAt: serializer.fromJson<int>(json['dueAt']),
      lastReviewedAt: serializer.fromJson<int?>(json['lastReviewedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'itemType': serializer.toJson<String>(itemType),
      'itemId': serializer.toJson<int>(itemId),
      'skill': serializer.toJson<String>(skill),
      'ease': serializer.toJson<double>(ease),
      'intervalDays': serializer.toJson<int>(intervalDays),
      'repetitions': serializer.toJson<int>(repetitions),
      'lapses': serializer.toJson<int>(lapses),
      'dueAt': serializer.toJson<int>(dueAt),
      'lastReviewedAt': serializer.toJson<int?>(lastReviewedAt),
    };
  }

  SrsCard copyWith({
    int? id,
    String? itemType,
    int? itemId,
    String? skill,
    double? ease,
    int? intervalDays,
    int? repetitions,
    int? lapses,
    int? dueAt,
    Value<int?> lastReviewedAt = const Value.absent(),
  }) => SrsCard(
    id: id ?? this.id,
    itemType: itemType ?? this.itemType,
    itemId: itemId ?? this.itemId,
    skill: skill ?? this.skill,
    ease: ease ?? this.ease,
    intervalDays: intervalDays ?? this.intervalDays,
    repetitions: repetitions ?? this.repetitions,
    lapses: lapses ?? this.lapses,
    dueAt: dueAt ?? this.dueAt,
    lastReviewedAt:
        lastReviewedAt.present ? lastReviewedAt.value : this.lastReviewedAt,
  );
  SrsCard copyWithCompanion(SrsCardsCompanion data) {
    return SrsCard(
      id: data.id.present ? data.id.value : this.id,
      itemType: data.itemType.present ? data.itemType.value : this.itemType,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      skill: data.skill.present ? data.skill.value : this.skill,
      ease: data.ease.present ? data.ease.value : this.ease,
      intervalDays:
          data.intervalDays.present
              ? data.intervalDays.value
              : this.intervalDays,
      repetitions:
          data.repetitions.present ? data.repetitions.value : this.repetitions,
      lapses: data.lapses.present ? data.lapses.value : this.lapses,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      lastReviewedAt:
          data.lastReviewedAt.present
              ? data.lastReviewedAt.value
              : this.lastReviewedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SrsCard(')
          ..write('id: $id, ')
          ..write('itemType: $itemType, ')
          ..write('itemId: $itemId, ')
          ..write('skill: $skill, ')
          ..write('ease: $ease, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('repetitions: $repetitions, ')
          ..write('lapses: $lapses, ')
          ..write('dueAt: $dueAt, ')
          ..write('lastReviewedAt: $lastReviewedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    itemType,
    itemId,
    skill,
    ease,
    intervalDays,
    repetitions,
    lapses,
    dueAt,
    lastReviewedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SrsCard &&
          other.id == this.id &&
          other.itemType == this.itemType &&
          other.itemId == this.itemId &&
          other.skill == this.skill &&
          other.ease == this.ease &&
          other.intervalDays == this.intervalDays &&
          other.repetitions == this.repetitions &&
          other.lapses == this.lapses &&
          other.dueAt == this.dueAt &&
          other.lastReviewedAt == this.lastReviewedAt);
}

class SrsCardsCompanion extends UpdateCompanion<SrsCard> {
  final Value<int> id;
  final Value<String> itemType;
  final Value<int> itemId;
  final Value<String> skill;
  final Value<double> ease;
  final Value<int> intervalDays;
  final Value<int> repetitions;
  final Value<int> lapses;
  final Value<int> dueAt;
  final Value<int?> lastReviewedAt;
  const SrsCardsCompanion({
    this.id = const Value.absent(),
    this.itemType = const Value.absent(),
    this.itemId = const Value.absent(),
    this.skill = const Value.absent(),
    this.ease = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.lapses = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
  });
  SrsCardsCompanion.insert({
    this.id = const Value.absent(),
    required String itemType,
    required int itemId,
    required String skill,
    this.ease = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.lapses = const Value.absent(),
    required int dueAt,
    this.lastReviewedAt = const Value.absent(),
  }) : itemType = Value(itemType),
       itemId = Value(itemId),
       skill = Value(skill),
       dueAt = Value(dueAt);
  static Insertable<SrsCard> custom({
    Expression<int>? id,
    Expression<String>? itemType,
    Expression<int>? itemId,
    Expression<String>? skill,
    Expression<double>? ease,
    Expression<int>? intervalDays,
    Expression<int>? repetitions,
    Expression<int>? lapses,
    Expression<int>? dueAt,
    Expression<int>? lastReviewedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemType != null) 'item_type': itemType,
      if (itemId != null) 'item_id': itemId,
      if (skill != null) 'skill': skill,
      if (ease != null) 'ease': ease,
      if (intervalDays != null) 'interval_days': intervalDays,
      if (repetitions != null) 'repetitions': repetitions,
      if (lapses != null) 'lapses': lapses,
      if (dueAt != null) 'due_at': dueAt,
      if (lastReviewedAt != null) 'last_reviewed_at': lastReviewedAt,
    });
  }

  SrsCardsCompanion copyWith({
    Value<int>? id,
    Value<String>? itemType,
    Value<int>? itemId,
    Value<String>? skill,
    Value<double>? ease,
    Value<int>? intervalDays,
    Value<int>? repetitions,
    Value<int>? lapses,
    Value<int>? dueAt,
    Value<int?>? lastReviewedAt,
  }) {
    return SrsCardsCompanion(
      id: id ?? this.id,
      itemType: itemType ?? this.itemType,
      itemId: itemId ?? this.itemId,
      skill: skill ?? this.skill,
      ease: ease ?? this.ease,
      intervalDays: intervalDays ?? this.intervalDays,
      repetitions: repetitions ?? this.repetitions,
      lapses: lapses ?? this.lapses,
      dueAt: dueAt ?? this.dueAt,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (itemType.present) {
      map['item_type'] = Variable<String>(itemType.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (skill.present) {
      map['skill'] = Variable<String>(skill.value);
    }
    if (ease.present) {
      map['ease'] = Variable<double>(ease.value);
    }
    if (intervalDays.present) {
      map['interval_days'] = Variable<int>(intervalDays.value);
    }
    if (repetitions.present) {
      map['repetitions'] = Variable<int>(repetitions.value);
    }
    if (lapses.present) {
      map['lapses'] = Variable<int>(lapses.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<int>(dueAt.value);
    }
    if (lastReviewedAt.present) {
      map['last_reviewed_at'] = Variable<int>(lastReviewedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SrsCardsCompanion(')
          ..write('id: $id, ')
          ..write('itemType: $itemType, ')
          ..write('itemId: $itemId, ')
          ..write('skill: $skill, ')
          ..write('ease: $ease, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('repetitions: $repetitions, ')
          ..write('lapses: $lapses, ')
          ..write('dueAt: $dueAt, ')
          ..write('lastReviewedAt: $lastReviewedAt')
          ..write(')'))
        .toString();
  }
}

class $ReviewLogsTable extends ReviewLogs
    with TableInfo<$ReviewLogsTable, ReviewLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<int> cardId = GeneratedColumn<int>(
    'card_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES srs_cards (id)',
    ),
  );
  static const VerificationMeta _gameMeta = const VerificationMeta('game');
  @override
  late final GeneratedColumn<String> game = GeneratedColumn<String>(
    'game',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correctMeta = const VerificationMeta(
    'correct',
  );
  @override
  late final GeneratedColumn<int> correct = GeneratedColumn<int>(
    'correct',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _responseMsMeta = const VerificationMeta(
    'responseMs',
  );
  @override
  late final GeneratedColumn<int> responseMs = GeneratedColumn<int>(
    'response_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qualityMeta = const VerificationMeta(
    'quality',
  );
  @override
  late final GeneratedColumn<int> quality = GeneratedColumn<int>(
    'quality',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reviewedAtMeta = const VerificationMeta(
    'reviewedAt',
  );
  @override
  late final GeneratedColumn<int> reviewedAt = GeneratedColumn<int>(
    'reviewed_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cardId,
    game,
    correct,
    responseMs,
    quality,
    reviewedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'review_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReviewLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    }
    if (data.containsKey('game')) {
      context.handle(
        _gameMeta,
        game.isAcceptableOrUnknown(data['game']!, _gameMeta),
      );
    } else if (isInserting) {
      context.missing(_gameMeta);
    }
    if (data.containsKey('correct')) {
      context.handle(
        _correctMeta,
        correct.isAcceptableOrUnknown(data['correct']!, _correctMeta),
      );
    } else if (isInserting) {
      context.missing(_correctMeta);
    }
    if (data.containsKey('response_ms')) {
      context.handle(
        _responseMsMeta,
        responseMs.isAcceptableOrUnknown(data['response_ms']!, _responseMsMeta),
      );
    } else if (isInserting) {
      context.missing(_responseMsMeta);
    }
    if (data.containsKey('quality')) {
      context.handle(
        _qualityMeta,
        quality.isAcceptableOrUnknown(data['quality']!, _qualityMeta),
      );
    } else if (isInserting) {
      context.missing(_qualityMeta);
    }
    if (data.containsKey('reviewed_at')) {
      context.handle(
        _reviewedAtMeta,
        reviewedAt.isAcceptableOrUnknown(data['reviewed_at']!, _reviewedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_reviewedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReviewLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReviewLog(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}card_id'],
      ),
      game:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}game'],
          )!,
      correct:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}correct'],
          )!,
      responseMs:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}response_ms'],
          )!,
      quality:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}quality'],
          )!,
      reviewedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}reviewed_at'],
          )!,
    );
  }

  @override
  $ReviewLogsTable createAlias(String alias) {
    return $ReviewLogsTable(attachedDatabase, alias);
  }
}

class ReviewLog extends DataClass implements Insertable<ReviewLog> {
  final int id;
  final int? cardId;
  final String game;
  final int correct;
  final int responseMs;
  final int quality;
  final int reviewedAt;
  const ReviewLog({
    required this.id,
    this.cardId,
    required this.game,
    required this.correct,
    required this.responseMs,
    required this.quality,
    required this.reviewedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || cardId != null) {
      map['card_id'] = Variable<int>(cardId);
    }
    map['game'] = Variable<String>(game);
    map['correct'] = Variable<int>(correct);
    map['response_ms'] = Variable<int>(responseMs);
    map['quality'] = Variable<int>(quality);
    map['reviewed_at'] = Variable<int>(reviewedAt);
    return map;
  }

  ReviewLogsCompanion toCompanion(bool nullToAbsent) {
    return ReviewLogsCompanion(
      id: Value(id),
      cardId:
          cardId == null && nullToAbsent ? const Value.absent() : Value(cardId),
      game: Value(game),
      correct: Value(correct),
      responseMs: Value(responseMs),
      quality: Value(quality),
      reviewedAt: Value(reviewedAt),
    );
  }

  factory ReviewLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReviewLog(
      id: serializer.fromJson<int>(json['id']),
      cardId: serializer.fromJson<int?>(json['cardId']),
      game: serializer.fromJson<String>(json['game']),
      correct: serializer.fromJson<int>(json['correct']),
      responseMs: serializer.fromJson<int>(json['responseMs']),
      quality: serializer.fromJson<int>(json['quality']),
      reviewedAt: serializer.fromJson<int>(json['reviewedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cardId': serializer.toJson<int?>(cardId),
      'game': serializer.toJson<String>(game),
      'correct': serializer.toJson<int>(correct),
      'responseMs': serializer.toJson<int>(responseMs),
      'quality': serializer.toJson<int>(quality),
      'reviewedAt': serializer.toJson<int>(reviewedAt),
    };
  }

  ReviewLog copyWith({
    int? id,
    Value<int?> cardId = const Value.absent(),
    String? game,
    int? correct,
    int? responseMs,
    int? quality,
    int? reviewedAt,
  }) => ReviewLog(
    id: id ?? this.id,
    cardId: cardId.present ? cardId.value : this.cardId,
    game: game ?? this.game,
    correct: correct ?? this.correct,
    responseMs: responseMs ?? this.responseMs,
    quality: quality ?? this.quality,
    reviewedAt: reviewedAt ?? this.reviewedAt,
  );
  ReviewLog copyWithCompanion(ReviewLogsCompanion data) {
    return ReviewLog(
      id: data.id.present ? data.id.value : this.id,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      game: data.game.present ? data.game.value : this.game,
      correct: data.correct.present ? data.correct.value : this.correct,
      responseMs:
          data.responseMs.present ? data.responseMs.value : this.responseMs,
      quality: data.quality.present ? data.quality.value : this.quality,
      reviewedAt:
          data.reviewedAt.present ? data.reviewedAt.value : this.reviewedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReviewLog(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('game: $game, ')
          ..write('correct: $correct, ')
          ..write('responseMs: $responseMs, ')
          ..write('quality: $quality, ')
          ..write('reviewedAt: $reviewedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, cardId, game, correct, responseMs, quality, reviewedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReviewLog &&
          other.id == this.id &&
          other.cardId == this.cardId &&
          other.game == this.game &&
          other.correct == this.correct &&
          other.responseMs == this.responseMs &&
          other.quality == this.quality &&
          other.reviewedAt == this.reviewedAt);
}

class ReviewLogsCompanion extends UpdateCompanion<ReviewLog> {
  final Value<int> id;
  final Value<int?> cardId;
  final Value<String> game;
  final Value<int> correct;
  final Value<int> responseMs;
  final Value<int> quality;
  final Value<int> reviewedAt;
  const ReviewLogsCompanion({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    this.game = const Value.absent(),
    this.correct = const Value.absent(),
    this.responseMs = const Value.absent(),
    this.quality = const Value.absent(),
    this.reviewedAt = const Value.absent(),
  });
  ReviewLogsCompanion.insert({
    this.id = const Value.absent(),
    this.cardId = const Value.absent(),
    required String game,
    required int correct,
    required int responseMs,
    required int quality,
    required int reviewedAt,
  }) : game = Value(game),
       correct = Value(correct),
       responseMs = Value(responseMs),
       quality = Value(quality),
       reviewedAt = Value(reviewedAt);
  static Insertable<ReviewLog> custom({
    Expression<int>? id,
    Expression<int>? cardId,
    Expression<String>? game,
    Expression<int>? correct,
    Expression<int>? responseMs,
    Expression<int>? quality,
    Expression<int>? reviewedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cardId != null) 'card_id': cardId,
      if (game != null) 'game': game,
      if (correct != null) 'correct': correct,
      if (responseMs != null) 'response_ms': responseMs,
      if (quality != null) 'quality': quality,
      if (reviewedAt != null) 'reviewed_at': reviewedAt,
    });
  }

  ReviewLogsCompanion copyWith({
    Value<int>? id,
    Value<int?>? cardId,
    Value<String>? game,
    Value<int>? correct,
    Value<int>? responseMs,
    Value<int>? quality,
    Value<int>? reviewedAt,
  }) {
    return ReviewLogsCompanion(
      id: id ?? this.id,
      cardId: cardId ?? this.cardId,
      game: game ?? this.game,
      correct: correct ?? this.correct,
      responseMs: responseMs ?? this.responseMs,
      quality: quality ?? this.quality,
      reviewedAt: reviewedAt ?? this.reviewedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<int>(cardId.value);
    }
    if (game.present) {
      map['game'] = Variable<String>(game.value);
    }
    if (correct.present) {
      map['correct'] = Variable<int>(correct.value);
    }
    if (responseMs.present) {
      map['response_ms'] = Variable<int>(responseMs.value);
    }
    if (quality.present) {
      map['quality'] = Variable<int>(quality.value);
    }
    if (reviewedAt.present) {
      map['reviewed_at'] = Variable<int>(reviewedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewLogsCompanion(')
          ..write('id: $id, ')
          ..write('cardId: $cardId, ')
          ..write('game: $game, ')
          ..write('correct: $correct, ')
          ..write('responseMs: $responseMs, ')
          ..write('quality: $quality, ')
          ..write('reviewedAt: $reviewedAt')
          ..write(')'))
        .toString();
  }
}

class $SentenceStructuresTable extends SentenceStructures
    with TableInfo<$SentenceStructuresTable, SentenceStructure> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SentenceStructuresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _sentenceMeta = const VerificationMeta(
    'sentence',
  );
  @override
  late final GeneratedColumn<String> sentence = GeneratedColumn<String>(
    'sentence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wordCountMeta = const VerificationMeta(
    'wordCount',
  );
  @override
  late final GeneratedColumn<int> wordCount = GeneratedColumn<int>(
    'word_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectSpanMeta = const VerificationMeta(
    'subjectSpan',
  );
  @override
  late final GeneratedColumn<String> subjectSpan = GeneratedColumn<String>(
    'subject_span',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _verbSpanMeta = const VerificationMeta(
    'verbSpan',
  );
  @override
  late final GeneratedColumn<String> verbSpan = GeneratedColumn<String>(
    'verb_span',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _chunksJsonMeta = const VerificationMeta(
    'chunksJson',
  );
  @override
  late final GeneratedColumn<String> chunksJson = GeneratedColumn<String>(
    'chunks_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _layersJsonMeta = const VerificationMeta(
    'layersJson',
  );
  @override
  late final GeneratedColumn<String> layersJson = GeneratedColumn<String>(
    'layers_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _connectorsJsonMeta = const VerificationMeta(
    'connectorsJson',
  );
  @override
  late final GeneratedColumn<String> connectorsJson = GeneratedColumn<String>(
    'connectors_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _simpleMeaningMeta = const VerificationMeta(
    'simpleMeaning',
  );
  @override
  late final GeneratedColumn<String> simpleMeaning = GeneratedColumn<String>(
    'simple_meaning',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioPathMeta = const VerificationMeta(
    'audioPath',
  );
  @override
  late final GeneratedColumn<String> audioPath = GeneratedColumn<String>(
    'audio_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sentence,
    level,
    wordCount,
    subjectSpan,
    verbSpan,
    chunksJson,
    layersJson,
    connectorsJson,
    simpleMeaning,
    audioPath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sentence_structures';
  @override
  VerificationContext validateIntegrity(
    Insertable<SentenceStructure> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sentence')) {
      context.handle(
        _sentenceMeta,
        sentence.isAcceptableOrUnknown(data['sentence']!, _sentenceMeta),
      );
    } else if (isInserting) {
      context.missing(_sentenceMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('word_count')) {
      context.handle(
        _wordCountMeta,
        wordCount.isAcceptableOrUnknown(data['word_count']!, _wordCountMeta),
      );
    } else if (isInserting) {
      context.missing(_wordCountMeta);
    }
    if (data.containsKey('subject_span')) {
      context.handle(
        _subjectSpanMeta,
        subjectSpan.isAcceptableOrUnknown(
          data['subject_span']!,
          _subjectSpanMeta,
        ),
      );
    }
    if (data.containsKey('verb_span')) {
      context.handle(
        _verbSpanMeta,
        verbSpan.isAcceptableOrUnknown(data['verb_span']!, _verbSpanMeta),
      );
    }
    if (data.containsKey('chunks_json')) {
      context.handle(
        _chunksJsonMeta,
        chunksJson.isAcceptableOrUnknown(data['chunks_json']!, _chunksJsonMeta),
      );
    }
    if (data.containsKey('layers_json')) {
      context.handle(
        _layersJsonMeta,
        layersJson.isAcceptableOrUnknown(data['layers_json']!, _layersJsonMeta),
      );
    }
    if (data.containsKey('connectors_json')) {
      context.handle(
        _connectorsJsonMeta,
        connectorsJson.isAcceptableOrUnknown(
          data['connectors_json']!,
          _connectorsJsonMeta,
        ),
      );
    }
    if (data.containsKey('simple_meaning')) {
      context.handle(
        _simpleMeaningMeta,
        simpleMeaning.isAcceptableOrUnknown(
          data['simple_meaning']!,
          _simpleMeaningMeta,
        ),
      );
    }
    if (data.containsKey('audio_path')) {
      context.handle(
        _audioPathMeta,
        audioPath.isAcceptableOrUnknown(data['audio_path']!, _audioPathMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SentenceStructure map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SentenceStructure(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      sentence:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}sentence'],
          )!,
      level:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}level'],
          )!,
      wordCount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}word_count'],
          )!,
      subjectSpan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_span'],
      ),
      verbSpan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}verb_span'],
      ),
      chunksJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chunks_json'],
      ),
      layersJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}layers_json'],
      ),
      connectorsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}connectors_json'],
      ),
      simpleMeaning: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}simple_meaning'],
      ),
      audioPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_path'],
      ),
    );
  }

  @override
  $SentenceStructuresTable createAlias(String alias) {
    return $SentenceStructuresTable(attachedDatabase, alias);
  }
}

class SentenceStructure extends DataClass
    implements Insertable<SentenceStructure> {
  final int id;
  final String sentence;
  final int level;
  final int wordCount;
  final String? subjectSpan;
  final String? verbSpan;
  final String? chunksJson;
  final String? layersJson;
  final String? connectorsJson;
  final String? simpleMeaning;
  final String? audioPath;
  const SentenceStructure({
    required this.id,
    required this.sentence,
    required this.level,
    required this.wordCount,
    this.subjectSpan,
    this.verbSpan,
    this.chunksJson,
    this.layersJson,
    this.connectorsJson,
    this.simpleMeaning,
    this.audioPath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sentence'] = Variable<String>(sentence);
    map['level'] = Variable<int>(level);
    map['word_count'] = Variable<int>(wordCount);
    if (!nullToAbsent || subjectSpan != null) {
      map['subject_span'] = Variable<String>(subjectSpan);
    }
    if (!nullToAbsent || verbSpan != null) {
      map['verb_span'] = Variable<String>(verbSpan);
    }
    if (!nullToAbsent || chunksJson != null) {
      map['chunks_json'] = Variable<String>(chunksJson);
    }
    if (!nullToAbsent || layersJson != null) {
      map['layers_json'] = Variable<String>(layersJson);
    }
    if (!nullToAbsent || connectorsJson != null) {
      map['connectors_json'] = Variable<String>(connectorsJson);
    }
    if (!nullToAbsent || simpleMeaning != null) {
      map['simple_meaning'] = Variable<String>(simpleMeaning);
    }
    if (!nullToAbsent || audioPath != null) {
      map['audio_path'] = Variable<String>(audioPath);
    }
    return map;
  }

  SentenceStructuresCompanion toCompanion(bool nullToAbsent) {
    return SentenceStructuresCompanion(
      id: Value(id),
      sentence: Value(sentence),
      level: Value(level),
      wordCount: Value(wordCount),
      subjectSpan:
          subjectSpan == null && nullToAbsent
              ? const Value.absent()
              : Value(subjectSpan),
      verbSpan:
          verbSpan == null && nullToAbsent
              ? const Value.absent()
              : Value(verbSpan),
      chunksJson:
          chunksJson == null && nullToAbsent
              ? const Value.absent()
              : Value(chunksJson),
      layersJson:
          layersJson == null && nullToAbsent
              ? const Value.absent()
              : Value(layersJson),
      connectorsJson:
          connectorsJson == null && nullToAbsent
              ? const Value.absent()
              : Value(connectorsJson),
      simpleMeaning:
          simpleMeaning == null && nullToAbsent
              ? const Value.absent()
              : Value(simpleMeaning),
      audioPath:
          audioPath == null && nullToAbsent
              ? const Value.absent()
              : Value(audioPath),
    );
  }

  factory SentenceStructure.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SentenceStructure(
      id: serializer.fromJson<int>(json['id']),
      sentence: serializer.fromJson<String>(json['sentence']),
      level: serializer.fromJson<int>(json['level']),
      wordCount: serializer.fromJson<int>(json['wordCount']),
      subjectSpan: serializer.fromJson<String?>(json['subjectSpan']),
      verbSpan: serializer.fromJson<String?>(json['verbSpan']),
      chunksJson: serializer.fromJson<String?>(json['chunksJson']),
      layersJson: serializer.fromJson<String?>(json['layersJson']),
      connectorsJson: serializer.fromJson<String?>(json['connectorsJson']),
      simpleMeaning: serializer.fromJson<String?>(json['simpleMeaning']),
      audioPath: serializer.fromJson<String?>(json['audioPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sentence': serializer.toJson<String>(sentence),
      'level': serializer.toJson<int>(level),
      'wordCount': serializer.toJson<int>(wordCount),
      'subjectSpan': serializer.toJson<String?>(subjectSpan),
      'verbSpan': serializer.toJson<String?>(verbSpan),
      'chunksJson': serializer.toJson<String?>(chunksJson),
      'layersJson': serializer.toJson<String?>(layersJson),
      'connectorsJson': serializer.toJson<String?>(connectorsJson),
      'simpleMeaning': serializer.toJson<String?>(simpleMeaning),
      'audioPath': serializer.toJson<String?>(audioPath),
    };
  }

  SentenceStructure copyWith({
    int? id,
    String? sentence,
    int? level,
    int? wordCount,
    Value<String?> subjectSpan = const Value.absent(),
    Value<String?> verbSpan = const Value.absent(),
    Value<String?> chunksJson = const Value.absent(),
    Value<String?> layersJson = const Value.absent(),
    Value<String?> connectorsJson = const Value.absent(),
    Value<String?> simpleMeaning = const Value.absent(),
    Value<String?> audioPath = const Value.absent(),
  }) => SentenceStructure(
    id: id ?? this.id,
    sentence: sentence ?? this.sentence,
    level: level ?? this.level,
    wordCount: wordCount ?? this.wordCount,
    subjectSpan: subjectSpan.present ? subjectSpan.value : this.subjectSpan,
    verbSpan: verbSpan.present ? verbSpan.value : this.verbSpan,
    chunksJson: chunksJson.present ? chunksJson.value : this.chunksJson,
    layersJson: layersJson.present ? layersJson.value : this.layersJson,
    connectorsJson:
        connectorsJson.present ? connectorsJson.value : this.connectorsJson,
    simpleMeaning:
        simpleMeaning.present ? simpleMeaning.value : this.simpleMeaning,
    audioPath: audioPath.present ? audioPath.value : this.audioPath,
  );
  SentenceStructure copyWithCompanion(SentenceStructuresCompanion data) {
    return SentenceStructure(
      id: data.id.present ? data.id.value : this.id,
      sentence: data.sentence.present ? data.sentence.value : this.sentence,
      level: data.level.present ? data.level.value : this.level,
      wordCount: data.wordCount.present ? data.wordCount.value : this.wordCount,
      subjectSpan:
          data.subjectSpan.present ? data.subjectSpan.value : this.subjectSpan,
      verbSpan: data.verbSpan.present ? data.verbSpan.value : this.verbSpan,
      chunksJson:
          data.chunksJson.present ? data.chunksJson.value : this.chunksJson,
      layersJson:
          data.layersJson.present ? data.layersJson.value : this.layersJson,
      connectorsJson:
          data.connectorsJson.present
              ? data.connectorsJson.value
              : this.connectorsJson,
      simpleMeaning:
          data.simpleMeaning.present
              ? data.simpleMeaning.value
              : this.simpleMeaning,
      audioPath: data.audioPath.present ? data.audioPath.value : this.audioPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SentenceStructure(')
          ..write('id: $id, ')
          ..write('sentence: $sentence, ')
          ..write('level: $level, ')
          ..write('wordCount: $wordCount, ')
          ..write('subjectSpan: $subjectSpan, ')
          ..write('verbSpan: $verbSpan, ')
          ..write('chunksJson: $chunksJson, ')
          ..write('layersJson: $layersJson, ')
          ..write('connectorsJson: $connectorsJson, ')
          ..write('simpleMeaning: $simpleMeaning, ')
          ..write('audioPath: $audioPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sentence,
    level,
    wordCount,
    subjectSpan,
    verbSpan,
    chunksJson,
    layersJson,
    connectorsJson,
    simpleMeaning,
    audioPath,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SentenceStructure &&
          other.id == this.id &&
          other.sentence == this.sentence &&
          other.level == this.level &&
          other.wordCount == this.wordCount &&
          other.subjectSpan == this.subjectSpan &&
          other.verbSpan == this.verbSpan &&
          other.chunksJson == this.chunksJson &&
          other.layersJson == this.layersJson &&
          other.connectorsJson == this.connectorsJson &&
          other.simpleMeaning == this.simpleMeaning &&
          other.audioPath == this.audioPath);
}

class SentenceStructuresCompanion extends UpdateCompanion<SentenceStructure> {
  final Value<int> id;
  final Value<String> sentence;
  final Value<int> level;
  final Value<int> wordCount;
  final Value<String?> subjectSpan;
  final Value<String?> verbSpan;
  final Value<String?> chunksJson;
  final Value<String?> layersJson;
  final Value<String?> connectorsJson;
  final Value<String?> simpleMeaning;
  final Value<String?> audioPath;
  const SentenceStructuresCompanion({
    this.id = const Value.absent(),
    this.sentence = const Value.absent(),
    this.level = const Value.absent(),
    this.wordCount = const Value.absent(),
    this.subjectSpan = const Value.absent(),
    this.verbSpan = const Value.absent(),
    this.chunksJson = const Value.absent(),
    this.layersJson = const Value.absent(),
    this.connectorsJson = const Value.absent(),
    this.simpleMeaning = const Value.absent(),
    this.audioPath = const Value.absent(),
  });
  SentenceStructuresCompanion.insert({
    this.id = const Value.absent(),
    required String sentence,
    required int level,
    required int wordCount,
    this.subjectSpan = const Value.absent(),
    this.verbSpan = const Value.absent(),
    this.chunksJson = const Value.absent(),
    this.layersJson = const Value.absent(),
    this.connectorsJson = const Value.absent(),
    this.simpleMeaning = const Value.absent(),
    this.audioPath = const Value.absent(),
  }) : sentence = Value(sentence),
       level = Value(level),
       wordCount = Value(wordCount);
  static Insertable<SentenceStructure> custom({
    Expression<int>? id,
    Expression<String>? sentence,
    Expression<int>? level,
    Expression<int>? wordCount,
    Expression<String>? subjectSpan,
    Expression<String>? verbSpan,
    Expression<String>? chunksJson,
    Expression<String>? layersJson,
    Expression<String>? connectorsJson,
    Expression<String>? simpleMeaning,
    Expression<String>? audioPath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sentence != null) 'sentence': sentence,
      if (level != null) 'level': level,
      if (wordCount != null) 'word_count': wordCount,
      if (subjectSpan != null) 'subject_span': subjectSpan,
      if (verbSpan != null) 'verb_span': verbSpan,
      if (chunksJson != null) 'chunks_json': chunksJson,
      if (layersJson != null) 'layers_json': layersJson,
      if (connectorsJson != null) 'connectors_json': connectorsJson,
      if (simpleMeaning != null) 'simple_meaning': simpleMeaning,
      if (audioPath != null) 'audio_path': audioPath,
    });
  }

  SentenceStructuresCompanion copyWith({
    Value<int>? id,
    Value<String>? sentence,
    Value<int>? level,
    Value<int>? wordCount,
    Value<String?>? subjectSpan,
    Value<String?>? verbSpan,
    Value<String?>? chunksJson,
    Value<String?>? layersJson,
    Value<String?>? connectorsJson,
    Value<String?>? simpleMeaning,
    Value<String?>? audioPath,
  }) {
    return SentenceStructuresCompanion(
      id: id ?? this.id,
      sentence: sentence ?? this.sentence,
      level: level ?? this.level,
      wordCount: wordCount ?? this.wordCount,
      subjectSpan: subjectSpan ?? this.subjectSpan,
      verbSpan: verbSpan ?? this.verbSpan,
      chunksJson: chunksJson ?? this.chunksJson,
      layersJson: layersJson ?? this.layersJson,
      connectorsJson: connectorsJson ?? this.connectorsJson,
      simpleMeaning: simpleMeaning ?? this.simpleMeaning,
      audioPath: audioPath ?? this.audioPath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sentence.present) {
      map['sentence'] = Variable<String>(sentence.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (wordCount.present) {
      map['word_count'] = Variable<int>(wordCount.value);
    }
    if (subjectSpan.present) {
      map['subject_span'] = Variable<String>(subjectSpan.value);
    }
    if (verbSpan.present) {
      map['verb_span'] = Variable<String>(verbSpan.value);
    }
    if (chunksJson.present) {
      map['chunks_json'] = Variable<String>(chunksJson.value);
    }
    if (layersJson.present) {
      map['layers_json'] = Variable<String>(layersJson.value);
    }
    if (connectorsJson.present) {
      map['connectors_json'] = Variable<String>(connectorsJson.value);
    }
    if (simpleMeaning.present) {
      map['simple_meaning'] = Variable<String>(simpleMeaning.value);
    }
    if (audioPath.present) {
      map['audio_path'] = Variable<String>(audioPath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SentenceStructuresCompanion(')
          ..write('id: $id, ')
          ..write('sentence: $sentence, ')
          ..write('level: $level, ')
          ..write('wordCount: $wordCount, ')
          ..write('subjectSpan: $subjectSpan, ')
          ..write('verbSpan: $verbSpan, ')
          ..write('chunksJson: $chunksJson, ')
          ..write('layersJson: $layersJson, ')
          ..write('connectorsJson: $connectorsJson, ')
          ..write('simpleMeaning: $simpleMeaning, ')
          ..write('audioPath: $audioPath')
          ..write(')'))
        .toString();
  }
}

class $ParagraphsTable extends Paragraphs
    with TableInfo<$ParagraphsTable, Paragraph> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ParagraphsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topicMeta = const VerificationMeta('topic');
  @override
  late final GeneratedColumn<String> topic = GeneratedColumn<String>(
    'topic',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sentencesJsonMeta = const VerificationMeta(
    'sentencesJson',
  );
  @override
  late final GeneratedColumn<String> sentencesJson = GeneratedColumn<String>(
    'sentences_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _validOrdersJsonMeta = const VerificationMeta(
    'validOrdersJson',
  );
  @override
  late final GeneratedColumn<String> validOrdersJson = GeneratedColumn<String>(
    'valid_orders_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _linksJsonMeta = const VerificationMeta(
    'linksJson',
  );
  @override
  late final GeneratedColumn<String> linksJson = GeneratedColumn<String>(
    'links_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    level,
    topic,
    sentencesJson,
    validOrdersJson,
    linksJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'paragraphs';
  @override
  VerificationContext validateIntegrity(
    Insertable<Paragraph> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('topic')) {
      context.handle(
        _topicMeta,
        topic.isAcceptableOrUnknown(data['topic']!, _topicMeta),
      );
    }
    if (data.containsKey('sentences_json')) {
      context.handle(
        _sentencesJsonMeta,
        sentencesJson.isAcceptableOrUnknown(
          data['sentences_json']!,
          _sentencesJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sentencesJsonMeta);
    }
    if (data.containsKey('valid_orders_json')) {
      context.handle(
        _validOrdersJsonMeta,
        validOrdersJson.isAcceptableOrUnknown(
          data['valid_orders_json']!,
          _validOrdersJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_validOrdersJsonMeta);
    }
    if (data.containsKey('links_json')) {
      context.handle(
        _linksJsonMeta,
        linksJson.isAcceptableOrUnknown(data['links_json']!, _linksJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_linksJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Paragraph map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Paragraph(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      level:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}level'],
          )!,
      topic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topic'],
      ),
      sentencesJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}sentences_json'],
          )!,
      validOrdersJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}valid_orders_json'],
          )!,
      linksJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}links_json'],
          )!,
    );
  }

  @override
  $ParagraphsTable createAlias(String alias) {
    return $ParagraphsTable(attachedDatabase, alias);
  }
}

class Paragraph extends DataClass implements Insertable<Paragraph> {
  final int id;
  final int level;
  final String? topic;
  final String sentencesJson;
  final String validOrdersJson;
  final String linksJson;
  const Paragraph({
    required this.id,
    required this.level,
    this.topic,
    required this.sentencesJson,
    required this.validOrdersJson,
    required this.linksJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['level'] = Variable<int>(level);
    if (!nullToAbsent || topic != null) {
      map['topic'] = Variable<String>(topic);
    }
    map['sentences_json'] = Variable<String>(sentencesJson);
    map['valid_orders_json'] = Variable<String>(validOrdersJson);
    map['links_json'] = Variable<String>(linksJson);
    return map;
  }

  ParagraphsCompanion toCompanion(bool nullToAbsent) {
    return ParagraphsCompanion(
      id: Value(id),
      level: Value(level),
      topic:
          topic == null && nullToAbsent ? const Value.absent() : Value(topic),
      sentencesJson: Value(sentencesJson),
      validOrdersJson: Value(validOrdersJson),
      linksJson: Value(linksJson),
    );
  }

  factory Paragraph.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Paragraph(
      id: serializer.fromJson<int>(json['id']),
      level: serializer.fromJson<int>(json['level']),
      topic: serializer.fromJson<String?>(json['topic']),
      sentencesJson: serializer.fromJson<String>(json['sentencesJson']),
      validOrdersJson: serializer.fromJson<String>(json['validOrdersJson']),
      linksJson: serializer.fromJson<String>(json['linksJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'level': serializer.toJson<int>(level),
      'topic': serializer.toJson<String?>(topic),
      'sentencesJson': serializer.toJson<String>(sentencesJson),
      'validOrdersJson': serializer.toJson<String>(validOrdersJson),
      'linksJson': serializer.toJson<String>(linksJson),
    };
  }

  Paragraph copyWith({
    int? id,
    int? level,
    Value<String?> topic = const Value.absent(),
    String? sentencesJson,
    String? validOrdersJson,
    String? linksJson,
  }) => Paragraph(
    id: id ?? this.id,
    level: level ?? this.level,
    topic: topic.present ? topic.value : this.topic,
    sentencesJson: sentencesJson ?? this.sentencesJson,
    validOrdersJson: validOrdersJson ?? this.validOrdersJson,
    linksJson: linksJson ?? this.linksJson,
  );
  Paragraph copyWithCompanion(ParagraphsCompanion data) {
    return Paragraph(
      id: data.id.present ? data.id.value : this.id,
      level: data.level.present ? data.level.value : this.level,
      topic: data.topic.present ? data.topic.value : this.topic,
      sentencesJson:
          data.sentencesJson.present
              ? data.sentencesJson.value
              : this.sentencesJson,
      validOrdersJson:
          data.validOrdersJson.present
              ? data.validOrdersJson.value
              : this.validOrdersJson,
      linksJson: data.linksJson.present ? data.linksJson.value : this.linksJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Paragraph(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('topic: $topic, ')
          ..write('sentencesJson: $sentencesJson, ')
          ..write('validOrdersJson: $validOrdersJson, ')
          ..write('linksJson: $linksJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, level, topic, sentencesJson, validOrdersJson, linksJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Paragraph &&
          other.id == this.id &&
          other.level == this.level &&
          other.topic == this.topic &&
          other.sentencesJson == this.sentencesJson &&
          other.validOrdersJson == this.validOrdersJson &&
          other.linksJson == this.linksJson);
}

class ParagraphsCompanion extends UpdateCompanion<Paragraph> {
  final Value<int> id;
  final Value<int> level;
  final Value<String?> topic;
  final Value<String> sentencesJson;
  final Value<String> validOrdersJson;
  final Value<String> linksJson;
  const ParagraphsCompanion({
    this.id = const Value.absent(),
    this.level = const Value.absent(),
    this.topic = const Value.absent(),
    this.sentencesJson = const Value.absent(),
    this.validOrdersJson = const Value.absent(),
    this.linksJson = const Value.absent(),
  });
  ParagraphsCompanion.insert({
    this.id = const Value.absent(),
    required int level,
    this.topic = const Value.absent(),
    required String sentencesJson,
    required String validOrdersJson,
    required String linksJson,
  }) : level = Value(level),
       sentencesJson = Value(sentencesJson),
       validOrdersJson = Value(validOrdersJson),
       linksJson = Value(linksJson);
  static Insertable<Paragraph> custom({
    Expression<int>? id,
    Expression<int>? level,
    Expression<String>? topic,
    Expression<String>? sentencesJson,
    Expression<String>? validOrdersJson,
    Expression<String>? linksJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (level != null) 'level': level,
      if (topic != null) 'topic': topic,
      if (sentencesJson != null) 'sentences_json': sentencesJson,
      if (validOrdersJson != null) 'valid_orders_json': validOrdersJson,
      if (linksJson != null) 'links_json': linksJson,
    });
  }

  ParagraphsCompanion copyWith({
    Value<int>? id,
    Value<int>? level,
    Value<String?>? topic,
    Value<String>? sentencesJson,
    Value<String>? validOrdersJson,
    Value<String>? linksJson,
  }) {
    return ParagraphsCompanion(
      id: id ?? this.id,
      level: level ?? this.level,
      topic: topic ?? this.topic,
      sentencesJson: sentencesJson ?? this.sentencesJson,
      validOrdersJson: validOrdersJson ?? this.validOrdersJson,
      linksJson: linksJson ?? this.linksJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (topic.present) {
      map['topic'] = Variable<String>(topic.value);
    }
    if (sentencesJson.present) {
      map['sentences_json'] = Variable<String>(sentencesJson.value);
    }
    if (validOrdersJson.present) {
      map['valid_orders_json'] = Variable<String>(validOrdersJson.value);
    }
    if (linksJson.present) {
      map['links_json'] = Variable<String>(linksJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ParagraphsCompanion(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('topic: $topic, ')
          ..write('sentencesJson: $sentencesJson, ')
          ..write('validOrdersJson: $validOrdersJson, ')
          ..write('linksJson: $linksJson')
          ..write(')'))
        .toString();
  }
}

class $ChunkSentencesTable extends ChunkSentences
    with TableInfo<$ChunkSentencesTable, ChunkSentence> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChunkSentencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _textContentMeta = const VerificationMeta(
    'textContent',
  );
  @override
  late final GeneratedColumn<String> textContent = GeneratedColumn<String>(
    'text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chunksJsonMeta = const VerificationMeta(
    'chunksJson',
  );
  @override
  late final GeneratedColumn<String> chunksJson = GeneratedColumn<String>(
    'chunks_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _audioPathMeta = const VerificationMeta(
    'audioPath',
  );
  @override
  late final GeneratedColumn<String> audioPath = GeneratedColumn<String>(
    'audio_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _audioSlowPathMeta = const VerificationMeta(
    'audioSlowPath',
  );
  @override
  late final GeneratedColumn<String> audioSlowPath = GeneratedColumn<String>(
    'audio_slow_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _chunkTimingsJsonMeta = const VerificationMeta(
    'chunkTimingsJson',
  );
  @override
  late final GeneratedColumn<String> chunkTimingsJson = GeneratedColumn<String>(
    'chunk_timings_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    level,
    textContent,
    chunksJson,
    audioPath,
    audioSlowPath,
    chunkTimingsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chunk_sentences';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChunkSentence> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('text')) {
      context.handle(
        _textContentMeta,
        textContent.isAcceptableOrUnknown(data['text']!, _textContentMeta),
      );
    } else if (isInserting) {
      context.missing(_textContentMeta);
    }
    if (data.containsKey('chunks_json')) {
      context.handle(
        _chunksJsonMeta,
        chunksJson.isAcceptableOrUnknown(data['chunks_json']!, _chunksJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_chunksJsonMeta);
    }
    if (data.containsKey('audio_path')) {
      context.handle(
        _audioPathMeta,
        audioPath.isAcceptableOrUnknown(data['audio_path']!, _audioPathMeta),
      );
    }
    if (data.containsKey('audio_slow_path')) {
      context.handle(
        _audioSlowPathMeta,
        audioSlowPath.isAcceptableOrUnknown(
          data['audio_slow_path']!,
          _audioSlowPathMeta,
        ),
      );
    }
    if (data.containsKey('chunk_timings_json')) {
      context.handle(
        _chunkTimingsJsonMeta,
        chunkTimingsJson.isAcceptableOrUnknown(
          data['chunk_timings_json']!,
          _chunkTimingsJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChunkSentence map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChunkSentence(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      level:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}level'],
          )!,
      textContent:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}text'],
          )!,
      chunksJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}chunks_json'],
          )!,
      audioPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_path'],
      ),
      audioSlowPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_slow_path'],
      ),
      chunkTimingsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chunk_timings_json'],
      ),
    );
  }

  @override
  $ChunkSentencesTable createAlias(String alias) {
    return $ChunkSentencesTable(attachedDatabase, alias);
  }
}

class ChunkSentence extends DataClass implements Insertable<ChunkSentence> {
  final int id;
  final int level;
  final String textContent;
  final String chunksJson;
  final String? audioPath;
  final String? audioSlowPath;
  final String? chunkTimingsJson;
  const ChunkSentence({
    required this.id,
    required this.level,
    required this.textContent,
    required this.chunksJson,
    this.audioPath,
    this.audioSlowPath,
    this.chunkTimingsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['level'] = Variable<int>(level);
    map['text'] = Variable<String>(textContent);
    map['chunks_json'] = Variable<String>(chunksJson);
    if (!nullToAbsent || audioPath != null) {
      map['audio_path'] = Variable<String>(audioPath);
    }
    if (!nullToAbsent || audioSlowPath != null) {
      map['audio_slow_path'] = Variable<String>(audioSlowPath);
    }
    if (!nullToAbsent || chunkTimingsJson != null) {
      map['chunk_timings_json'] = Variable<String>(chunkTimingsJson);
    }
    return map;
  }

  ChunkSentencesCompanion toCompanion(bool nullToAbsent) {
    return ChunkSentencesCompanion(
      id: Value(id),
      level: Value(level),
      textContent: Value(textContent),
      chunksJson: Value(chunksJson),
      audioPath:
          audioPath == null && nullToAbsent
              ? const Value.absent()
              : Value(audioPath),
      audioSlowPath:
          audioSlowPath == null && nullToAbsent
              ? const Value.absent()
              : Value(audioSlowPath),
      chunkTimingsJson:
          chunkTimingsJson == null && nullToAbsent
              ? const Value.absent()
              : Value(chunkTimingsJson),
    );
  }

  factory ChunkSentence.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChunkSentence(
      id: serializer.fromJson<int>(json['id']),
      level: serializer.fromJson<int>(json['level']),
      textContent: serializer.fromJson<String>(json['textContent']),
      chunksJson: serializer.fromJson<String>(json['chunksJson']),
      audioPath: serializer.fromJson<String?>(json['audioPath']),
      audioSlowPath: serializer.fromJson<String?>(json['audioSlowPath']),
      chunkTimingsJson: serializer.fromJson<String?>(json['chunkTimingsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'level': serializer.toJson<int>(level),
      'textContent': serializer.toJson<String>(textContent),
      'chunksJson': serializer.toJson<String>(chunksJson),
      'audioPath': serializer.toJson<String?>(audioPath),
      'audioSlowPath': serializer.toJson<String?>(audioSlowPath),
      'chunkTimingsJson': serializer.toJson<String?>(chunkTimingsJson),
    };
  }

  ChunkSentence copyWith({
    int? id,
    int? level,
    String? textContent,
    String? chunksJson,
    Value<String?> audioPath = const Value.absent(),
    Value<String?> audioSlowPath = const Value.absent(),
    Value<String?> chunkTimingsJson = const Value.absent(),
  }) => ChunkSentence(
    id: id ?? this.id,
    level: level ?? this.level,
    textContent: textContent ?? this.textContent,
    chunksJson: chunksJson ?? this.chunksJson,
    audioPath: audioPath.present ? audioPath.value : this.audioPath,
    audioSlowPath:
        audioSlowPath.present ? audioSlowPath.value : this.audioSlowPath,
    chunkTimingsJson:
        chunkTimingsJson.present
            ? chunkTimingsJson.value
            : this.chunkTimingsJson,
  );
  ChunkSentence copyWithCompanion(ChunkSentencesCompanion data) {
    return ChunkSentence(
      id: data.id.present ? data.id.value : this.id,
      level: data.level.present ? data.level.value : this.level,
      textContent:
          data.textContent.present ? data.textContent.value : this.textContent,
      chunksJson:
          data.chunksJson.present ? data.chunksJson.value : this.chunksJson,
      audioPath: data.audioPath.present ? data.audioPath.value : this.audioPath,
      audioSlowPath:
          data.audioSlowPath.present
              ? data.audioSlowPath.value
              : this.audioSlowPath,
      chunkTimingsJson:
          data.chunkTimingsJson.present
              ? data.chunkTimingsJson.value
              : this.chunkTimingsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChunkSentence(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('textContent: $textContent, ')
          ..write('chunksJson: $chunksJson, ')
          ..write('audioPath: $audioPath, ')
          ..write('audioSlowPath: $audioSlowPath, ')
          ..write('chunkTimingsJson: $chunkTimingsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    level,
    textContent,
    chunksJson,
    audioPath,
    audioSlowPath,
    chunkTimingsJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChunkSentence &&
          other.id == this.id &&
          other.level == this.level &&
          other.textContent == this.textContent &&
          other.chunksJson == this.chunksJson &&
          other.audioPath == this.audioPath &&
          other.audioSlowPath == this.audioSlowPath &&
          other.chunkTimingsJson == this.chunkTimingsJson);
}

class ChunkSentencesCompanion extends UpdateCompanion<ChunkSentence> {
  final Value<int> id;
  final Value<int> level;
  final Value<String> textContent;
  final Value<String> chunksJson;
  final Value<String?> audioPath;
  final Value<String?> audioSlowPath;
  final Value<String?> chunkTimingsJson;
  const ChunkSentencesCompanion({
    this.id = const Value.absent(),
    this.level = const Value.absent(),
    this.textContent = const Value.absent(),
    this.chunksJson = const Value.absent(),
    this.audioPath = const Value.absent(),
    this.audioSlowPath = const Value.absent(),
    this.chunkTimingsJson = const Value.absent(),
  });
  ChunkSentencesCompanion.insert({
    this.id = const Value.absent(),
    required int level,
    required String textContent,
    required String chunksJson,
    this.audioPath = const Value.absent(),
    this.audioSlowPath = const Value.absent(),
    this.chunkTimingsJson = const Value.absent(),
  }) : level = Value(level),
       textContent = Value(textContent),
       chunksJson = Value(chunksJson);
  static Insertable<ChunkSentence> custom({
    Expression<int>? id,
    Expression<int>? level,
    Expression<String>? textContent,
    Expression<String>? chunksJson,
    Expression<String>? audioPath,
    Expression<String>? audioSlowPath,
    Expression<String>? chunkTimingsJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (level != null) 'level': level,
      if (textContent != null) 'text': textContent,
      if (chunksJson != null) 'chunks_json': chunksJson,
      if (audioPath != null) 'audio_path': audioPath,
      if (audioSlowPath != null) 'audio_slow_path': audioSlowPath,
      if (chunkTimingsJson != null) 'chunk_timings_json': chunkTimingsJson,
    });
  }

  ChunkSentencesCompanion copyWith({
    Value<int>? id,
    Value<int>? level,
    Value<String>? textContent,
    Value<String>? chunksJson,
    Value<String?>? audioPath,
    Value<String?>? audioSlowPath,
    Value<String?>? chunkTimingsJson,
  }) {
    return ChunkSentencesCompanion(
      id: id ?? this.id,
      level: level ?? this.level,
      textContent: textContent ?? this.textContent,
      chunksJson: chunksJson ?? this.chunksJson,
      audioPath: audioPath ?? this.audioPath,
      audioSlowPath: audioSlowPath ?? this.audioSlowPath,
      chunkTimingsJson: chunkTimingsJson ?? this.chunkTimingsJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (textContent.present) {
      map['text'] = Variable<String>(textContent.value);
    }
    if (chunksJson.present) {
      map['chunks_json'] = Variable<String>(chunksJson.value);
    }
    if (audioPath.present) {
      map['audio_path'] = Variable<String>(audioPath.value);
    }
    if (audioSlowPath.present) {
      map['audio_slow_path'] = Variable<String>(audioSlowPath.value);
    }
    if (chunkTimingsJson.present) {
      map['chunk_timings_json'] = Variable<String>(chunkTimingsJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChunkSentencesCompanion(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('textContent: $textContent, ')
          ..write('chunksJson: $chunksJson, ')
          ..write('audioPath: $audioPath, ')
          ..write('audioSlowPath: $audioSlowPath, ')
          ..write('chunkTimingsJson: $chunkTimingsJson')
          ..write(')'))
        .toString();
  }
}

class $PassagesTable extends Passages with TableInfo<$PassagesTable, Passage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PassagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cefrMeta = const VerificationMeta('cefr');
  @override
  late final GeneratedColumn<String> cefr = GeneratedColumn<String>(
    'cefr',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wordCountMeta = const VerificationMeta(
    'wordCount',
  );
  @override
  late final GeneratedColumn<int> wordCount = GeneratedColumn<int>(
    'word_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _audioPathMeta = const VerificationMeta(
    'audioPath',
  );
  @override
  late final GeneratedColumn<String> audioPath = GeneratedColumn<String>(
    'audio_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    body,
    cefr,
    wordCount,
    audioPath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'passages';
  @override
  VerificationContext validateIntegrity(
    Insertable<Passage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('cefr')) {
      context.handle(
        _cefrMeta,
        cefr.isAcceptableOrUnknown(data['cefr']!, _cefrMeta),
      );
    }
    if (data.containsKey('word_count')) {
      context.handle(
        _wordCountMeta,
        wordCount.isAcceptableOrUnknown(data['word_count']!, _wordCountMeta),
      );
    } else if (isInserting) {
      context.missing(_wordCountMeta);
    }
    if (data.containsKey('audio_path')) {
      context.handle(
        _audioPathMeta,
        audioPath.isAcceptableOrUnknown(data['audio_path']!, _audioPathMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Passage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Passage(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      title:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}title'],
          )!,
      body:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}body'],
          )!,
      cefr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cefr'],
      ),
      wordCount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}word_count'],
          )!,
      audioPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_path'],
      ),
    );
  }

  @override
  $PassagesTable createAlias(String alias) {
    return $PassagesTable(attachedDatabase, alias);
  }
}

class Passage extends DataClass implements Insertable<Passage> {
  final int id;
  final String title;
  final String body;
  final String? cefr;
  final int wordCount;
  final String? audioPath;
  const Passage({
    required this.id,
    required this.title,
    required this.body,
    this.cefr,
    required this.wordCount,
    this.audioPath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    if (!nullToAbsent || cefr != null) {
      map['cefr'] = Variable<String>(cefr);
    }
    map['word_count'] = Variable<int>(wordCount);
    if (!nullToAbsent || audioPath != null) {
      map['audio_path'] = Variable<String>(audioPath);
    }
    return map;
  }

  PassagesCompanion toCompanion(bool nullToAbsent) {
    return PassagesCompanion(
      id: Value(id),
      title: Value(title),
      body: Value(body),
      cefr: cefr == null && nullToAbsent ? const Value.absent() : Value(cefr),
      wordCount: Value(wordCount),
      audioPath:
          audioPath == null && nullToAbsent
              ? const Value.absent()
              : Value(audioPath),
    );
  }

  factory Passage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Passage(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      cefr: serializer.fromJson<String?>(json['cefr']),
      wordCount: serializer.fromJson<int>(json['wordCount']),
      audioPath: serializer.fromJson<String?>(json['audioPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'cefr': serializer.toJson<String?>(cefr),
      'wordCount': serializer.toJson<int>(wordCount),
      'audioPath': serializer.toJson<String?>(audioPath),
    };
  }

  Passage copyWith({
    int? id,
    String? title,
    String? body,
    Value<String?> cefr = const Value.absent(),
    int? wordCount,
    Value<String?> audioPath = const Value.absent(),
  }) => Passage(
    id: id ?? this.id,
    title: title ?? this.title,
    body: body ?? this.body,
    cefr: cefr.present ? cefr.value : this.cefr,
    wordCount: wordCount ?? this.wordCount,
    audioPath: audioPath.present ? audioPath.value : this.audioPath,
  );
  Passage copyWithCompanion(PassagesCompanion data) {
    return Passage(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      cefr: data.cefr.present ? data.cefr.value : this.cefr,
      wordCount: data.wordCount.present ? data.wordCount.value : this.wordCount,
      audioPath: data.audioPath.present ? data.audioPath.value : this.audioPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Passage(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('cefr: $cefr, ')
          ..write('wordCount: $wordCount, ')
          ..write('audioPath: $audioPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, body, cefr, wordCount, audioPath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Passage &&
          other.id == this.id &&
          other.title == this.title &&
          other.body == this.body &&
          other.cefr == this.cefr &&
          other.wordCount == this.wordCount &&
          other.audioPath == this.audioPath);
}

class PassagesCompanion extends UpdateCompanion<Passage> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> body;
  final Value<String?> cefr;
  final Value<int> wordCount;
  final Value<String?> audioPath;
  const PassagesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.cefr = const Value.absent(),
    this.wordCount = const Value.absent(),
    this.audioPath = const Value.absent(),
  });
  PassagesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String body,
    this.cefr = const Value.absent(),
    required int wordCount,
    this.audioPath = const Value.absent(),
  }) : title = Value(title),
       body = Value(body),
       wordCount = Value(wordCount);
  static Insertable<Passage> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? cefr,
    Expression<int>? wordCount,
    Expression<String>? audioPath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (cefr != null) 'cefr': cefr,
      if (wordCount != null) 'word_count': wordCount,
      if (audioPath != null) 'audio_path': audioPath,
    });
  }

  PassagesCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? body,
    Value<String?>? cefr,
    Value<int>? wordCount,
    Value<String?>? audioPath,
  }) {
    return PassagesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      cefr: cefr ?? this.cefr,
      wordCount: wordCount ?? this.wordCount,
      audioPath: audioPath ?? this.audioPath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (cefr.present) {
      map['cefr'] = Variable<String>(cefr.value);
    }
    if (wordCount.present) {
      map['word_count'] = Variable<int>(wordCount.value);
    }
    if (audioPath.present) {
      map['audio_path'] = Variable<String>(audioPath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PassagesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('cefr: $cefr, ')
          ..write('wordCount: $wordCount, ')
          ..write('audioPath: $audioPath')
          ..write(')'))
        .toString();
  }
}

class $QuestionsTable extends Questions
    with TableInfo<$QuestionsTable, Question> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _passageIdMeta = const VerificationMeta(
    'passageId',
  );
  @override
  late final GeneratedColumn<int> passageId = GeneratedColumn<int>(
    'passage_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES passages (id)',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _promptMeta = const VerificationMeta('prompt');
  @override
  late final GeneratedColumn<String> prompt = GeneratedColumn<String>(
    'prompt',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _optionsMeta = const VerificationMeta(
    'options',
  );
  @override
  late final GeneratedColumn<String> options = GeneratedColumn<String>(
    'options',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _answerMeta = const VerificationMeta('answer');
  @override
  late final GeneratedColumn<String> answer = GeneratedColumn<String>(
    'answer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _explanationMeta = const VerificationMeta(
    'explanation',
  );
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
    'explanation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    passageId,
    type,
    prompt,
    options,
    answer,
    explanation,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'questions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Question> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('passage_id')) {
      context.handle(
        _passageIdMeta,
        passageId.isAcceptableOrUnknown(data['passage_id']!, _passageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_passageIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('prompt')) {
      context.handle(
        _promptMeta,
        prompt.isAcceptableOrUnknown(data['prompt']!, _promptMeta),
      );
    } else if (isInserting) {
      context.missing(_promptMeta);
    }
    if (data.containsKey('options')) {
      context.handle(
        _optionsMeta,
        options.isAcceptableOrUnknown(data['options']!, _optionsMeta),
      );
    }
    if (data.containsKey('answer')) {
      context.handle(
        _answerMeta,
        answer.isAcceptableOrUnknown(data['answer']!, _answerMeta),
      );
    } else if (isInserting) {
      context.missing(_answerMeta);
    }
    if (data.containsKey('explanation')) {
      context.handle(
        _explanationMeta,
        explanation.isAcceptableOrUnknown(
          data['explanation']!,
          _explanationMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Question map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Question(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      passageId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}passage_id'],
          )!,
      type:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}type'],
          )!,
      prompt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}prompt'],
          )!,
      options: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}options'],
      ),
      answer:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}answer'],
          )!,
      explanation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation'],
      ),
    );
  }

  @override
  $QuestionsTable createAlias(String alias) {
    return $QuestionsTable(attachedDatabase, alias);
  }
}

class Question extends DataClass implements Insertable<Question> {
  final int id;
  final int passageId;
  final String type;
  final String prompt;
  final String? options;
  final String answer;
  final String? explanation;
  const Question({
    required this.id,
    required this.passageId,
    required this.type,
    required this.prompt,
    this.options,
    required this.answer,
    this.explanation,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['passage_id'] = Variable<int>(passageId);
    map['type'] = Variable<String>(type);
    map['prompt'] = Variable<String>(prompt);
    if (!nullToAbsent || options != null) {
      map['options'] = Variable<String>(options);
    }
    map['answer'] = Variable<String>(answer);
    if (!nullToAbsent || explanation != null) {
      map['explanation'] = Variable<String>(explanation);
    }
    return map;
  }

  QuestionsCompanion toCompanion(bool nullToAbsent) {
    return QuestionsCompanion(
      id: Value(id),
      passageId: Value(passageId),
      type: Value(type),
      prompt: Value(prompt),
      options:
          options == null && nullToAbsent
              ? const Value.absent()
              : Value(options),
      answer: Value(answer),
      explanation:
          explanation == null && nullToAbsent
              ? const Value.absent()
              : Value(explanation),
    );
  }

  factory Question.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Question(
      id: serializer.fromJson<int>(json['id']),
      passageId: serializer.fromJson<int>(json['passageId']),
      type: serializer.fromJson<String>(json['type']),
      prompt: serializer.fromJson<String>(json['prompt']),
      options: serializer.fromJson<String?>(json['options']),
      answer: serializer.fromJson<String>(json['answer']),
      explanation: serializer.fromJson<String?>(json['explanation']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'passageId': serializer.toJson<int>(passageId),
      'type': serializer.toJson<String>(type),
      'prompt': serializer.toJson<String>(prompt),
      'options': serializer.toJson<String?>(options),
      'answer': serializer.toJson<String>(answer),
      'explanation': serializer.toJson<String?>(explanation),
    };
  }

  Question copyWith({
    int? id,
    int? passageId,
    String? type,
    String? prompt,
    Value<String?> options = const Value.absent(),
    String? answer,
    Value<String?> explanation = const Value.absent(),
  }) => Question(
    id: id ?? this.id,
    passageId: passageId ?? this.passageId,
    type: type ?? this.type,
    prompt: prompt ?? this.prompt,
    options: options.present ? options.value : this.options,
    answer: answer ?? this.answer,
    explanation: explanation.present ? explanation.value : this.explanation,
  );
  Question copyWithCompanion(QuestionsCompanion data) {
    return Question(
      id: data.id.present ? data.id.value : this.id,
      passageId: data.passageId.present ? data.passageId.value : this.passageId,
      type: data.type.present ? data.type.value : this.type,
      prompt: data.prompt.present ? data.prompt.value : this.prompt,
      options: data.options.present ? data.options.value : this.options,
      answer: data.answer.present ? data.answer.value : this.answer,
      explanation:
          data.explanation.present ? data.explanation.value : this.explanation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Question(')
          ..write('id: $id, ')
          ..write('passageId: $passageId, ')
          ..write('type: $type, ')
          ..write('prompt: $prompt, ')
          ..write('options: $options, ')
          ..write('answer: $answer, ')
          ..write('explanation: $explanation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, passageId, type, prompt, options, answer, explanation);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Question &&
          other.id == this.id &&
          other.passageId == this.passageId &&
          other.type == this.type &&
          other.prompt == this.prompt &&
          other.options == this.options &&
          other.answer == this.answer &&
          other.explanation == this.explanation);
}

class QuestionsCompanion extends UpdateCompanion<Question> {
  final Value<int> id;
  final Value<int> passageId;
  final Value<String> type;
  final Value<String> prompt;
  final Value<String?> options;
  final Value<String> answer;
  final Value<String?> explanation;
  const QuestionsCompanion({
    this.id = const Value.absent(),
    this.passageId = const Value.absent(),
    this.type = const Value.absent(),
    this.prompt = const Value.absent(),
    this.options = const Value.absent(),
    this.answer = const Value.absent(),
    this.explanation = const Value.absent(),
  });
  QuestionsCompanion.insert({
    this.id = const Value.absent(),
    required int passageId,
    required String type,
    required String prompt,
    this.options = const Value.absent(),
    required String answer,
    this.explanation = const Value.absent(),
  }) : passageId = Value(passageId),
       type = Value(type),
       prompt = Value(prompt),
       answer = Value(answer);
  static Insertable<Question> custom({
    Expression<int>? id,
    Expression<int>? passageId,
    Expression<String>? type,
    Expression<String>? prompt,
    Expression<String>? options,
    Expression<String>? answer,
    Expression<String>? explanation,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (passageId != null) 'passage_id': passageId,
      if (type != null) 'type': type,
      if (prompt != null) 'prompt': prompt,
      if (options != null) 'options': options,
      if (answer != null) 'answer': answer,
      if (explanation != null) 'explanation': explanation,
    });
  }

  QuestionsCompanion copyWith({
    Value<int>? id,
    Value<int>? passageId,
    Value<String>? type,
    Value<String>? prompt,
    Value<String?>? options,
    Value<String>? answer,
    Value<String?>? explanation,
  }) {
    return QuestionsCompanion(
      id: id ?? this.id,
      passageId: passageId ?? this.passageId,
      type: type ?? this.type,
      prompt: prompt ?? this.prompt,
      options: options ?? this.options,
      answer: answer ?? this.answer,
      explanation: explanation ?? this.explanation,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (passageId.present) {
      map['passage_id'] = Variable<int>(passageId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (prompt.present) {
      map['prompt'] = Variable<String>(prompt.value);
    }
    if (options.present) {
      map['options'] = Variable<String>(options.value);
    }
    if (answer.present) {
      map['answer'] = Variable<String>(answer.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionsCompanion(')
          ..write('id: $id, ')
          ..write('passageId: $passageId, ')
          ..write('type: $type, ')
          ..write('prompt: $prompt, ')
          ..write('options: $options, ')
          ..write('answer: $answer, ')
          ..write('explanation: $explanation')
          ..write(')'))
        .toString();
  }
}

class $UserTextsTable extends UserTexts
    with TableInfo<$UserTextsTable, UserText> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserTextsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _promptMeta = const VerificationMeta('prompt');
  @override
  late final GeneratedColumn<String> prompt = GeneratedColumn<String>(
    'prompt',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _selfScoreMeta = const VerificationMeta(
    'selfScore',
  );
  @override
  late final GeneratedColumn<int> selfScore = GeneratedColumn<int>(
    'self_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    prompt,
    body,
    createdAt,
    selfScore,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_texts';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserText> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('prompt')) {
      context.handle(
        _promptMeta,
        prompt.isAcceptableOrUnknown(data['prompt']!, _promptMeta),
      );
    } else if (isInserting) {
      context.missing(_promptMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('self_score')) {
      context.handle(
        _selfScoreMeta,
        selfScore.isAcceptableOrUnknown(data['self_score']!, _selfScoreMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserText map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserText(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      prompt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}prompt'],
          )!,
      body:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}body'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}created_at'],
          )!,
      selfScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}self_score'],
      ),
    );
  }

  @override
  $UserTextsTable createAlias(String alias) {
    return $UserTextsTable(attachedDatabase, alias);
  }
}

class UserText extends DataClass implements Insertable<UserText> {
  final int id;
  final String prompt;
  final String body;
  final int createdAt;
  final int? selfScore;
  const UserText({
    required this.id,
    required this.prompt,
    required this.body,
    required this.createdAt,
    this.selfScore,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['prompt'] = Variable<String>(prompt);
    map['body'] = Variable<String>(body);
    map['created_at'] = Variable<int>(createdAt);
    if (!nullToAbsent || selfScore != null) {
      map['self_score'] = Variable<int>(selfScore);
    }
    return map;
  }

  UserTextsCompanion toCompanion(bool nullToAbsent) {
    return UserTextsCompanion(
      id: Value(id),
      prompt: Value(prompt),
      body: Value(body),
      createdAt: Value(createdAt),
      selfScore:
          selfScore == null && nullToAbsent
              ? const Value.absent()
              : Value(selfScore),
    );
  }

  factory UserText.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserText(
      id: serializer.fromJson<int>(json['id']),
      prompt: serializer.fromJson<String>(json['prompt']),
      body: serializer.fromJson<String>(json['body']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      selfScore: serializer.fromJson<int?>(json['selfScore']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'prompt': serializer.toJson<String>(prompt),
      'body': serializer.toJson<String>(body),
      'createdAt': serializer.toJson<int>(createdAt),
      'selfScore': serializer.toJson<int?>(selfScore),
    };
  }

  UserText copyWith({
    int? id,
    String? prompt,
    String? body,
    int? createdAt,
    Value<int?> selfScore = const Value.absent(),
  }) => UserText(
    id: id ?? this.id,
    prompt: prompt ?? this.prompt,
    body: body ?? this.body,
    createdAt: createdAt ?? this.createdAt,
    selfScore: selfScore.present ? selfScore.value : this.selfScore,
  );
  UserText copyWithCompanion(UserTextsCompanion data) {
    return UserText(
      id: data.id.present ? data.id.value : this.id,
      prompt: data.prompt.present ? data.prompt.value : this.prompt,
      body: data.body.present ? data.body.value : this.body,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      selfScore: data.selfScore.present ? data.selfScore.value : this.selfScore,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserText(')
          ..write('id: $id, ')
          ..write('prompt: $prompt, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt, ')
          ..write('selfScore: $selfScore')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, prompt, body, createdAt, selfScore);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserText &&
          other.id == this.id &&
          other.prompt == this.prompt &&
          other.body == this.body &&
          other.createdAt == this.createdAt &&
          other.selfScore == this.selfScore);
}

class UserTextsCompanion extends UpdateCompanion<UserText> {
  final Value<int> id;
  final Value<String> prompt;
  final Value<String> body;
  final Value<int> createdAt;
  final Value<int?> selfScore;
  const UserTextsCompanion({
    this.id = const Value.absent(),
    this.prompt = const Value.absent(),
    this.body = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.selfScore = const Value.absent(),
  });
  UserTextsCompanion.insert({
    this.id = const Value.absent(),
    required String prompt,
    required String body,
    required int createdAt,
    this.selfScore = const Value.absent(),
  }) : prompt = Value(prompt),
       body = Value(body),
       createdAt = Value(createdAt);
  static Insertable<UserText> custom({
    Expression<int>? id,
    Expression<String>? prompt,
    Expression<String>? body,
    Expression<int>? createdAt,
    Expression<int>? selfScore,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (prompt != null) 'prompt': prompt,
      if (body != null) 'body': body,
      if (createdAt != null) 'created_at': createdAt,
      if (selfScore != null) 'self_score': selfScore,
    });
  }

  UserTextsCompanion copyWith({
    Value<int>? id,
    Value<String>? prompt,
    Value<String>? body,
    Value<int>? createdAt,
    Value<int?>? selfScore,
  }) {
    return UserTextsCompanion(
      id: id ?? this.id,
      prompt: prompt ?? this.prompt,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      selfScore: selfScore ?? this.selfScore,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (prompt.present) {
      map['prompt'] = Variable<String>(prompt.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (selfScore.present) {
      map['self_score'] = Variable<int>(selfScore.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserTextsCompanion(')
          ..write('id: $id, ')
          ..write('prompt: $prompt, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt, ')
          ..write('selfScore: $selfScore')
          ..write(')'))
        .toString();
  }
}

class $RecordingsTable extends Recordings
    with TableInfo<$RecordingsTable, Recording> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecordingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _promptMeta = const VerificationMeta('prompt');
  @override
  late final GeneratedColumn<String> prompt = GeneratedColumn<String>(
    'prompt',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sttTextMeta = const VerificationMeta(
    'sttText',
  );
  @override
  late final GeneratedColumn<String> sttText = GeneratedColumn<String>(
    'stt_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<double> score = GeneratedColumn<double>(
    'score',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    prompt,
    filePath,
    durationMs,
    sttText,
    score,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recordings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Recording> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('prompt')) {
      context.handle(
        _promptMeta,
        prompt.isAcceptableOrUnknown(data['prompt']!, _promptMeta),
      );
    } else if (isInserting) {
      context.missing(_promptMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    } else if (isInserting) {
      context.missing(_durationMsMeta);
    }
    if (data.containsKey('stt_text')) {
      context.handle(
        _sttTextMeta,
        sttText.isAcceptableOrUnknown(data['stt_text']!, _sttTextMeta),
      );
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Recording map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Recording(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      prompt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}prompt'],
          )!,
      filePath:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}file_path'],
          )!,
      durationMs:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}duration_ms'],
          )!,
      sttText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}stt_text'],
      ),
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}score'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $RecordingsTable createAlias(String alias) {
    return $RecordingsTable(attachedDatabase, alias);
  }
}

class Recording extends DataClass implements Insertable<Recording> {
  final int id;
  final String prompt;
  final String filePath;
  final int durationMs;
  final String? sttText;
  final double? score;
  final int createdAt;
  const Recording({
    required this.id,
    required this.prompt,
    required this.filePath,
    required this.durationMs,
    this.sttText,
    this.score,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['prompt'] = Variable<String>(prompt);
    map['file_path'] = Variable<String>(filePath);
    map['duration_ms'] = Variable<int>(durationMs);
    if (!nullToAbsent || sttText != null) {
      map['stt_text'] = Variable<String>(sttText);
    }
    if (!nullToAbsent || score != null) {
      map['score'] = Variable<double>(score);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  RecordingsCompanion toCompanion(bool nullToAbsent) {
    return RecordingsCompanion(
      id: Value(id),
      prompt: Value(prompt),
      filePath: Value(filePath),
      durationMs: Value(durationMs),
      sttText:
          sttText == null && nullToAbsent
              ? const Value.absent()
              : Value(sttText),
      score:
          score == null && nullToAbsent ? const Value.absent() : Value(score),
      createdAt: Value(createdAt),
    );
  }

  factory Recording.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Recording(
      id: serializer.fromJson<int>(json['id']),
      prompt: serializer.fromJson<String>(json['prompt']),
      filePath: serializer.fromJson<String>(json['filePath']),
      durationMs: serializer.fromJson<int>(json['durationMs']),
      sttText: serializer.fromJson<String?>(json['sttText']),
      score: serializer.fromJson<double?>(json['score']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'prompt': serializer.toJson<String>(prompt),
      'filePath': serializer.toJson<String>(filePath),
      'durationMs': serializer.toJson<int>(durationMs),
      'sttText': serializer.toJson<String?>(sttText),
      'score': serializer.toJson<double?>(score),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  Recording copyWith({
    int? id,
    String? prompt,
    String? filePath,
    int? durationMs,
    Value<String?> sttText = const Value.absent(),
    Value<double?> score = const Value.absent(),
    int? createdAt,
  }) => Recording(
    id: id ?? this.id,
    prompt: prompt ?? this.prompt,
    filePath: filePath ?? this.filePath,
    durationMs: durationMs ?? this.durationMs,
    sttText: sttText.present ? sttText.value : this.sttText,
    score: score.present ? score.value : this.score,
    createdAt: createdAt ?? this.createdAt,
  );
  Recording copyWithCompanion(RecordingsCompanion data) {
    return Recording(
      id: data.id.present ? data.id.value : this.id,
      prompt: data.prompt.present ? data.prompt.value : this.prompt,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      durationMs:
          data.durationMs.present ? data.durationMs.value : this.durationMs,
      sttText: data.sttText.present ? data.sttText.value : this.sttText,
      score: data.score.present ? data.score.value : this.score,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Recording(')
          ..write('id: $id, ')
          ..write('prompt: $prompt, ')
          ..write('filePath: $filePath, ')
          ..write('durationMs: $durationMs, ')
          ..write('sttText: $sttText, ')
          ..write('score: $score, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, prompt, filePath, durationMs, sttText, score, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Recording &&
          other.id == this.id &&
          other.prompt == this.prompt &&
          other.filePath == this.filePath &&
          other.durationMs == this.durationMs &&
          other.sttText == this.sttText &&
          other.score == this.score &&
          other.createdAt == this.createdAt);
}

class RecordingsCompanion extends UpdateCompanion<Recording> {
  final Value<int> id;
  final Value<String> prompt;
  final Value<String> filePath;
  final Value<int> durationMs;
  final Value<String?> sttText;
  final Value<double?> score;
  final Value<int> createdAt;
  const RecordingsCompanion({
    this.id = const Value.absent(),
    this.prompt = const Value.absent(),
    this.filePath = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.sttText = const Value.absent(),
    this.score = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  RecordingsCompanion.insert({
    this.id = const Value.absent(),
    required String prompt,
    required String filePath,
    required int durationMs,
    this.sttText = const Value.absent(),
    this.score = const Value.absent(),
    required int createdAt,
  }) : prompt = Value(prompt),
       filePath = Value(filePath),
       durationMs = Value(durationMs),
       createdAt = Value(createdAt);
  static Insertable<Recording> custom({
    Expression<int>? id,
    Expression<String>? prompt,
    Expression<String>? filePath,
    Expression<int>? durationMs,
    Expression<String>? sttText,
    Expression<double>? score,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (prompt != null) 'prompt': prompt,
      if (filePath != null) 'file_path': filePath,
      if (durationMs != null) 'duration_ms': durationMs,
      if (sttText != null) 'stt_text': sttText,
      if (score != null) 'score': score,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  RecordingsCompanion copyWith({
    Value<int>? id,
    Value<String>? prompt,
    Value<String>? filePath,
    Value<int>? durationMs,
    Value<String?>? sttText,
    Value<double?>? score,
    Value<int>? createdAt,
  }) {
    return RecordingsCompanion(
      id: id ?? this.id,
      prompt: prompt ?? this.prompt,
      filePath: filePath ?? this.filePath,
      durationMs: durationMs ?? this.durationMs,
      sttText: sttText ?? this.sttText,
      score: score ?? this.score,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (prompt.present) {
      map['prompt'] = Variable<String>(prompt.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (sttText.present) {
      map['stt_text'] = Variable<String>(sttText.value);
    }
    if (score.present) {
      map['score'] = Variable<double>(score.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecordingsCompanion(')
          ..write('id: $id, ')
          ..write('prompt: $prompt, ')
          ..write('filePath: $filePath, ')
          ..write('durationMs: $durationMs, ')
          ..write('sttText: $sttText, ')
          ..write('score: $score, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DailyStatsTable extends DailyStats
    with TableInfo<$DailyStatsTable, DailyStat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyStatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<String> day = GeneratedColumn<String>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minutesMeta = const VerificationMeta(
    'minutes',
  );
  @override
  late final GeneratedColumn<int> minutes = GeneratedColumn<int>(
    'minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _xpMeta = const VerificationMeta('xp');
  @override
  late final GeneratedColumn<int> xp = GeneratedColumn<int>(
    'xp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _itemsReviewedMeta = const VerificationMeta(
    'itemsReviewed',
  );
  @override
  late final GeneratedColumn<int> itemsReviewed = GeneratedColumn<int>(
    'items_reviewed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _goalMetMeta = const VerificationMeta(
    'goalMet',
  );
  @override
  late final GeneratedColumn<int> goalMet = GeneratedColumn<int>(
    'goal_met',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    day,
    minutes,
    xp,
    itemsReviewed,
    goalMet,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_stats';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyStat> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('minutes')) {
      context.handle(
        _minutesMeta,
        minutes.isAcceptableOrUnknown(data['minutes']!, _minutesMeta),
      );
    }
    if (data.containsKey('xp')) {
      context.handle(_xpMeta, xp.isAcceptableOrUnknown(data['xp']!, _xpMeta));
    }
    if (data.containsKey('items_reviewed')) {
      context.handle(
        _itemsReviewedMeta,
        itemsReviewed.isAcceptableOrUnknown(
          data['items_reviewed']!,
          _itemsReviewedMeta,
        ),
      );
    }
    if (data.containsKey('goal_met')) {
      context.handle(
        _goalMetMeta,
        goalMet.isAcceptableOrUnknown(data['goal_met']!, _goalMetMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {day};
  @override
  DailyStat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyStat(
      day:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}day'],
          )!,
      minutes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}minutes'],
          )!,
      xp:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}xp'],
          )!,
      itemsReviewed:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}items_reviewed'],
          )!,
      goalMet:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}goal_met'],
          )!,
    );
  }

  @override
  $DailyStatsTable createAlias(String alias) {
    return $DailyStatsTable(attachedDatabase, alias);
  }
}

class DailyStat extends DataClass implements Insertable<DailyStat> {
  final String day;
  final int minutes;
  final int xp;
  final int itemsReviewed;
  final int goalMet;
  const DailyStat({
    required this.day,
    required this.minutes,
    required this.xp,
    required this.itemsReviewed,
    required this.goalMet,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['day'] = Variable<String>(day);
    map['minutes'] = Variable<int>(minutes);
    map['xp'] = Variable<int>(xp);
    map['items_reviewed'] = Variable<int>(itemsReviewed);
    map['goal_met'] = Variable<int>(goalMet);
    return map;
  }

  DailyStatsCompanion toCompanion(bool nullToAbsent) {
    return DailyStatsCompanion(
      day: Value(day),
      minutes: Value(minutes),
      xp: Value(xp),
      itemsReviewed: Value(itemsReviewed),
      goalMet: Value(goalMet),
    );
  }

  factory DailyStat.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyStat(
      day: serializer.fromJson<String>(json['day']),
      minutes: serializer.fromJson<int>(json['minutes']),
      xp: serializer.fromJson<int>(json['xp']),
      itemsReviewed: serializer.fromJson<int>(json['itemsReviewed']),
      goalMet: serializer.fromJson<int>(json['goalMet']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'day': serializer.toJson<String>(day),
      'minutes': serializer.toJson<int>(minutes),
      'xp': serializer.toJson<int>(xp),
      'itemsReviewed': serializer.toJson<int>(itemsReviewed),
      'goalMet': serializer.toJson<int>(goalMet),
    };
  }

  DailyStat copyWith({
    String? day,
    int? minutes,
    int? xp,
    int? itemsReviewed,
    int? goalMet,
  }) => DailyStat(
    day: day ?? this.day,
    minutes: minutes ?? this.minutes,
    xp: xp ?? this.xp,
    itemsReviewed: itemsReviewed ?? this.itemsReviewed,
    goalMet: goalMet ?? this.goalMet,
  );
  DailyStat copyWithCompanion(DailyStatsCompanion data) {
    return DailyStat(
      day: data.day.present ? data.day.value : this.day,
      minutes: data.minutes.present ? data.minutes.value : this.minutes,
      xp: data.xp.present ? data.xp.value : this.xp,
      itemsReviewed:
          data.itemsReviewed.present
              ? data.itemsReviewed.value
              : this.itemsReviewed,
      goalMet: data.goalMet.present ? data.goalMet.value : this.goalMet,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyStat(')
          ..write('day: $day, ')
          ..write('minutes: $minutes, ')
          ..write('xp: $xp, ')
          ..write('itemsReviewed: $itemsReviewed, ')
          ..write('goalMet: $goalMet')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(day, minutes, xp, itemsReviewed, goalMet);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyStat &&
          other.day == this.day &&
          other.minutes == this.minutes &&
          other.xp == this.xp &&
          other.itemsReviewed == this.itemsReviewed &&
          other.goalMet == this.goalMet);
}

class DailyStatsCompanion extends UpdateCompanion<DailyStat> {
  final Value<String> day;
  final Value<int> minutes;
  final Value<int> xp;
  final Value<int> itemsReviewed;
  final Value<int> goalMet;
  final Value<int> rowid;
  const DailyStatsCompanion({
    this.day = const Value.absent(),
    this.minutes = const Value.absent(),
    this.xp = const Value.absent(),
    this.itemsReviewed = const Value.absent(),
    this.goalMet = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyStatsCompanion.insert({
    required String day,
    this.minutes = const Value.absent(),
    this.xp = const Value.absent(),
    this.itemsReviewed = const Value.absent(),
    this.goalMet = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : day = Value(day);
  static Insertable<DailyStat> custom({
    Expression<String>? day,
    Expression<int>? minutes,
    Expression<int>? xp,
    Expression<int>? itemsReviewed,
    Expression<int>? goalMet,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (day != null) 'day': day,
      if (minutes != null) 'minutes': minutes,
      if (xp != null) 'xp': xp,
      if (itemsReviewed != null) 'items_reviewed': itemsReviewed,
      if (goalMet != null) 'goal_met': goalMet,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyStatsCompanion copyWith({
    Value<String>? day,
    Value<int>? minutes,
    Value<int>? xp,
    Value<int>? itemsReviewed,
    Value<int>? goalMet,
    Value<int>? rowid,
  }) {
    return DailyStatsCompanion(
      day: day ?? this.day,
      minutes: minutes ?? this.minutes,
      xp: xp ?? this.xp,
      itemsReviewed: itemsReviewed ?? this.itemsReviewed,
      goalMet: goalMet ?? this.goalMet,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (day.present) {
      map['day'] = Variable<String>(day.value);
    }
    if (minutes.present) {
      map['minutes'] = Variable<int>(minutes.value);
    }
    if (xp.present) {
      map['xp'] = Variable<int>(xp.value);
    }
    if (itemsReviewed.present) {
      map['items_reviewed'] = Variable<int>(itemsReviewed.value);
    }
    if (goalMet.present) {
      map['goal_met'] = Variable<int>(goalMet.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyStatsCompanion(')
          ..write('day: $day, ')
          ..write('minutes: $minutes, ')
          ..write('xp: $xp, ')
          ..write('itemsReviewed: $itemsReviewed, ')
          ..write('goalMet: $goalMet, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StreaksTable extends Streaks with TableInfo<$StreaksTable, Streak> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StreaksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentMeta = const VerificationMeta(
    'current',
  );
  @override
  late final GeneratedColumn<int> current = GeneratedColumn<int>(
    'current',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _bestMeta = const VerificationMeta('best');
  @override
  late final GeneratedColumn<int> best = GeneratedColumn<int>(
    'best',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _freezesMeta = const VerificationMeta(
    'freezes',
  );
  @override
  late final GeneratedColumn<int> freezes = GeneratedColumn<int>(
    'freezes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastDayMeta = const VerificationMeta(
    'lastDay',
  );
  @override
  late final GeneratedColumn<String> lastDay = GeneratedColumn<String>(
    'last_day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _totalDaysMeta = const VerificationMeta(
    'totalDays',
  );
  @override
  late final GeneratedColumn<int> totalDays = GeneratedColumn<int>(
    'total_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    current,
    best,
    freezes,
    lastDay,
    totalDays,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'streaks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Streak> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('current')) {
      context.handle(
        _currentMeta,
        current.isAcceptableOrUnknown(data['current']!, _currentMeta),
      );
    }
    if (data.containsKey('best')) {
      context.handle(
        _bestMeta,
        best.isAcceptableOrUnknown(data['best']!, _bestMeta),
      );
    }
    if (data.containsKey('freezes')) {
      context.handle(
        _freezesMeta,
        freezes.isAcceptableOrUnknown(data['freezes']!, _freezesMeta),
      );
    }
    if (data.containsKey('last_day')) {
      context.handle(
        _lastDayMeta,
        lastDay.isAcceptableOrUnknown(data['last_day']!, _lastDayMeta),
      );
    }
    if (data.containsKey('total_days')) {
      context.handle(
        _totalDaysMeta,
        totalDays.isAcceptableOrUnknown(data['total_days']!, _totalDaysMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Streak map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Streak(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      current:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}current'],
          )!,
      best:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}best'],
          )!,
      freezes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}freezes'],
          )!,
      lastDay:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}last_day'],
          )!,
      totalDays:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}total_days'],
          )!,
    );
  }

  @override
  $StreaksTable createAlias(String alias) {
    return $StreaksTable(attachedDatabase, alias);
  }
}

class Streak extends DataClass implements Insertable<Streak> {
  final int id;
  final int current;
  final int best;
  final int freezes;
  final String lastDay;
  final int totalDays;
  const Streak({
    required this.id,
    required this.current,
    required this.best,
    required this.freezes,
    required this.lastDay,
    required this.totalDays,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['current'] = Variable<int>(current);
    map['best'] = Variable<int>(best);
    map['freezes'] = Variable<int>(freezes);
    map['last_day'] = Variable<String>(lastDay);
    map['total_days'] = Variable<int>(totalDays);
    return map;
  }

  StreaksCompanion toCompanion(bool nullToAbsent) {
    return StreaksCompanion(
      id: Value(id),
      current: Value(current),
      best: Value(best),
      freezes: Value(freezes),
      lastDay: Value(lastDay),
      totalDays: Value(totalDays),
    );
  }

  factory Streak.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Streak(
      id: serializer.fromJson<int>(json['id']),
      current: serializer.fromJson<int>(json['current']),
      best: serializer.fromJson<int>(json['best']),
      freezes: serializer.fromJson<int>(json['freezes']),
      lastDay: serializer.fromJson<String>(json['lastDay']),
      totalDays: serializer.fromJson<int>(json['totalDays']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'current': serializer.toJson<int>(current),
      'best': serializer.toJson<int>(best),
      'freezes': serializer.toJson<int>(freezes),
      'lastDay': serializer.toJson<String>(lastDay),
      'totalDays': serializer.toJson<int>(totalDays),
    };
  }

  Streak copyWith({
    int? id,
    int? current,
    int? best,
    int? freezes,
    String? lastDay,
    int? totalDays,
  }) => Streak(
    id: id ?? this.id,
    current: current ?? this.current,
    best: best ?? this.best,
    freezes: freezes ?? this.freezes,
    lastDay: lastDay ?? this.lastDay,
    totalDays: totalDays ?? this.totalDays,
  );
  Streak copyWithCompanion(StreaksCompanion data) {
    return Streak(
      id: data.id.present ? data.id.value : this.id,
      current: data.current.present ? data.current.value : this.current,
      best: data.best.present ? data.best.value : this.best,
      freezes: data.freezes.present ? data.freezes.value : this.freezes,
      lastDay: data.lastDay.present ? data.lastDay.value : this.lastDay,
      totalDays: data.totalDays.present ? data.totalDays.value : this.totalDays,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Streak(')
          ..write('id: $id, ')
          ..write('current: $current, ')
          ..write('best: $best, ')
          ..write('freezes: $freezes, ')
          ..write('lastDay: $lastDay, ')
          ..write('totalDays: $totalDays')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, current, best, freezes, lastDay, totalDays);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Streak &&
          other.id == this.id &&
          other.current == this.current &&
          other.best == this.best &&
          other.freezes == this.freezes &&
          other.lastDay == this.lastDay &&
          other.totalDays == this.totalDays);
}

class StreaksCompanion extends UpdateCompanion<Streak> {
  final Value<int> id;
  final Value<int> current;
  final Value<int> best;
  final Value<int> freezes;
  final Value<String> lastDay;
  final Value<int> totalDays;
  const StreaksCompanion({
    this.id = const Value.absent(),
    this.current = const Value.absent(),
    this.best = const Value.absent(),
    this.freezes = const Value.absent(),
    this.lastDay = const Value.absent(),
    this.totalDays = const Value.absent(),
  });
  StreaksCompanion.insert({
    this.id = const Value.absent(),
    this.current = const Value.absent(),
    this.best = const Value.absent(),
    this.freezes = const Value.absent(),
    this.lastDay = const Value.absent(),
    this.totalDays = const Value.absent(),
  });
  static Insertable<Streak> custom({
    Expression<int>? id,
    Expression<int>? current,
    Expression<int>? best,
    Expression<int>? freezes,
    Expression<String>? lastDay,
    Expression<int>? totalDays,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (current != null) 'current': current,
      if (best != null) 'best': best,
      if (freezes != null) 'freezes': freezes,
      if (lastDay != null) 'last_day': lastDay,
      if (totalDays != null) 'total_days': totalDays,
    });
  }

  StreaksCompanion copyWith({
    Value<int>? id,
    Value<int>? current,
    Value<int>? best,
    Value<int>? freezes,
    Value<String>? lastDay,
    Value<int>? totalDays,
  }) {
    return StreaksCompanion(
      id: id ?? this.id,
      current: current ?? this.current,
      best: best ?? this.best,
      freezes: freezes ?? this.freezes,
      lastDay: lastDay ?? this.lastDay,
      totalDays: totalDays ?? this.totalDays,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (current.present) {
      map['current'] = Variable<int>(current.value);
    }
    if (best.present) {
      map['best'] = Variable<int>(best.value);
    }
    if (freezes.present) {
      map['freezes'] = Variable<int>(freezes.value);
    }
    if (lastDay.present) {
      map['last_day'] = Variable<String>(lastDay.value);
    }
    if (totalDays.present) {
      map['total_days'] = Variable<int>(totalDays.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StreaksCompanion(')
          ..write('id: $id, ')
          ..write('current: $current, ')
          ..write('best: $best, ')
          ..write('freezes: $freezes, ')
          ..write('lastDay: $lastDay, ')
          ..write('totalDays: $totalDays')
          ..write(')'))
        .toString();
  }
}

class $AchievementsTable extends Achievements
    with TableInfo<$AchievementsTable, Achievement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AchievementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unlockedAtMeta = const VerificationMeta(
    'unlockedAt',
  );
  @override
  late final GeneratedColumn<int> unlockedAt = GeneratedColumn<int>(
    'unlocked_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [code, unlockedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'achievements';
  @override
  VerificationContext validateIntegrity(
    Insertable<Achievement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('unlocked_at')) {
      context.handle(
        _unlockedAtMeta,
        unlockedAt.isAcceptableOrUnknown(data['unlocked_at']!, _unlockedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_unlockedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  Achievement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Achievement(
      code:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}code'],
          )!,
      unlockedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}unlocked_at'],
          )!,
    );
  }

  @override
  $AchievementsTable createAlias(String alias) {
    return $AchievementsTable(attachedDatabase, alias);
  }
}

class Achievement extends DataClass implements Insertable<Achievement> {
  final String code;
  final int unlockedAt;
  const Achievement({required this.code, required this.unlockedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['unlocked_at'] = Variable<int>(unlockedAt);
    return map;
  }

  AchievementsCompanion toCompanion(bool nullToAbsent) {
    return AchievementsCompanion(
      code: Value(code),
      unlockedAt: Value(unlockedAt),
    );
  }

  factory Achievement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Achievement(
      code: serializer.fromJson<String>(json['code']),
      unlockedAt: serializer.fromJson<int>(json['unlockedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'unlockedAt': serializer.toJson<int>(unlockedAt),
    };
  }

  Achievement copyWith({String? code, int? unlockedAt}) => Achievement(
    code: code ?? this.code,
    unlockedAt: unlockedAt ?? this.unlockedAt,
  );
  Achievement copyWithCompanion(AchievementsCompanion data) {
    return Achievement(
      code: data.code.present ? data.code.value : this.code,
      unlockedAt:
          data.unlockedAt.present ? data.unlockedAt.value : this.unlockedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Achievement(')
          ..write('code: $code, ')
          ..write('unlockedAt: $unlockedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(code, unlockedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Achievement &&
          other.code == this.code &&
          other.unlockedAt == this.unlockedAt);
}

class AchievementsCompanion extends UpdateCompanion<Achievement> {
  final Value<String> code;
  final Value<int> unlockedAt;
  final Value<int> rowid;
  const AchievementsCompanion({
    this.code = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AchievementsCompanion.insert({
    required String code,
    required int unlockedAt,
    this.rowid = const Value.absent(),
  }) : code = Value(code),
       unlockedAt = Value(unlockedAt);
  static Insertable<Achievement> custom({
    Expression<String>? code,
    Expression<int>? unlockedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (unlockedAt != null) 'unlocked_at': unlockedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AchievementsCompanion copyWith({
    Value<String>? code,
    Value<int>? unlockedAt,
    Value<int>? rowid,
  }) {
    return AchievementsCompanion(
      code: code ?? this.code,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (unlockedAt.present) {
      map['unlocked_at'] = Variable<int>(unlockedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AchievementsCompanion(')
          ..write('code: $code, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GameSessionsTable extends GameSessions
    with TableInfo<$GameSessionsTable, GameSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GameSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _gameMeta = const VerificationMeta('game');
  @override
  late final GeneratedColumn<String> game = GeneratedColumn<String>(
    'game',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<int> startedAt = GeneratedColumn<int>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accuracyMeta = const VerificationMeta(
    'accuracy',
  );
  @override
  late final GeneratedColumn<double> accuracy = GeneratedColumn<double>(
    'accuracy',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _xpEarnedMeta = const VerificationMeta(
    'xpEarned',
  );
  @override
  late final GeneratedColumn<int> xpEarned = GeneratedColumn<int>(
    'xp_earned',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hintsUsedMeta = const VerificationMeta(
    'hintsUsed',
  );
  @override
  late final GeneratedColumn<int> hintsUsed = GeneratedColumn<int>(
    'hints_used',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _extraJsonMeta = const VerificationMeta(
    'extraJson',
  );
  @override
  late final GeneratedColumn<String> extraJson = GeneratedColumn<String>(
    'extra_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    game,
    mode,
    level,
    startedAt,
    durationMs,
    accuracy,
    score,
    xpEarned,
    hintsUsed,
    extraJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'game_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<GameSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('game')) {
      context.handle(
        _gameMeta,
        game.isAcceptableOrUnknown(data['game']!, _gameMeta),
      );
    } else if (isInserting) {
      context.missing(_gameMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    } else if (isInserting) {
      context.missing(_durationMsMeta);
    }
    if (data.containsKey('accuracy')) {
      context.handle(
        _accuracyMeta,
        accuracy.isAcceptableOrUnknown(data['accuracy']!, _accuracyMeta),
      );
    } else if (isInserting) {
      context.missing(_accuracyMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('xp_earned')) {
      context.handle(
        _xpEarnedMeta,
        xpEarned.isAcceptableOrUnknown(data['xp_earned']!, _xpEarnedMeta),
      );
    } else if (isInserting) {
      context.missing(_xpEarnedMeta);
    }
    if (data.containsKey('hints_used')) {
      context.handle(
        _hintsUsedMeta,
        hintsUsed.isAcceptableOrUnknown(data['hints_used']!, _hintsUsedMeta),
      );
    }
    if (data.containsKey('extra_json')) {
      context.handle(
        _extraJsonMeta,
        extraJson.isAcceptableOrUnknown(data['extra_json']!, _extraJsonMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GameSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GameSession(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      game:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}game'],
          )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mode'],
      ),
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      ),
      startedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}started_at'],
          )!,
      durationMs:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}duration_ms'],
          )!,
      accuracy:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}accuracy'],
          )!,
      score:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}score'],
          )!,
      xpEarned:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}xp_earned'],
          )!,
      hintsUsed:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}hints_used'],
          )!,
      extraJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}extra_json'],
      ),
    );
  }

  @override
  $GameSessionsTable createAlias(String alias) {
    return $GameSessionsTable(attachedDatabase, alias);
  }
}

class GameSession extends DataClass implements Insertable<GameSession> {
  final int id;
  final String game;
  final String? mode;
  final int? level;
  final int startedAt;
  final int durationMs;
  final double accuracy;
  final int score;
  final int xpEarned;
  final int hintsUsed;
  final String? extraJson;
  const GameSession({
    required this.id,
    required this.game,
    this.mode,
    this.level,
    required this.startedAt,
    required this.durationMs,
    required this.accuracy,
    required this.score,
    required this.xpEarned,
    required this.hintsUsed,
    this.extraJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['game'] = Variable<String>(game);
    if (!nullToAbsent || mode != null) {
      map['mode'] = Variable<String>(mode);
    }
    if (!nullToAbsent || level != null) {
      map['level'] = Variable<int>(level);
    }
    map['started_at'] = Variable<int>(startedAt);
    map['duration_ms'] = Variable<int>(durationMs);
    map['accuracy'] = Variable<double>(accuracy);
    map['score'] = Variable<int>(score);
    map['xp_earned'] = Variable<int>(xpEarned);
    map['hints_used'] = Variable<int>(hintsUsed);
    if (!nullToAbsent || extraJson != null) {
      map['extra_json'] = Variable<String>(extraJson);
    }
    return map;
  }

  GameSessionsCompanion toCompanion(bool nullToAbsent) {
    return GameSessionsCompanion(
      id: Value(id),
      game: Value(game),
      mode: mode == null && nullToAbsent ? const Value.absent() : Value(mode),
      level:
          level == null && nullToAbsent ? const Value.absent() : Value(level),
      startedAt: Value(startedAt),
      durationMs: Value(durationMs),
      accuracy: Value(accuracy),
      score: Value(score),
      xpEarned: Value(xpEarned),
      hintsUsed: Value(hintsUsed),
      extraJson:
          extraJson == null && nullToAbsent
              ? const Value.absent()
              : Value(extraJson),
    );
  }

  factory GameSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GameSession(
      id: serializer.fromJson<int>(json['id']),
      game: serializer.fromJson<String>(json['game']),
      mode: serializer.fromJson<String?>(json['mode']),
      level: serializer.fromJson<int?>(json['level']),
      startedAt: serializer.fromJson<int>(json['startedAt']),
      durationMs: serializer.fromJson<int>(json['durationMs']),
      accuracy: serializer.fromJson<double>(json['accuracy']),
      score: serializer.fromJson<int>(json['score']),
      xpEarned: serializer.fromJson<int>(json['xpEarned']),
      hintsUsed: serializer.fromJson<int>(json['hintsUsed']),
      extraJson: serializer.fromJson<String?>(json['extraJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'game': serializer.toJson<String>(game),
      'mode': serializer.toJson<String?>(mode),
      'level': serializer.toJson<int?>(level),
      'startedAt': serializer.toJson<int>(startedAt),
      'durationMs': serializer.toJson<int>(durationMs),
      'accuracy': serializer.toJson<double>(accuracy),
      'score': serializer.toJson<int>(score),
      'xpEarned': serializer.toJson<int>(xpEarned),
      'hintsUsed': serializer.toJson<int>(hintsUsed),
      'extraJson': serializer.toJson<String?>(extraJson),
    };
  }

  GameSession copyWith({
    int? id,
    String? game,
    Value<String?> mode = const Value.absent(),
    Value<int?> level = const Value.absent(),
    int? startedAt,
    int? durationMs,
    double? accuracy,
    int? score,
    int? xpEarned,
    int? hintsUsed,
    Value<String?> extraJson = const Value.absent(),
  }) => GameSession(
    id: id ?? this.id,
    game: game ?? this.game,
    mode: mode.present ? mode.value : this.mode,
    level: level.present ? level.value : this.level,
    startedAt: startedAt ?? this.startedAt,
    durationMs: durationMs ?? this.durationMs,
    accuracy: accuracy ?? this.accuracy,
    score: score ?? this.score,
    xpEarned: xpEarned ?? this.xpEarned,
    hintsUsed: hintsUsed ?? this.hintsUsed,
    extraJson: extraJson.present ? extraJson.value : this.extraJson,
  );
  GameSession copyWithCompanion(GameSessionsCompanion data) {
    return GameSession(
      id: data.id.present ? data.id.value : this.id,
      game: data.game.present ? data.game.value : this.game,
      mode: data.mode.present ? data.mode.value : this.mode,
      level: data.level.present ? data.level.value : this.level,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      durationMs:
          data.durationMs.present ? data.durationMs.value : this.durationMs,
      accuracy: data.accuracy.present ? data.accuracy.value : this.accuracy,
      score: data.score.present ? data.score.value : this.score,
      xpEarned: data.xpEarned.present ? data.xpEarned.value : this.xpEarned,
      hintsUsed: data.hintsUsed.present ? data.hintsUsed.value : this.hintsUsed,
      extraJson: data.extraJson.present ? data.extraJson.value : this.extraJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GameSession(')
          ..write('id: $id, ')
          ..write('game: $game, ')
          ..write('mode: $mode, ')
          ..write('level: $level, ')
          ..write('startedAt: $startedAt, ')
          ..write('durationMs: $durationMs, ')
          ..write('accuracy: $accuracy, ')
          ..write('score: $score, ')
          ..write('xpEarned: $xpEarned, ')
          ..write('hintsUsed: $hintsUsed, ')
          ..write('extraJson: $extraJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    game,
    mode,
    level,
    startedAt,
    durationMs,
    accuracy,
    score,
    xpEarned,
    hintsUsed,
    extraJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GameSession &&
          other.id == this.id &&
          other.game == this.game &&
          other.mode == this.mode &&
          other.level == this.level &&
          other.startedAt == this.startedAt &&
          other.durationMs == this.durationMs &&
          other.accuracy == this.accuracy &&
          other.score == this.score &&
          other.xpEarned == this.xpEarned &&
          other.hintsUsed == this.hintsUsed &&
          other.extraJson == this.extraJson);
}

class GameSessionsCompanion extends UpdateCompanion<GameSession> {
  final Value<int> id;
  final Value<String> game;
  final Value<String?> mode;
  final Value<int?> level;
  final Value<int> startedAt;
  final Value<int> durationMs;
  final Value<double> accuracy;
  final Value<int> score;
  final Value<int> xpEarned;
  final Value<int> hintsUsed;
  final Value<String?> extraJson;
  const GameSessionsCompanion({
    this.id = const Value.absent(),
    this.game = const Value.absent(),
    this.mode = const Value.absent(),
    this.level = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.accuracy = const Value.absent(),
    this.score = const Value.absent(),
    this.xpEarned = const Value.absent(),
    this.hintsUsed = const Value.absent(),
    this.extraJson = const Value.absent(),
  });
  GameSessionsCompanion.insert({
    this.id = const Value.absent(),
    required String game,
    this.mode = const Value.absent(),
    this.level = const Value.absent(),
    required int startedAt,
    required int durationMs,
    required double accuracy,
    required int score,
    required int xpEarned,
    this.hintsUsed = const Value.absent(),
    this.extraJson = const Value.absent(),
  }) : game = Value(game),
       startedAt = Value(startedAt),
       durationMs = Value(durationMs),
       accuracy = Value(accuracy),
       score = Value(score),
       xpEarned = Value(xpEarned);
  static Insertable<GameSession> custom({
    Expression<int>? id,
    Expression<String>? game,
    Expression<String>? mode,
    Expression<int>? level,
    Expression<int>? startedAt,
    Expression<int>? durationMs,
    Expression<double>? accuracy,
    Expression<int>? score,
    Expression<int>? xpEarned,
    Expression<int>? hintsUsed,
    Expression<String>? extraJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (game != null) 'game': game,
      if (mode != null) 'mode': mode,
      if (level != null) 'level': level,
      if (startedAt != null) 'started_at': startedAt,
      if (durationMs != null) 'duration_ms': durationMs,
      if (accuracy != null) 'accuracy': accuracy,
      if (score != null) 'score': score,
      if (xpEarned != null) 'xp_earned': xpEarned,
      if (hintsUsed != null) 'hints_used': hintsUsed,
      if (extraJson != null) 'extra_json': extraJson,
    });
  }

  GameSessionsCompanion copyWith({
    Value<int>? id,
    Value<String>? game,
    Value<String?>? mode,
    Value<int?>? level,
    Value<int>? startedAt,
    Value<int>? durationMs,
    Value<double>? accuracy,
    Value<int>? score,
    Value<int>? xpEarned,
    Value<int>? hintsUsed,
    Value<String?>? extraJson,
  }) {
    return GameSessionsCompanion(
      id: id ?? this.id,
      game: game ?? this.game,
      mode: mode ?? this.mode,
      level: level ?? this.level,
      startedAt: startedAt ?? this.startedAt,
      durationMs: durationMs ?? this.durationMs,
      accuracy: accuracy ?? this.accuracy,
      score: score ?? this.score,
      xpEarned: xpEarned ?? this.xpEarned,
      hintsUsed: hintsUsed ?? this.hintsUsed,
      extraJson: extraJson ?? this.extraJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (game.present) {
      map['game'] = Variable<String>(game.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<int>(startedAt.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (accuracy.present) {
      map['accuracy'] = Variable<double>(accuracy.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (xpEarned.present) {
      map['xp_earned'] = Variable<int>(xpEarned.value);
    }
    if (hintsUsed.present) {
      map['hints_used'] = Variable<int>(hintsUsed.value);
    }
    if (extraJson.present) {
      map['extra_json'] = Variable<String>(extraJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GameSessionsCompanion(')
          ..write('id: $id, ')
          ..write('game: $game, ')
          ..write('mode: $mode, ')
          ..write('level: $level, ')
          ..write('startedAt: $startedAt, ')
          ..write('durationMs: $durationMs, ')
          ..write('accuracy: $accuracy, ')
          ..write('score: $score, ')
          ..write('xpEarned: $xpEarned, ')
          ..write('hintsUsed: $hintsUsed, ')
          ..write('extraJson: $extraJson')
          ..write(')'))
        .toString();
  }
}

class $PersonalBestsTable extends PersonalBests
    with TableInfo<$PersonalBestsTable, PersonalBest> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonalBestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _gameMeta = const VerificationMeta('game');
  @override
  late final GeneratedColumn<String> game = GeneratedColumn<String>(
    'game',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _metricMeta = const VerificationMeta('metric');
  @override
  late final GeneratedColumn<String> metric = GeneratedColumn<String>(
    'metric',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _setAtMeta = const VerificationMeta('setAt');
  @override
  late final GeneratedColumn<int> setAt = GeneratedColumn<int>(
    'set_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [game, mode, metric, value, setAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'personal_bests';
  @override
  VerificationContext validateIntegrity(
    Insertable<PersonalBest> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('game')) {
      context.handle(
        _gameMeta,
        game.isAcceptableOrUnknown(data['game']!, _gameMeta),
      );
    } else if (isInserting) {
      context.missing(_gameMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('metric')) {
      context.handle(
        _metricMeta,
        metric.isAcceptableOrUnknown(data['metric']!, _metricMeta),
      );
    } else if (isInserting) {
      context.missing(_metricMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('set_at')) {
      context.handle(
        _setAtMeta,
        setAt.isAcceptableOrUnknown(data['set_at']!, _setAtMeta),
      );
    } else if (isInserting) {
      context.missing(_setAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {game, mode, metric};
  @override
  PersonalBest map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonalBest(
      game:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}game'],
          )!,
      mode:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}mode'],
          )!,
      metric:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}metric'],
          )!,
      value:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}value'],
          )!,
      setAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}set_at'],
          )!,
    );
  }

  @override
  $PersonalBestsTable createAlias(String alias) {
    return $PersonalBestsTable(attachedDatabase, alias);
  }
}

class PersonalBest extends DataClass implements Insertable<PersonalBest> {
  final String game;
  final String mode;
  final String metric;
  final double value;
  final int setAt;
  const PersonalBest({
    required this.game,
    required this.mode,
    required this.metric,
    required this.value,
    required this.setAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['game'] = Variable<String>(game);
    map['mode'] = Variable<String>(mode);
    map['metric'] = Variable<String>(metric);
    map['value'] = Variable<double>(value);
    map['set_at'] = Variable<int>(setAt);
    return map;
  }

  PersonalBestsCompanion toCompanion(bool nullToAbsent) {
    return PersonalBestsCompanion(
      game: Value(game),
      mode: Value(mode),
      metric: Value(metric),
      value: Value(value),
      setAt: Value(setAt),
    );
  }

  factory PersonalBest.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonalBest(
      game: serializer.fromJson<String>(json['game']),
      mode: serializer.fromJson<String>(json['mode']),
      metric: serializer.fromJson<String>(json['metric']),
      value: serializer.fromJson<double>(json['value']),
      setAt: serializer.fromJson<int>(json['setAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'game': serializer.toJson<String>(game),
      'mode': serializer.toJson<String>(mode),
      'metric': serializer.toJson<String>(metric),
      'value': serializer.toJson<double>(value),
      'setAt': serializer.toJson<int>(setAt),
    };
  }

  PersonalBest copyWith({
    String? game,
    String? mode,
    String? metric,
    double? value,
    int? setAt,
  }) => PersonalBest(
    game: game ?? this.game,
    mode: mode ?? this.mode,
    metric: metric ?? this.metric,
    value: value ?? this.value,
    setAt: setAt ?? this.setAt,
  );
  PersonalBest copyWithCompanion(PersonalBestsCompanion data) {
    return PersonalBest(
      game: data.game.present ? data.game.value : this.game,
      mode: data.mode.present ? data.mode.value : this.mode,
      metric: data.metric.present ? data.metric.value : this.metric,
      value: data.value.present ? data.value.value : this.value,
      setAt: data.setAt.present ? data.setAt.value : this.setAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonalBest(')
          ..write('game: $game, ')
          ..write('mode: $mode, ')
          ..write('metric: $metric, ')
          ..write('value: $value, ')
          ..write('setAt: $setAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(game, mode, metric, value, setAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonalBest &&
          other.game == this.game &&
          other.mode == this.mode &&
          other.metric == this.metric &&
          other.value == this.value &&
          other.setAt == this.setAt);
}

class PersonalBestsCompanion extends UpdateCompanion<PersonalBest> {
  final Value<String> game;
  final Value<String> mode;
  final Value<String> metric;
  final Value<double> value;
  final Value<int> setAt;
  final Value<int> rowid;
  const PersonalBestsCompanion({
    this.game = const Value.absent(),
    this.mode = const Value.absent(),
    this.metric = const Value.absent(),
    this.value = const Value.absent(),
    this.setAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PersonalBestsCompanion.insert({
    required String game,
    required String mode,
    required String metric,
    required double value,
    required int setAt,
    this.rowid = const Value.absent(),
  }) : game = Value(game),
       mode = Value(mode),
       metric = Value(metric),
       value = Value(value),
       setAt = Value(setAt);
  static Insertable<PersonalBest> custom({
    Expression<String>? game,
    Expression<String>? mode,
    Expression<String>? metric,
    Expression<double>? value,
    Expression<int>? setAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (game != null) 'game': game,
      if (mode != null) 'mode': mode,
      if (metric != null) 'metric': metric,
      if (value != null) 'value': value,
      if (setAt != null) 'set_at': setAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PersonalBestsCompanion copyWith({
    Value<String>? game,
    Value<String>? mode,
    Value<String>? metric,
    Value<double>? value,
    Value<int>? setAt,
    Value<int>? rowid,
  }) {
    return PersonalBestsCompanion(
      game: game ?? this.game,
      mode: mode ?? this.mode,
      metric: metric ?? this.metric,
      value: value ?? this.value,
      setAt: setAt ?? this.setAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (game.present) {
      map['game'] = Variable<String>(game.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (metric.present) {
      map['metric'] = Variable<String>(metric.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (setAt.present) {
      map['set_at'] = Variable<int>(setAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonalBestsCompanion(')
          ..write('game: $game, ')
          ..write('mode: $mode, ')
          ..write('metric: $metric, ')
          ..write('value: $value, ')
          ..write('setAt: $setAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WildItemsTable extends WildItems
    with TableInfo<$WildItemsTable, WildItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WildItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<int> wordId = GeneratedColumn<int>(
    'word_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES words (id)',
    ),
  );
  static const VerificationMeta _sentenceMeta = const VerificationMeta(
    'sentence',
  );
  @override
  late final GeneratedColumn<String> sentence = GeneratedColumn<String>(
    'sentence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _savedAtMeta = const VerificationMeta(
    'savedAt',
  );
  @override
  late final GeneratedColumn<int> savedAt = GeneratedColumn<int>(
    'saved_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, wordId, sentence, source, savedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wild_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<WildItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('word_id')) {
      context.handle(
        _wordIdMeta,
        wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta),
      );
    }
    if (data.containsKey('sentence')) {
      context.handle(
        _sentenceMeta,
        sentence.isAcceptableOrUnknown(data['sentence']!, _sentenceMeta),
      );
    } else if (isInserting) {
      context.missing(_sentenceMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('saved_at')) {
      context.handle(
        _savedAtMeta,
        savedAt.isAcceptableOrUnknown(data['saved_at']!, _savedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_savedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WildItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WildItem(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      wordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}word_id'],
      ),
      sentence:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}sentence'],
          )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      ),
      savedAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}saved_at'],
          )!,
    );
  }

  @override
  $WildItemsTable createAlias(String alias) {
    return $WildItemsTable(attachedDatabase, alias);
  }
}

class WildItem extends DataClass implements Insertable<WildItem> {
  final int id;
  final int? wordId;
  final String sentence;
  final String? source;
  final int savedAt;
  const WildItem({
    required this.id,
    this.wordId,
    required this.sentence,
    this.source,
    required this.savedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || wordId != null) {
      map['word_id'] = Variable<int>(wordId);
    }
    map['sentence'] = Variable<String>(sentence);
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    map['saved_at'] = Variable<int>(savedAt);
    return map;
  }

  WildItemsCompanion toCompanion(bool nullToAbsent) {
    return WildItemsCompanion(
      id: Value(id),
      wordId:
          wordId == null && nullToAbsent ? const Value.absent() : Value(wordId),
      sentence: Value(sentence),
      source:
          source == null && nullToAbsent ? const Value.absent() : Value(source),
      savedAt: Value(savedAt),
    );
  }

  factory WildItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WildItem(
      id: serializer.fromJson<int>(json['id']),
      wordId: serializer.fromJson<int?>(json['wordId']),
      sentence: serializer.fromJson<String>(json['sentence']),
      source: serializer.fromJson<String?>(json['source']),
      savedAt: serializer.fromJson<int>(json['savedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'wordId': serializer.toJson<int?>(wordId),
      'sentence': serializer.toJson<String>(sentence),
      'source': serializer.toJson<String?>(source),
      'savedAt': serializer.toJson<int>(savedAt),
    };
  }

  WildItem copyWith({
    int? id,
    Value<int?> wordId = const Value.absent(),
    String? sentence,
    Value<String?> source = const Value.absent(),
    int? savedAt,
  }) => WildItem(
    id: id ?? this.id,
    wordId: wordId.present ? wordId.value : this.wordId,
    sentence: sentence ?? this.sentence,
    source: source.present ? source.value : this.source,
    savedAt: savedAt ?? this.savedAt,
  );
  WildItem copyWithCompanion(WildItemsCompanion data) {
    return WildItem(
      id: data.id.present ? data.id.value : this.id,
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      sentence: data.sentence.present ? data.sentence.value : this.sentence,
      source: data.source.present ? data.source.value : this.source,
      savedAt: data.savedAt.present ? data.savedAt.value : this.savedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WildItem(')
          ..write('id: $id, ')
          ..write('wordId: $wordId, ')
          ..write('sentence: $sentence, ')
          ..write('source: $source, ')
          ..write('savedAt: $savedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, wordId, sentence, source, savedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WildItem &&
          other.id == this.id &&
          other.wordId == this.wordId &&
          other.sentence == this.sentence &&
          other.source == this.source &&
          other.savedAt == this.savedAt);
}

class WildItemsCompanion extends UpdateCompanion<WildItem> {
  final Value<int> id;
  final Value<int?> wordId;
  final Value<String> sentence;
  final Value<String?> source;
  final Value<int> savedAt;
  const WildItemsCompanion({
    this.id = const Value.absent(),
    this.wordId = const Value.absent(),
    this.sentence = const Value.absent(),
    this.source = const Value.absent(),
    this.savedAt = const Value.absent(),
  });
  WildItemsCompanion.insert({
    this.id = const Value.absent(),
    this.wordId = const Value.absent(),
    required String sentence,
    this.source = const Value.absent(),
    required int savedAt,
  }) : sentence = Value(sentence),
       savedAt = Value(savedAt);
  static Insertable<WildItem> custom({
    Expression<int>? id,
    Expression<int>? wordId,
    Expression<String>? sentence,
    Expression<String>? source,
    Expression<int>? savedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (wordId != null) 'word_id': wordId,
      if (sentence != null) 'sentence': sentence,
      if (source != null) 'source': source,
      if (savedAt != null) 'saved_at': savedAt,
    });
  }

  WildItemsCompanion copyWith({
    Value<int>? id,
    Value<int?>? wordId,
    Value<String>? sentence,
    Value<String?>? source,
    Value<int>? savedAt,
  }) {
    return WildItemsCompanion(
      id: id ?? this.id,
      wordId: wordId ?? this.wordId,
      sentence: sentence ?? this.sentence,
      source: source ?? this.source,
      savedAt: savedAt ?? this.savedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (wordId.present) {
      map['word_id'] = Variable<int>(wordId.value);
    }
    if (sentence.present) {
      map['sentence'] = Variable<String>(sentence.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (savedAt.present) {
      map['saved_at'] = Variable<int>(savedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WildItemsCompanion(')
          ..write('id: $id, ')
          ..write('wordId: $wordId, ')
          ..write('sentence: $sentence, ')
          ..write('source: $source, ')
          ..write('savedAt: $savedAt')
          ..write(')'))
        .toString();
  }
}

class $SkillLevelsTable extends SkillLevels
    with TableInfo<$SkillLevelsTable, SkillLevel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SkillLevelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _skillMeta = const VerificationMeta('skill');
  @override
  late final GeneratedColumn<String> skill = GeneratedColumn<String>(
    'skill',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cefrEstimateMeta = const VerificationMeta(
    'cefrEstimate',
  );
  @override
  late final GeneratedColumn<String> cefrEstimate = GeneratedColumn<String>(
    'cefr_estimate',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<double> score = GeneratedColumn<double>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _measuredAtMeta = const VerificationMeta(
    'measuredAt',
  );
  @override
  late final GeneratedColumn<int> measuredAt = GeneratedColumn<int>(
    'measured_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    skill,
    cefrEstimate,
    score,
    measuredAt,
    source,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'skill_levels';
  @override
  VerificationContext validateIntegrity(
    Insertable<SkillLevel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('skill')) {
      context.handle(
        _skillMeta,
        skill.isAcceptableOrUnknown(data['skill']!, _skillMeta),
      );
    } else if (isInserting) {
      context.missing(_skillMeta);
    }
    if (data.containsKey('cefr_estimate')) {
      context.handle(
        _cefrEstimateMeta,
        cefrEstimate.isAcceptableOrUnknown(
          data['cefr_estimate']!,
          _cefrEstimateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cefrEstimateMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('measured_at')) {
      context.handle(
        _measuredAtMeta,
        measuredAt.isAcceptableOrUnknown(data['measured_at']!, _measuredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_measuredAtMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SkillLevel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SkillLevel(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      skill:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}skill'],
          )!,
      cefrEstimate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}cefr_estimate'],
          )!,
      score:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}score'],
          )!,
      measuredAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}measured_at'],
          )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      ),
    );
  }

  @override
  $SkillLevelsTable createAlias(String alias) {
    return $SkillLevelsTable(attachedDatabase, alias);
  }
}

class SkillLevel extends DataClass implements Insertable<SkillLevel> {
  final int id;
  final String skill;
  final String cefrEstimate;
  final double score;
  final int measuredAt;
  final String? source;
  const SkillLevel({
    required this.id,
    required this.skill,
    required this.cefrEstimate,
    required this.score,
    required this.measuredAt,
    this.source,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['skill'] = Variable<String>(skill);
    map['cefr_estimate'] = Variable<String>(cefrEstimate);
    map['score'] = Variable<double>(score);
    map['measured_at'] = Variable<int>(measuredAt);
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    return map;
  }

  SkillLevelsCompanion toCompanion(bool nullToAbsent) {
    return SkillLevelsCompanion(
      id: Value(id),
      skill: Value(skill),
      cefrEstimate: Value(cefrEstimate),
      score: Value(score),
      measuredAt: Value(measuredAt),
      source:
          source == null && nullToAbsent ? const Value.absent() : Value(source),
    );
  }

  factory SkillLevel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SkillLevel(
      id: serializer.fromJson<int>(json['id']),
      skill: serializer.fromJson<String>(json['skill']),
      cefrEstimate: serializer.fromJson<String>(json['cefrEstimate']),
      score: serializer.fromJson<double>(json['score']),
      measuredAt: serializer.fromJson<int>(json['measuredAt']),
      source: serializer.fromJson<String?>(json['source']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'skill': serializer.toJson<String>(skill),
      'cefrEstimate': serializer.toJson<String>(cefrEstimate),
      'score': serializer.toJson<double>(score),
      'measuredAt': serializer.toJson<int>(measuredAt),
      'source': serializer.toJson<String?>(source),
    };
  }

  SkillLevel copyWith({
    int? id,
    String? skill,
    String? cefrEstimate,
    double? score,
    int? measuredAt,
    Value<String?> source = const Value.absent(),
  }) => SkillLevel(
    id: id ?? this.id,
    skill: skill ?? this.skill,
    cefrEstimate: cefrEstimate ?? this.cefrEstimate,
    score: score ?? this.score,
    measuredAt: measuredAt ?? this.measuredAt,
    source: source.present ? source.value : this.source,
  );
  SkillLevel copyWithCompanion(SkillLevelsCompanion data) {
    return SkillLevel(
      id: data.id.present ? data.id.value : this.id,
      skill: data.skill.present ? data.skill.value : this.skill,
      cefrEstimate:
          data.cefrEstimate.present
              ? data.cefrEstimate.value
              : this.cefrEstimate,
      score: data.score.present ? data.score.value : this.score,
      measuredAt:
          data.measuredAt.present ? data.measuredAt.value : this.measuredAt,
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SkillLevel(')
          ..write('id: $id, ')
          ..write('skill: $skill, ')
          ..write('cefrEstimate: $cefrEstimate, ')
          ..write('score: $score, ')
          ..write('measuredAt: $measuredAt, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, skill, cefrEstimate, score, measuredAt, source);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SkillLevel &&
          other.id == this.id &&
          other.skill == this.skill &&
          other.cefrEstimate == this.cefrEstimate &&
          other.score == this.score &&
          other.measuredAt == this.measuredAt &&
          other.source == this.source);
}

class SkillLevelsCompanion extends UpdateCompanion<SkillLevel> {
  final Value<int> id;
  final Value<String> skill;
  final Value<String> cefrEstimate;
  final Value<double> score;
  final Value<int> measuredAt;
  final Value<String?> source;
  const SkillLevelsCompanion({
    this.id = const Value.absent(),
    this.skill = const Value.absent(),
    this.cefrEstimate = const Value.absent(),
    this.score = const Value.absent(),
    this.measuredAt = const Value.absent(),
    this.source = const Value.absent(),
  });
  SkillLevelsCompanion.insert({
    this.id = const Value.absent(),
    required String skill,
    required String cefrEstimate,
    required double score,
    required int measuredAt,
    this.source = const Value.absent(),
  }) : skill = Value(skill),
       cefrEstimate = Value(cefrEstimate),
       score = Value(score),
       measuredAt = Value(measuredAt);
  static Insertable<SkillLevel> custom({
    Expression<int>? id,
    Expression<String>? skill,
    Expression<String>? cefrEstimate,
    Expression<double>? score,
    Expression<int>? measuredAt,
    Expression<String>? source,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (skill != null) 'skill': skill,
      if (cefrEstimate != null) 'cefr_estimate': cefrEstimate,
      if (score != null) 'score': score,
      if (measuredAt != null) 'measured_at': measuredAt,
      if (source != null) 'source': source,
    });
  }

  SkillLevelsCompanion copyWith({
    Value<int>? id,
    Value<String>? skill,
    Value<String>? cefrEstimate,
    Value<double>? score,
    Value<int>? measuredAt,
    Value<String?>? source,
  }) {
    return SkillLevelsCompanion(
      id: id ?? this.id,
      skill: skill ?? this.skill,
      cefrEstimate: cefrEstimate ?? this.cefrEstimate,
      score: score ?? this.score,
      measuredAt: measuredAt ?? this.measuredAt,
      source: source ?? this.source,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (skill.present) {
      map['skill'] = Variable<String>(skill.value);
    }
    if (cefrEstimate.present) {
      map['cefr_estimate'] = Variable<String>(cefrEstimate.value);
    }
    if (score.present) {
      map['score'] = Variable<double>(score.value);
    }
    if (measuredAt.present) {
      map['measured_at'] = Variable<int>(measuredAt.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SkillLevelsCompanion(')
          ..write('id: $id, ')
          ..write('skill: $skill, ')
          ..write('cefrEstimate: $cefrEstimate, ')
          ..write('score: $score, ')
          ..write('measuredAt: $measuredAt, ')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WordsTable words = $WordsTable(this);
  late final $ExamplesTable examples = $ExamplesTable(this);
  late final $WordFamiliesTable wordFamilies = $WordFamiliesTable(this);
  late final $CollocationsTable collocations = $CollocationsTable(this);
  late final $SrsCardsTable srsCards = $SrsCardsTable(this);
  late final $ReviewLogsTable reviewLogs = $ReviewLogsTable(this);
  late final $SentenceStructuresTable sentenceStructures =
      $SentenceStructuresTable(this);
  late final $ParagraphsTable paragraphs = $ParagraphsTable(this);
  late final $ChunkSentencesTable chunkSentences = $ChunkSentencesTable(this);
  late final $PassagesTable passages = $PassagesTable(this);
  late final $QuestionsTable questions = $QuestionsTable(this);
  late final $UserTextsTable userTexts = $UserTextsTable(this);
  late final $RecordingsTable recordings = $RecordingsTable(this);
  late final $DailyStatsTable dailyStats = $DailyStatsTable(this);
  late final $StreaksTable streaks = $StreaksTable(this);
  late final $AchievementsTable achievements = $AchievementsTable(this);
  late final $GameSessionsTable gameSessions = $GameSessionsTable(this);
  late final $PersonalBestsTable personalBests = $PersonalBestsTable(this);
  late final $WildItemsTable wildItems = $WildItemsTable(this);
  late final $SkillLevelsTable skillLevels = $SkillLevelsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    words,
    examples,
    wordFamilies,
    collocations,
    srsCards,
    reviewLogs,
    sentenceStructures,
    paragraphs,
    chunkSentences,
    passages,
    questions,
    userTexts,
    recordings,
    dailyStats,
    streaks,
    achievements,
    gameSessions,
    personalBests,
    wildItems,
    skillLevels,
  ];
}

typedef $$WordsTableCreateCompanionBuilder =
    WordsCompanion Function({
      Value<int> id,
      required String lemma,
      Value<String?> pos,
      Value<String?> ipa,
      Value<String?> cefr,
      Value<int?> freqRank,
      Value<String?> definitionEn,
      Value<String?> definitionNative,
      Value<String?> audioPath,
      Value<String?> tags,
      Value<String?> register,
      Value<String?> nuanceNote,
      Value<String?> source,
      Value<String?> userMnemonic,
      Value<String?> userSentence,
    });
typedef $$WordsTableUpdateCompanionBuilder =
    WordsCompanion Function({
      Value<int> id,
      Value<String> lemma,
      Value<String?> pos,
      Value<String?> ipa,
      Value<String?> cefr,
      Value<int?> freqRank,
      Value<String?> definitionEn,
      Value<String?> definitionNative,
      Value<String?> audioPath,
      Value<String?> tags,
      Value<String?> register,
      Value<String?> nuanceNote,
      Value<String?> source,
      Value<String?> userMnemonic,
      Value<String?> userSentence,
    });

final class $$WordsTableReferences
    extends BaseReferences<_$AppDatabase, $WordsTable, Word> {
  $$WordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ExamplesTable, List<Example>> _examplesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.examples,
    aliasName: $_aliasNameGenerator(db.words.id, db.examples.wordId),
  );

  $$ExamplesTableProcessedTableManager get examplesRefs {
    final manager = $$ExamplesTableTableManager(
      $_db,
      $_db.examples,
    ).filter((f) => f.wordId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_examplesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WordFamiliesTable, List<WordFamily>>
  _wordFamiliesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.wordFamilies,
    aliasName: $_aliasNameGenerator(db.words.id, db.wordFamilies.memberWordId),
  );

  $$WordFamiliesTableProcessedTableManager get wordFamiliesRefs {
    final manager = $$WordFamiliesTableTableManager(
      $_db,
      $_db.wordFamilies,
    ).filter((f) => f.memberWordId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_wordFamiliesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CollocationsTable, List<Collocation>>
  _collocationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.collocations,
    aliasName: $_aliasNameGenerator(db.words.id, db.collocations.wordId),
  );

  $$CollocationsTableProcessedTableManager get collocationsRefs {
    final manager = $$CollocationsTableTableManager(
      $_db,
      $_db.collocations,
    ).filter((f) => f.wordId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_collocationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WildItemsTable, List<WildItem>>
  _wildItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.wildItems,
    aliasName: $_aliasNameGenerator(db.words.id, db.wildItems.wordId),
  );

  $$WildItemsTableProcessedTableManager get wildItemsRefs {
    final manager = $$WildItemsTableTableManager(
      $_db,
      $_db.wildItems,
    ).filter((f) => f.wordId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_wildItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WordsTableFilterComposer extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableFilterComposer({
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

  ColumnFilters<String> get lemma => $composableBuilder(
    column: $table.lemma,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pos => $composableBuilder(
    column: $table.pos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ipa => $composableBuilder(
    column: $table.ipa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cefr => $composableBuilder(
    column: $table.cefr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get freqRank => $composableBuilder(
    column: $table.freqRank,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get definitionEn => $composableBuilder(
    column: $table.definitionEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get definitionNative => $composableBuilder(
    column: $table.definitionNative,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get register => $composableBuilder(
    column: $table.register,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nuanceNote => $composableBuilder(
    column: $table.nuanceNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userMnemonic => $composableBuilder(
    column: $table.userMnemonic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userSentence => $composableBuilder(
    column: $table.userSentence,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> examplesRefs(
    Expression<bool> Function($$ExamplesTableFilterComposer f) f,
  ) {
    final $$ExamplesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.examples,
      getReferencedColumn: (t) => t.wordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamplesTableFilterComposer(
            $db: $db,
            $table: $db.examples,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> wordFamiliesRefs(
    Expression<bool> Function($$WordFamiliesTableFilterComposer f) f,
  ) {
    final $$WordFamiliesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.wordFamilies,
      getReferencedColumn: (t) => t.memberWordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordFamiliesTableFilterComposer(
            $db: $db,
            $table: $db.wordFamilies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> collocationsRefs(
    Expression<bool> Function($$CollocationsTableFilterComposer f) f,
  ) {
    final $$CollocationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.collocations,
      getReferencedColumn: (t) => t.wordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollocationsTableFilterComposer(
            $db: $db,
            $table: $db.collocations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> wildItemsRefs(
    Expression<bool> Function($$WildItemsTableFilterComposer f) f,
  ) {
    final $$WildItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.wildItems,
      getReferencedColumn: (t) => t.wordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WildItemsTableFilterComposer(
            $db: $db,
            $table: $db.wildItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WordsTableOrderingComposer
    extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableOrderingComposer({
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

  ColumnOrderings<String> get lemma => $composableBuilder(
    column: $table.lemma,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pos => $composableBuilder(
    column: $table.pos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ipa => $composableBuilder(
    column: $table.ipa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cefr => $composableBuilder(
    column: $table.cefr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get freqRank => $composableBuilder(
    column: $table.freqRank,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get definitionEn => $composableBuilder(
    column: $table.definitionEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get definitionNative => $composableBuilder(
    column: $table.definitionNative,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get register => $composableBuilder(
    column: $table.register,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nuanceNote => $composableBuilder(
    column: $table.nuanceNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userMnemonic => $composableBuilder(
    column: $table.userMnemonic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userSentence => $composableBuilder(
    column: $table.userSentence,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lemma =>
      $composableBuilder(column: $table.lemma, builder: (column) => column);

  GeneratedColumn<String> get pos =>
      $composableBuilder(column: $table.pos, builder: (column) => column);

  GeneratedColumn<String> get ipa =>
      $composableBuilder(column: $table.ipa, builder: (column) => column);

  GeneratedColumn<String> get cefr =>
      $composableBuilder(column: $table.cefr, builder: (column) => column);

  GeneratedColumn<int> get freqRank =>
      $composableBuilder(column: $table.freqRank, builder: (column) => column);

  GeneratedColumn<String> get definitionEn => $composableBuilder(
    column: $table.definitionEn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get definitionNative => $composableBuilder(
    column: $table.definitionNative,
    builder: (column) => column,
  );

  GeneratedColumn<String> get audioPath =>
      $composableBuilder(column: $table.audioPath, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get register =>
      $composableBuilder(column: $table.register, builder: (column) => column);

  GeneratedColumn<String> get nuanceNote => $composableBuilder(
    column: $table.nuanceNote,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get userMnemonic => $composableBuilder(
    column: $table.userMnemonic,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userSentence => $composableBuilder(
    column: $table.userSentence,
    builder: (column) => column,
  );

  Expression<T> examplesRefs<T extends Object>(
    Expression<T> Function($$ExamplesTableAnnotationComposer a) f,
  ) {
    final $$ExamplesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.examples,
      getReferencedColumn: (t) => t.wordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExamplesTableAnnotationComposer(
            $db: $db,
            $table: $db.examples,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> wordFamiliesRefs<T extends Object>(
    Expression<T> Function($$WordFamiliesTableAnnotationComposer a) f,
  ) {
    final $$WordFamiliesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.wordFamilies,
      getReferencedColumn: (t) => t.memberWordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordFamiliesTableAnnotationComposer(
            $db: $db,
            $table: $db.wordFamilies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> collocationsRefs<T extends Object>(
    Expression<T> Function($$CollocationsTableAnnotationComposer a) f,
  ) {
    final $$CollocationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.collocations,
      getReferencedColumn: (t) => t.wordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollocationsTableAnnotationComposer(
            $db: $db,
            $table: $db.collocations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> wildItemsRefs<T extends Object>(
    Expression<T> Function($$WildItemsTableAnnotationComposer a) f,
  ) {
    final $$WildItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.wildItems,
      getReferencedColumn: (t) => t.wordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WildItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.wildItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WordsTable,
          Word,
          $$WordsTableFilterComposer,
          $$WordsTableOrderingComposer,
          $$WordsTableAnnotationComposer,
          $$WordsTableCreateCompanionBuilder,
          $$WordsTableUpdateCompanionBuilder,
          (Word, $$WordsTableReferences),
          Word,
          PrefetchHooks Function({
            bool examplesRefs,
            bool wordFamiliesRefs,
            bool collocationsRefs,
            bool wildItemsRefs,
          })
        > {
  $$WordsTableTableManager(_$AppDatabase db, $WordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$WordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$WordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$WordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> lemma = const Value.absent(),
                Value<String?> pos = const Value.absent(),
                Value<String?> ipa = const Value.absent(),
                Value<String?> cefr = const Value.absent(),
                Value<int?> freqRank = const Value.absent(),
                Value<String?> definitionEn = const Value.absent(),
                Value<String?> definitionNative = const Value.absent(),
                Value<String?> audioPath = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<String?> register = const Value.absent(),
                Value<String?> nuanceNote = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<String?> userMnemonic = const Value.absent(),
                Value<String?> userSentence = const Value.absent(),
              }) => WordsCompanion(
                id: id,
                lemma: lemma,
                pos: pos,
                ipa: ipa,
                cefr: cefr,
                freqRank: freqRank,
                definitionEn: definitionEn,
                definitionNative: definitionNative,
                audioPath: audioPath,
                tags: tags,
                register: register,
                nuanceNote: nuanceNote,
                source: source,
                userMnemonic: userMnemonic,
                userSentence: userSentence,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String lemma,
                Value<String?> pos = const Value.absent(),
                Value<String?> ipa = const Value.absent(),
                Value<String?> cefr = const Value.absent(),
                Value<int?> freqRank = const Value.absent(),
                Value<String?> definitionEn = const Value.absent(),
                Value<String?> definitionNative = const Value.absent(),
                Value<String?> audioPath = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<String?> register = const Value.absent(),
                Value<String?> nuanceNote = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<String?> userMnemonic = const Value.absent(),
                Value<String?> userSentence = const Value.absent(),
              }) => WordsCompanion.insert(
                id: id,
                lemma: lemma,
                pos: pos,
                ipa: ipa,
                cefr: cefr,
                freqRank: freqRank,
                definitionEn: definitionEn,
                definitionNative: definitionNative,
                audioPath: audioPath,
                tags: tags,
                register: register,
                nuanceNote: nuanceNote,
                source: source,
                userMnemonic: userMnemonic,
                userSentence: userSentence,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$WordsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            examplesRefs = false,
            wordFamiliesRefs = false,
            collocationsRefs = false,
            wildItemsRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (examplesRefs) db.examples,
                if (wordFamiliesRefs) db.wordFamilies,
                if (collocationsRefs) db.collocations,
                if (wildItemsRefs) db.wildItems,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (examplesRefs)
                    await $_getPrefetchedData<Word, $WordsTable, Example>(
                      currentTable: table,
                      referencedTable: $$WordsTableReferences
                          ._examplesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$WordsTableReferences(
                                db,
                                table,
                                p0,
                              ).examplesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.wordId == item.id),
                      typedResults: items,
                    ),
                  if (wordFamiliesRefs)
                    await $_getPrefetchedData<Word, $WordsTable, WordFamily>(
                      currentTable: table,
                      referencedTable: $$WordsTableReferences
                          ._wordFamiliesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$WordsTableReferences(
                                db,
                                table,
                                p0,
                              ).wordFamiliesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.memberWordId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (collocationsRefs)
                    await $_getPrefetchedData<Word, $WordsTable, Collocation>(
                      currentTable: table,
                      referencedTable: $$WordsTableReferences
                          ._collocationsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$WordsTableReferences(
                                db,
                                table,
                                p0,
                              ).collocationsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.wordId == item.id),
                      typedResults: items,
                    ),
                  if (wildItemsRefs)
                    await $_getPrefetchedData<Word, $WordsTable, WildItem>(
                      currentTable: table,
                      referencedTable: $$WordsTableReferences
                          ._wildItemsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$WordsTableReferences(
                                db,
                                table,
                                p0,
                              ).wildItemsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.wordId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$WordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WordsTable,
      Word,
      $$WordsTableFilterComposer,
      $$WordsTableOrderingComposer,
      $$WordsTableAnnotationComposer,
      $$WordsTableCreateCompanionBuilder,
      $$WordsTableUpdateCompanionBuilder,
      (Word, $$WordsTableReferences),
      Word,
      PrefetchHooks Function({
        bool examplesRefs,
        bool wordFamiliesRefs,
        bool collocationsRefs,
        bool wildItemsRefs,
      })
    >;
typedef $$ExamplesTableCreateCompanionBuilder =
    ExamplesCompanion Function({
      Value<int> id,
      required int wordId,
      required String sentence,
      Value<String?> translation,
      Value<String?> audioPath,
    });
typedef $$ExamplesTableUpdateCompanionBuilder =
    ExamplesCompanion Function({
      Value<int> id,
      Value<int> wordId,
      Value<String> sentence,
      Value<String?> translation,
      Value<String?> audioPath,
    });

final class $$ExamplesTableReferences
    extends BaseReferences<_$AppDatabase, $ExamplesTable, Example> {
  $$ExamplesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WordsTable _wordIdTable(_$AppDatabase db) => db.words.createAlias(
    $_aliasNameGenerator(db.examples.wordId, db.words.id),
  );

  $$WordsTableProcessedTableManager get wordId {
    final $_column = $_itemColumn<int>('word_id')!;

    final manager = $$WordsTableTableManager(
      $_db,
      $_db.words,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_wordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExamplesTableFilterComposer
    extends Composer<_$AppDatabase, $ExamplesTable> {
  $$ExamplesTableFilterComposer({
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

  ColumnFilters<String> get sentence => $composableBuilder(
    column: $table.sentence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnFilters(column),
  );

  $$WordsTableFilterComposer get wordId {
    final $$WordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableFilterComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExamplesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExamplesTable> {
  $$ExamplesTableOrderingComposer({
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

  ColumnOrderings<String> get sentence => $composableBuilder(
    column: $table.sentence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnOrderings(column),
  );

  $$WordsTableOrderingComposer get wordId {
    final $$WordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableOrderingComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExamplesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExamplesTable> {
  $$ExamplesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sentence =>
      $composableBuilder(column: $table.sentence, builder: (column) => column);

  GeneratedColumn<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get audioPath =>
      $composableBuilder(column: $table.audioPath, builder: (column) => column);

  $$WordsTableAnnotationComposer get wordId {
    final $$WordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableAnnotationComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExamplesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExamplesTable,
          Example,
          $$ExamplesTableFilterComposer,
          $$ExamplesTableOrderingComposer,
          $$ExamplesTableAnnotationComposer,
          $$ExamplesTableCreateCompanionBuilder,
          $$ExamplesTableUpdateCompanionBuilder,
          (Example, $$ExamplesTableReferences),
          Example,
          PrefetchHooks Function({bool wordId})
        > {
  $$ExamplesTableTableManager(_$AppDatabase db, $ExamplesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ExamplesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$ExamplesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$ExamplesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> wordId = const Value.absent(),
                Value<String> sentence = const Value.absent(),
                Value<String?> translation = const Value.absent(),
                Value<String?> audioPath = const Value.absent(),
              }) => ExamplesCompanion(
                id: id,
                wordId: wordId,
                sentence: sentence,
                translation: translation,
                audioPath: audioPath,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int wordId,
                required String sentence,
                Value<String?> translation = const Value.absent(),
                Value<String?> audioPath = const Value.absent(),
              }) => ExamplesCompanion.insert(
                id: id,
                wordId: wordId,
                sentence: sentence,
                translation: translation,
                audioPath: audioPath,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$ExamplesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({wordId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                if (wordId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.wordId,
                            referencedTable: $$ExamplesTableReferences
                                ._wordIdTable(db),
                            referencedColumn:
                                $$ExamplesTableReferences._wordIdTable(db).id,
                          )
                          as T;
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

typedef $$ExamplesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExamplesTable,
      Example,
      $$ExamplesTableFilterComposer,
      $$ExamplesTableOrderingComposer,
      $$ExamplesTableAnnotationComposer,
      $$ExamplesTableCreateCompanionBuilder,
      $$ExamplesTableUpdateCompanionBuilder,
      (Example, $$ExamplesTableReferences),
      Example,
      PrefetchHooks Function({bool wordId})
    >;
typedef $$WordFamiliesTableCreateCompanionBuilder =
    WordFamiliesCompanion Function({
      Value<int> id,
      required String root,
      Value<int?> memberWordId,
      Value<String?> formType,
    });
typedef $$WordFamiliesTableUpdateCompanionBuilder =
    WordFamiliesCompanion Function({
      Value<int> id,
      Value<String> root,
      Value<int?> memberWordId,
      Value<String?> formType,
    });

final class $$WordFamiliesTableReferences
    extends BaseReferences<_$AppDatabase, $WordFamiliesTable, WordFamily> {
  $$WordFamiliesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WordsTable _memberWordIdTable(_$AppDatabase db) =>
      db.words.createAlias(
        $_aliasNameGenerator(db.wordFamilies.memberWordId, db.words.id),
      );

  $$WordsTableProcessedTableManager? get memberWordId {
    final $_column = $_itemColumn<int>('member_word_id');
    if ($_column == null) return null;
    final manager = $$WordsTableTableManager(
      $_db,
      $_db.words,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memberWordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WordFamiliesTableFilterComposer
    extends Composer<_$AppDatabase, $WordFamiliesTable> {
  $$WordFamiliesTableFilterComposer({
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

  ColumnFilters<String> get root => $composableBuilder(
    column: $table.root,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get formType => $composableBuilder(
    column: $table.formType,
    builder: (column) => ColumnFilters(column),
  );

  $$WordsTableFilterComposer get memberWordId {
    final $$WordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberWordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableFilterComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WordFamiliesTableOrderingComposer
    extends Composer<_$AppDatabase, $WordFamiliesTable> {
  $$WordFamiliesTableOrderingComposer({
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

  ColumnOrderings<String> get root => $composableBuilder(
    column: $table.root,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get formType => $composableBuilder(
    column: $table.formType,
    builder: (column) => ColumnOrderings(column),
  );

  $$WordsTableOrderingComposer get memberWordId {
    final $$WordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberWordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableOrderingComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WordFamiliesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WordFamiliesTable> {
  $$WordFamiliesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get root =>
      $composableBuilder(column: $table.root, builder: (column) => column);

  GeneratedColumn<String> get formType =>
      $composableBuilder(column: $table.formType, builder: (column) => column);

  $$WordsTableAnnotationComposer get memberWordId {
    final $$WordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberWordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableAnnotationComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WordFamiliesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WordFamiliesTable,
          WordFamily,
          $$WordFamiliesTableFilterComposer,
          $$WordFamiliesTableOrderingComposer,
          $$WordFamiliesTableAnnotationComposer,
          $$WordFamiliesTableCreateCompanionBuilder,
          $$WordFamiliesTableUpdateCompanionBuilder,
          (WordFamily, $$WordFamiliesTableReferences),
          WordFamily,
          PrefetchHooks Function({bool memberWordId})
        > {
  $$WordFamiliesTableTableManager(_$AppDatabase db, $WordFamiliesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$WordFamiliesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$WordFamiliesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$WordFamiliesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> root = const Value.absent(),
                Value<int?> memberWordId = const Value.absent(),
                Value<String?> formType = const Value.absent(),
              }) => WordFamiliesCompanion(
                id: id,
                root: root,
                memberWordId: memberWordId,
                formType: formType,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String root,
                Value<int?> memberWordId = const Value.absent(),
                Value<String?> formType = const Value.absent(),
              }) => WordFamiliesCompanion.insert(
                id: id,
                root: root,
                memberWordId: memberWordId,
                formType: formType,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$WordFamiliesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({memberWordId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                if (memberWordId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.memberWordId,
                            referencedTable: $$WordFamiliesTableReferences
                                ._memberWordIdTable(db),
                            referencedColumn:
                                $$WordFamiliesTableReferences
                                    ._memberWordIdTable(db)
                                    .id,
                          )
                          as T;
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

typedef $$WordFamiliesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WordFamiliesTable,
      WordFamily,
      $$WordFamiliesTableFilterComposer,
      $$WordFamiliesTableOrderingComposer,
      $$WordFamiliesTableAnnotationComposer,
      $$WordFamiliesTableCreateCompanionBuilder,
      $$WordFamiliesTableUpdateCompanionBuilder,
      (WordFamily, $$WordFamiliesTableReferences),
      WordFamily,
      PrefetchHooks Function({bool memberWordId})
    >;
typedef $$CollocationsTableCreateCompanionBuilder =
    CollocationsCompanion Function({
      Value<int> id,
      required int wordId,
      required String phrase,
      Value<String?> register,
    });
typedef $$CollocationsTableUpdateCompanionBuilder =
    CollocationsCompanion Function({
      Value<int> id,
      Value<int> wordId,
      Value<String> phrase,
      Value<String?> register,
    });

final class $$CollocationsTableReferences
    extends BaseReferences<_$AppDatabase, $CollocationsTable, Collocation> {
  $$CollocationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WordsTable _wordIdTable(_$AppDatabase db) => db.words.createAlias(
    $_aliasNameGenerator(db.collocations.wordId, db.words.id),
  );

  $$WordsTableProcessedTableManager get wordId {
    final $_column = $_itemColumn<int>('word_id')!;

    final manager = $$WordsTableTableManager(
      $_db,
      $_db.words,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_wordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CollocationsTableFilterComposer
    extends Composer<_$AppDatabase, $CollocationsTable> {
  $$CollocationsTableFilterComposer({
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

  ColumnFilters<String> get phrase => $composableBuilder(
    column: $table.phrase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get register => $composableBuilder(
    column: $table.register,
    builder: (column) => ColumnFilters(column),
  );

  $$WordsTableFilterComposer get wordId {
    final $$WordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableFilterComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CollocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $CollocationsTable> {
  $$CollocationsTableOrderingComposer({
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

  ColumnOrderings<String> get phrase => $composableBuilder(
    column: $table.phrase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get register => $composableBuilder(
    column: $table.register,
    builder: (column) => ColumnOrderings(column),
  );

  $$WordsTableOrderingComposer get wordId {
    final $$WordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableOrderingComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CollocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CollocationsTable> {
  $$CollocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get phrase =>
      $composableBuilder(column: $table.phrase, builder: (column) => column);

  GeneratedColumn<String> get register =>
      $composableBuilder(column: $table.register, builder: (column) => column);

  $$WordsTableAnnotationComposer get wordId {
    final $$WordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableAnnotationComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CollocationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CollocationsTable,
          Collocation,
          $$CollocationsTableFilterComposer,
          $$CollocationsTableOrderingComposer,
          $$CollocationsTableAnnotationComposer,
          $$CollocationsTableCreateCompanionBuilder,
          $$CollocationsTableUpdateCompanionBuilder,
          (Collocation, $$CollocationsTableReferences),
          Collocation,
          PrefetchHooks Function({bool wordId})
        > {
  $$CollocationsTableTableManager(_$AppDatabase db, $CollocationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$CollocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$CollocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$CollocationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> wordId = const Value.absent(),
                Value<String> phrase = const Value.absent(),
                Value<String?> register = const Value.absent(),
              }) => CollocationsCompanion(
                id: id,
                wordId: wordId,
                phrase: phrase,
                register: register,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int wordId,
                required String phrase,
                Value<String?> register = const Value.absent(),
              }) => CollocationsCompanion.insert(
                id: id,
                wordId: wordId,
                phrase: phrase,
                register: register,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$CollocationsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({wordId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                if (wordId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.wordId,
                            referencedTable: $$CollocationsTableReferences
                                ._wordIdTable(db),
                            referencedColumn:
                                $$CollocationsTableReferences
                                    ._wordIdTable(db)
                                    .id,
                          )
                          as T;
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

typedef $$CollocationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CollocationsTable,
      Collocation,
      $$CollocationsTableFilterComposer,
      $$CollocationsTableOrderingComposer,
      $$CollocationsTableAnnotationComposer,
      $$CollocationsTableCreateCompanionBuilder,
      $$CollocationsTableUpdateCompanionBuilder,
      (Collocation, $$CollocationsTableReferences),
      Collocation,
      PrefetchHooks Function({bool wordId})
    >;
typedef $$SrsCardsTableCreateCompanionBuilder =
    SrsCardsCompanion Function({
      Value<int> id,
      required String itemType,
      required int itemId,
      required String skill,
      Value<double> ease,
      Value<int> intervalDays,
      Value<int> repetitions,
      Value<int> lapses,
      required int dueAt,
      Value<int?> lastReviewedAt,
    });
typedef $$SrsCardsTableUpdateCompanionBuilder =
    SrsCardsCompanion Function({
      Value<int> id,
      Value<String> itemType,
      Value<int> itemId,
      Value<String> skill,
      Value<double> ease,
      Value<int> intervalDays,
      Value<int> repetitions,
      Value<int> lapses,
      Value<int> dueAt,
      Value<int?> lastReviewedAt,
    });

final class $$SrsCardsTableReferences
    extends BaseReferences<_$AppDatabase, $SrsCardsTable, SrsCard> {
  $$SrsCardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ReviewLogsTable, List<ReviewLog>>
  _reviewLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reviewLogs,
    aliasName: $_aliasNameGenerator(db.srsCards.id, db.reviewLogs.cardId),
  );

  $$ReviewLogsTableProcessedTableManager get reviewLogsRefs {
    final manager = $$ReviewLogsTableTableManager(
      $_db,
      $_db.reviewLogs,
    ).filter((f) => f.cardId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_reviewLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SrsCardsTableFilterComposer
    extends Composer<_$AppDatabase, $SrsCardsTable> {
  $$SrsCardsTableFilterComposer({
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

  ColumnFilters<String> get itemType => $composableBuilder(
    column: $table.itemType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get skill => $composableBuilder(
    column: $table.skill,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ease => $composableBuilder(
    column: $table.ease,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lapses => $composableBuilder(
    column: $table.lapses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> reviewLogsRefs(
    Expression<bool> Function($$ReviewLogsTableFilterComposer f) f,
  ) {
    final $$ReviewLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reviewLogs,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewLogsTableFilterComposer(
            $db: $db,
            $table: $db.reviewLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SrsCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $SrsCardsTable> {
  $$SrsCardsTableOrderingComposer({
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

  ColumnOrderings<String> get itemType => $composableBuilder(
    column: $table.itemType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get skill => $composableBuilder(
    column: $table.skill,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ease => $composableBuilder(
    column: $table.ease,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lapses => $composableBuilder(
    column: $table.lapses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SrsCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SrsCardsTable> {
  $$SrsCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get itemType =>
      $composableBuilder(column: $table.itemType, builder: (column) => column);

  GeneratedColumn<int> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get skill =>
      $composableBuilder(column: $table.skill, builder: (column) => column);

  GeneratedColumn<double> get ease =>
      $composableBuilder(column: $table.ease, builder: (column) => column);

  GeneratedColumn<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get repetitions => $composableBuilder(
    column: $table.repetitions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lapses =>
      $composableBuilder(column: $table.lapses, builder: (column) => column);

  GeneratedColumn<int> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<int> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => column,
  );

  Expression<T> reviewLogsRefs<T extends Object>(
    Expression<T> Function($$ReviewLogsTableAnnotationComposer a) f,
  ) {
    final $$ReviewLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reviewLogs,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.reviewLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SrsCardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SrsCardsTable,
          SrsCard,
          $$SrsCardsTableFilterComposer,
          $$SrsCardsTableOrderingComposer,
          $$SrsCardsTableAnnotationComposer,
          $$SrsCardsTableCreateCompanionBuilder,
          $$SrsCardsTableUpdateCompanionBuilder,
          (SrsCard, $$SrsCardsTableReferences),
          SrsCard,
          PrefetchHooks Function({bool reviewLogsRefs})
        > {
  $$SrsCardsTableTableManager(_$AppDatabase db, $SrsCardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$SrsCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$SrsCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$SrsCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> itemType = const Value.absent(),
                Value<int> itemId = const Value.absent(),
                Value<String> skill = const Value.absent(),
                Value<double> ease = const Value.absent(),
                Value<int> intervalDays = const Value.absent(),
                Value<int> repetitions = const Value.absent(),
                Value<int> lapses = const Value.absent(),
                Value<int> dueAt = const Value.absent(),
                Value<int?> lastReviewedAt = const Value.absent(),
              }) => SrsCardsCompanion(
                id: id,
                itemType: itemType,
                itemId: itemId,
                skill: skill,
                ease: ease,
                intervalDays: intervalDays,
                repetitions: repetitions,
                lapses: lapses,
                dueAt: dueAt,
                lastReviewedAt: lastReviewedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String itemType,
                required int itemId,
                required String skill,
                Value<double> ease = const Value.absent(),
                Value<int> intervalDays = const Value.absent(),
                Value<int> repetitions = const Value.absent(),
                Value<int> lapses = const Value.absent(),
                required int dueAt,
                Value<int?> lastReviewedAt = const Value.absent(),
              }) => SrsCardsCompanion.insert(
                id: id,
                itemType: itemType,
                itemId: itemId,
                skill: skill,
                ease: ease,
                intervalDays: intervalDays,
                repetitions: repetitions,
                lapses: lapses,
                dueAt: dueAt,
                lastReviewedAt: lastReviewedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$SrsCardsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({reviewLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (reviewLogsRefs) db.reviewLogs],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (reviewLogsRefs)
                    await $_getPrefetchedData<
                      SrsCard,
                      $SrsCardsTable,
                      ReviewLog
                    >(
                      currentTable: table,
                      referencedTable: $$SrsCardsTableReferences
                          ._reviewLogsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$SrsCardsTableReferences(
                                db,
                                table,
                                p0,
                              ).reviewLogsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.cardId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SrsCardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SrsCardsTable,
      SrsCard,
      $$SrsCardsTableFilterComposer,
      $$SrsCardsTableOrderingComposer,
      $$SrsCardsTableAnnotationComposer,
      $$SrsCardsTableCreateCompanionBuilder,
      $$SrsCardsTableUpdateCompanionBuilder,
      (SrsCard, $$SrsCardsTableReferences),
      SrsCard,
      PrefetchHooks Function({bool reviewLogsRefs})
    >;
typedef $$ReviewLogsTableCreateCompanionBuilder =
    ReviewLogsCompanion Function({
      Value<int> id,
      Value<int?> cardId,
      required String game,
      required int correct,
      required int responseMs,
      required int quality,
      required int reviewedAt,
    });
typedef $$ReviewLogsTableUpdateCompanionBuilder =
    ReviewLogsCompanion Function({
      Value<int> id,
      Value<int?> cardId,
      Value<String> game,
      Value<int> correct,
      Value<int> responseMs,
      Value<int> quality,
      Value<int> reviewedAt,
    });

final class $$ReviewLogsTableReferences
    extends BaseReferences<_$AppDatabase, $ReviewLogsTable, ReviewLog> {
  $$ReviewLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SrsCardsTable _cardIdTable(_$AppDatabase db) => db.srsCards
      .createAlias($_aliasNameGenerator(db.reviewLogs.cardId, db.srsCards.id));

  $$SrsCardsTableProcessedTableManager? get cardId {
    final $_column = $_itemColumn<int>('card_id');
    if ($_column == null) return null;
    final manager = $$SrsCardsTableTableManager(
      $_db,
      $_db.srsCards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReviewLogsTableFilterComposer
    extends Composer<_$AppDatabase, $ReviewLogsTable> {
  $$ReviewLogsTableFilterComposer({
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

  ColumnFilters<String> get game => $composableBuilder(
    column: $table.game,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get responseMs => $composableBuilder(
    column: $table.responseMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quality => $composableBuilder(
    column: $table.quality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SrsCardsTableFilterComposer get cardId {
    final $$SrsCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.srsCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SrsCardsTableFilterComposer(
            $db: $db,
            $table: $db.srsCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReviewLogsTable> {
  $$ReviewLogsTableOrderingComposer({
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

  ColumnOrderings<String> get game => $composableBuilder(
    column: $table.game,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get responseMs => $composableBuilder(
    column: $table.responseMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quality => $composableBuilder(
    column: $table.quality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SrsCardsTableOrderingComposer get cardId {
    final $$SrsCardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.srsCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SrsCardsTableOrderingComposer(
            $db: $db,
            $table: $db.srsCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReviewLogsTable> {
  $$ReviewLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get game =>
      $composableBuilder(column: $table.game, builder: (column) => column);

  GeneratedColumn<int> get correct =>
      $composableBuilder(column: $table.correct, builder: (column) => column);

  GeneratedColumn<int> get responseMs => $composableBuilder(
    column: $table.responseMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quality =>
      $composableBuilder(column: $table.quality, builder: (column) => column);

  GeneratedColumn<int> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => column,
  );

  $$SrsCardsTableAnnotationComposer get cardId {
    final $$SrsCardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.srsCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SrsCardsTableAnnotationComposer(
            $db: $db,
            $table: $db.srsCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReviewLogsTable,
          ReviewLog,
          $$ReviewLogsTableFilterComposer,
          $$ReviewLogsTableOrderingComposer,
          $$ReviewLogsTableAnnotationComposer,
          $$ReviewLogsTableCreateCompanionBuilder,
          $$ReviewLogsTableUpdateCompanionBuilder,
          (ReviewLog, $$ReviewLogsTableReferences),
          ReviewLog,
          PrefetchHooks Function({bool cardId})
        > {
  $$ReviewLogsTableTableManager(_$AppDatabase db, $ReviewLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ReviewLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$ReviewLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$ReviewLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> cardId = const Value.absent(),
                Value<String> game = const Value.absent(),
                Value<int> correct = const Value.absent(),
                Value<int> responseMs = const Value.absent(),
                Value<int> quality = const Value.absent(),
                Value<int> reviewedAt = const Value.absent(),
              }) => ReviewLogsCompanion(
                id: id,
                cardId: cardId,
                game: game,
                correct: correct,
                responseMs: responseMs,
                quality: quality,
                reviewedAt: reviewedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> cardId = const Value.absent(),
                required String game,
                required int correct,
                required int responseMs,
                required int quality,
                required int reviewedAt,
              }) => ReviewLogsCompanion.insert(
                id: id,
                cardId: cardId,
                game: game,
                correct: correct,
                responseMs: responseMs,
                quality: quality,
                reviewedAt: reviewedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$ReviewLogsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({cardId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                if (cardId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.cardId,
                            referencedTable: $$ReviewLogsTableReferences
                                ._cardIdTable(db),
                            referencedColumn:
                                $$ReviewLogsTableReferences._cardIdTable(db).id,
                          )
                          as T;
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

typedef $$ReviewLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReviewLogsTable,
      ReviewLog,
      $$ReviewLogsTableFilterComposer,
      $$ReviewLogsTableOrderingComposer,
      $$ReviewLogsTableAnnotationComposer,
      $$ReviewLogsTableCreateCompanionBuilder,
      $$ReviewLogsTableUpdateCompanionBuilder,
      (ReviewLog, $$ReviewLogsTableReferences),
      ReviewLog,
      PrefetchHooks Function({bool cardId})
    >;
typedef $$SentenceStructuresTableCreateCompanionBuilder =
    SentenceStructuresCompanion Function({
      Value<int> id,
      required String sentence,
      required int level,
      required int wordCount,
      Value<String?> subjectSpan,
      Value<String?> verbSpan,
      Value<String?> chunksJson,
      Value<String?> layersJson,
      Value<String?> connectorsJson,
      Value<String?> simpleMeaning,
      Value<String?> audioPath,
    });
typedef $$SentenceStructuresTableUpdateCompanionBuilder =
    SentenceStructuresCompanion Function({
      Value<int> id,
      Value<String> sentence,
      Value<int> level,
      Value<int> wordCount,
      Value<String?> subjectSpan,
      Value<String?> verbSpan,
      Value<String?> chunksJson,
      Value<String?> layersJson,
      Value<String?> connectorsJson,
      Value<String?> simpleMeaning,
      Value<String?> audioPath,
    });

class $$SentenceStructuresTableFilterComposer
    extends Composer<_$AppDatabase, $SentenceStructuresTable> {
  $$SentenceStructuresTableFilterComposer({
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

  ColumnFilters<String> get sentence => $composableBuilder(
    column: $table.sentence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wordCount => $composableBuilder(
    column: $table.wordCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subjectSpan => $composableBuilder(
    column: $table.subjectSpan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get verbSpan => $composableBuilder(
    column: $table.verbSpan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chunksJson => $composableBuilder(
    column: $table.chunksJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get layersJson => $composableBuilder(
    column: $table.layersJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get connectorsJson => $composableBuilder(
    column: $table.connectorsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get simpleMeaning => $composableBuilder(
    column: $table.simpleMeaning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SentenceStructuresTableOrderingComposer
    extends Composer<_$AppDatabase, $SentenceStructuresTable> {
  $$SentenceStructuresTableOrderingComposer({
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

  ColumnOrderings<String> get sentence => $composableBuilder(
    column: $table.sentence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wordCount => $composableBuilder(
    column: $table.wordCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subjectSpan => $composableBuilder(
    column: $table.subjectSpan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get verbSpan => $composableBuilder(
    column: $table.verbSpan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chunksJson => $composableBuilder(
    column: $table.chunksJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get layersJson => $composableBuilder(
    column: $table.layersJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get connectorsJson => $composableBuilder(
    column: $table.connectorsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get simpleMeaning => $composableBuilder(
    column: $table.simpleMeaning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SentenceStructuresTableAnnotationComposer
    extends Composer<_$AppDatabase, $SentenceStructuresTable> {
  $$SentenceStructuresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sentence =>
      $composableBuilder(column: $table.sentence, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get wordCount =>
      $composableBuilder(column: $table.wordCount, builder: (column) => column);

  GeneratedColumn<String> get subjectSpan => $composableBuilder(
    column: $table.subjectSpan,
    builder: (column) => column,
  );

  GeneratedColumn<String> get verbSpan =>
      $composableBuilder(column: $table.verbSpan, builder: (column) => column);

  GeneratedColumn<String> get chunksJson => $composableBuilder(
    column: $table.chunksJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get layersJson => $composableBuilder(
    column: $table.layersJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get connectorsJson => $composableBuilder(
    column: $table.connectorsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get simpleMeaning => $composableBuilder(
    column: $table.simpleMeaning,
    builder: (column) => column,
  );

  GeneratedColumn<String> get audioPath =>
      $composableBuilder(column: $table.audioPath, builder: (column) => column);
}

class $$SentenceStructuresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SentenceStructuresTable,
          SentenceStructure,
          $$SentenceStructuresTableFilterComposer,
          $$SentenceStructuresTableOrderingComposer,
          $$SentenceStructuresTableAnnotationComposer,
          $$SentenceStructuresTableCreateCompanionBuilder,
          $$SentenceStructuresTableUpdateCompanionBuilder,
          (
            SentenceStructure,
            BaseReferences<
              _$AppDatabase,
              $SentenceStructuresTable,
              SentenceStructure
            >,
          ),
          SentenceStructure,
          PrefetchHooks Function()
        > {
  $$SentenceStructuresTableTableManager(
    _$AppDatabase db,
    $SentenceStructuresTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$SentenceStructuresTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$SentenceStructuresTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$SentenceStructuresTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> sentence = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<int> wordCount = const Value.absent(),
                Value<String?> subjectSpan = const Value.absent(),
                Value<String?> verbSpan = const Value.absent(),
                Value<String?> chunksJson = const Value.absent(),
                Value<String?> layersJson = const Value.absent(),
                Value<String?> connectorsJson = const Value.absent(),
                Value<String?> simpleMeaning = const Value.absent(),
                Value<String?> audioPath = const Value.absent(),
              }) => SentenceStructuresCompanion(
                id: id,
                sentence: sentence,
                level: level,
                wordCount: wordCount,
                subjectSpan: subjectSpan,
                verbSpan: verbSpan,
                chunksJson: chunksJson,
                layersJson: layersJson,
                connectorsJson: connectorsJson,
                simpleMeaning: simpleMeaning,
                audioPath: audioPath,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String sentence,
                required int level,
                required int wordCount,
                Value<String?> subjectSpan = const Value.absent(),
                Value<String?> verbSpan = const Value.absent(),
                Value<String?> chunksJson = const Value.absent(),
                Value<String?> layersJson = const Value.absent(),
                Value<String?> connectorsJson = const Value.absent(),
                Value<String?> simpleMeaning = const Value.absent(),
                Value<String?> audioPath = const Value.absent(),
              }) => SentenceStructuresCompanion.insert(
                id: id,
                sentence: sentence,
                level: level,
                wordCount: wordCount,
                subjectSpan: subjectSpan,
                verbSpan: verbSpan,
                chunksJson: chunksJson,
                layersJson: layersJson,
                connectorsJson: connectorsJson,
                simpleMeaning: simpleMeaning,
                audioPath: audioPath,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SentenceStructuresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SentenceStructuresTable,
      SentenceStructure,
      $$SentenceStructuresTableFilterComposer,
      $$SentenceStructuresTableOrderingComposer,
      $$SentenceStructuresTableAnnotationComposer,
      $$SentenceStructuresTableCreateCompanionBuilder,
      $$SentenceStructuresTableUpdateCompanionBuilder,
      (
        SentenceStructure,
        BaseReferences<
          _$AppDatabase,
          $SentenceStructuresTable,
          SentenceStructure
        >,
      ),
      SentenceStructure,
      PrefetchHooks Function()
    >;
typedef $$ParagraphsTableCreateCompanionBuilder =
    ParagraphsCompanion Function({
      Value<int> id,
      required int level,
      Value<String?> topic,
      required String sentencesJson,
      required String validOrdersJson,
      required String linksJson,
    });
typedef $$ParagraphsTableUpdateCompanionBuilder =
    ParagraphsCompanion Function({
      Value<int> id,
      Value<int> level,
      Value<String?> topic,
      Value<String> sentencesJson,
      Value<String> validOrdersJson,
      Value<String> linksJson,
    });

class $$ParagraphsTableFilterComposer
    extends Composer<_$AppDatabase, $ParagraphsTable> {
  $$ParagraphsTableFilterComposer({
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

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topic => $composableBuilder(
    column: $table.topic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sentencesJson => $composableBuilder(
    column: $table.sentencesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get validOrdersJson => $composableBuilder(
    column: $table.validOrdersJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linksJson => $composableBuilder(
    column: $table.linksJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ParagraphsTableOrderingComposer
    extends Composer<_$AppDatabase, $ParagraphsTable> {
  $$ParagraphsTableOrderingComposer({
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

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topic => $composableBuilder(
    column: $table.topic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sentencesJson => $composableBuilder(
    column: $table.sentencesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get validOrdersJson => $composableBuilder(
    column: $table.validOrdersJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linksJson => $composableBuilder(
    column: $table.linksJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ParagraphsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ParagraphsTable> {
  $$ParagraphsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get topic =>
      $composableBuilder(column: $table.topic, builder: (column) => column);

  GeneratedColumn<String> get sentencesJson => $composableBuilder(
    column: $table.sentencesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get validOrdersJson => $composableBuilder(
    column: $table.validOrdersJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get linksJson =>
      $composableBuilder(column: $table.linksJson, builder: (column) => column);
}

class $$ParagraphsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ParagraphsTable,
          Paragraph,
          $$ParagraphsTableFilterComposer,
          $$ParagraphsTableOrderingComposer,
          $$ParagraphsTableAnnotationComposer,
          $$ParagraphsTableCreateCompanionBuilder,
          $$ParagraphsTableUpdateCompanionBuilder,
          (
            Paragraph,
            BaseReferences<_$AppDatabase, $ParagraphsTable, Paragraph>,
          ),
          Paragraph,
          PrefetchHooks Function()
        > {
  $$ParagraphsTableTableManager(_$AppDatabase db, $ParagraphsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ParagraphsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$ParagraphsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$ParagraphsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<String?> topic = const Value.absent(),
                Value<String> sentencesJson = const Value.absent(),
                Value<String> validOrdersJson = const Value.absent(),
                Value<String> linksJson = const Value.absent(),
              }) => ParagraphsCompanion(
                id: id,
                level: level,
                topic: topic,
                sentencesJson: sentencesJson,
                validOrdersJson: validOrdersJson,
                linksJson: linksJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int level,
                Value<String?> topic = const Value.absent(),
                required String sentencesJson,
                required String validOrdersJson,
                required String linksJson,
              }) => ParagraphsCompanion.insert(
                id: id,
                level: level,
                topic: topic,
                sentencesJson: sentencesJson,
                validOrdersJson: validOrdersJson,
                linksJson: linksJson,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ParagraphsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ParagraphsTable,
      Paragraph,
      $$ParagraphsTableFilterComposer,
      $$ParagraphsTableOrderingComposer,
      $$ParagraphsTableAnnotationComposer,
      $$ParagraphsTableCreateCompanionBuilder,
      $$ParagraphsTableUpdateCompanionBuilder,
      (Paragraph, BaseReferences<_$AppDatabase, $ParagraphsTable, Paragraph>),
      Paragraph,
      PrefetchHooks Function()
    >;
typedef $$ChunkSentencesTableCreateCompanionBuilder =
    ChunkSentencesCompanion Function({
      Value<int> id,
      required int level,
      required String textContent,
      required String chunksJson,
      Value<String?> audioPath,
      Value<String?> audioSlowPath,
      Value<String?> chunkTimingsJson,
    });
typedef $$ChunkSentencesTableUpdateCompanionBuilder =
    ChunkSentencesCompanion Function({
      Value<int> id,
      Value<int> level,
      Value<String> textContent,
      Value<String> chunksJson,
      Value<String?> audioPath,
      Value<String?> audioSlowPath,
      Value<String?> chunkTimingsJson,
    });

class $$ChunkSentencesTableFilterComposer
    extends Composer<_$AppDatabase, $ChunkSentencesTable> {
  $$ChunkSentencesTableFilterComposer({
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

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textContent => $composableBuilder(
    column: $table.textContent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chunksJson => $composableBuilder(
    column: $table.chunksJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioSlowPath => $composableBuilder(
    column: $table.audioSlowPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chunkTimingsJson => $composableBuilder(
    column: $table.chunkTimingsJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChunkSentencesTableOrderingComposer
    extends Composer<_$AppDatabase, $ChunkSentencesTable> {
  $$ChunkSentencesTableOrderingComposer({
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

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textContent => $composableBuilder(
    column: $table.textContent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chunksJson => $composableBuilder(
    column: $table.chunksJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioSlowPath => $composableBuilder(
    column: $table.audioSlowPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chunkTimingsJson => $composableBuilder(
    column: $table.chunkTimingsJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChunkSentencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChunkSentencesTable> {
  $$ChunkSentencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get textContent => $composableBuilder(
    column: $table.textContent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get chunksJson => $composableBuilder(
    column: $table.chunksJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get audioPath =>
      $composableBuilder(column: $table.audioPath, builder: (column) => column);

  GeneratedColumn<String> get audioSlowPath => $composableBuilder(
    column: $table.audioSlowPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get chunkTimingsJson => $composableBuilder(
    column: $table.chunkTimingsJson,
    builder: (column) => column,
  );
}

class $$ChunkSentencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChunkSentencesTable,
          ChunkSentence,
          $$ChunkSentencesTableFilterComposer,
          $$ChunkSentencesTableOrderingComposer,
          $$ChunkSentencesTableAnnotationComposer,
          $$ChunkSentencesTableCreateCompanionBuilder,
          $$ChunkSentencesTableUpdateCompanionBuilder,
          (
            ChunkSentence,
            BaseReferences<_$AppDatabase, $ChunkSentencesTable, ChunkSentence>,
          ),
          ChunkSentence,
          PrefetchHooks Function()
        > {
  $$ChunkSentencesTableTableManager(
    _$AppDatabase db,
    $ChunkSentencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ChunkSentencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$ChunkSentencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$ChunkSentencesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<String> textContent = const Value.absent(),
                Value<String> chunksJson = const Value.absent(),
                Value<String?> audioPath = const Value.absent(),
                Value<String?> audioSlowPath = const Value.absent(),
                Value<String?> chunkTimingsJson = const Value.absent(),
              }) => ChunkSentencesCompanion(
                id: id,
                level: level,
                textContent: textContent,
                chunksJson: chunksJson,
                audioPath: audioPath,
                audioSlowPath: audioSlowPath,
                chunkTimingsJson: chunkTimingsJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int level,
                required String textContent,
                required String chunksJson,
                Value<String?> audioPath = const Value.absent(),
                Value<String?> audioSlowPath = const Value.absent(),
                Value<String?> chunkTimingsJson = const Value.absent(),
              }) => ChunkSentencesCompanion.insert(
                id: id,
                level: level,
                textContent: textContent,
                chunksJson: chunksJson,
                audioPath: audioPath,
                audioSlowPath: audioSlowPath,
                chunkTimingsJson: chunkTimingsJson,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChunkSentencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChunkSentencesTable,
      ChunkSentence,
      $$ChunkSentencesTableFilterComposer,
      $$ChunkSentencesTableOrderingComposer,
      $$ChunkSentencesTableAnnotationComposer,
      $$ChunkSentencesTableCreateCompanionBuilder,
      $$ChunkSentencesTableUpdateCompanionBuilder,
      (
        ChunkSentence,
        BaseReferences<_$AppDatabase, $ChunkSentencesTable, ChunkSentence>,
      ),
      ChunkSentence,
      PrefetchHooks Function()
    >;
typedef $$PassagesTableCreateCompanionBuilder =
    PassagesCompanion Function({
      Value<int> id,
      required String title,
      required String body,
      Value<String?> cefr,
      required int wordCount,
      Value<String?> audioPath,
    });
typedef $$PassagesTableUpdateCompanionBuilder =
    PassagesCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> body,
      Value<String?> cefr,
      Value<int> wordCount,
      Value<String?> audioPath,
    });

final class $$PassagesTableReferences
    extends BaseReferences<_$AppDatabase, $PassagesTable, Passage> {
  $$PassagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$QuestionsTable, List<Question>>
  _questionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.questions,
    aliasName: $_aliasNameGenerator(db.passages.id, db.questions.passageId),
  );

  $$QuestionsTableProcessedTableManager get questionsRefs {
    final manager = $$QuestionsTableTableManager(
      $_db,
      $_db.questions,
    ).filter((f) => f.passageId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_questionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PassagesTableFilterComposer
    extends Composer<_$AppDatabase, $PassagesTable> {
  $$PassagesTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cefr => $composableBuilder(
    column: $table.cefr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wordCount => $composableBuilder(
    column: $table.wordCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> questionsRefs(
    Expression<bool> Function($$QuestionsTableFilterComposer f) f,
  ) {
    final $$QuestionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.questions,
      getReferencedColumn: (t) => t.passageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionsTableFilterComposer(
            $db: $db,
            $table: $db.questions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PassagesTableOrderingComposer
    extends Composer<_$AppDatabase, $PassagesTable> {
  $$PassagesTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cefr => $composableBuilder(
    column: $table.cefr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wordCount => $composableBuilder(
    column: $table.wordCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PassagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PassagesTable> {
  $$PassagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get cefr =>
      $composableBuilder(column: $table.cefr, builder: (column) => column);

  GeneratedColumn<int> get wordCount =>
      $composableBuilder(column: $table.wordCount, builder: (column) => column);

  GeneratedColumn<String> get audioPath =>
      $composableBuilder(column: $table.audioPath, builder: (column) => column);

  Expression<T> questionsRefs<T extends Object>(
    Expression<T> Function($$QuestionsTableAnnotationComposer a) f,
  ) {
    final $$QuestionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.questions,
      getReferencedColumn: (t) => t.passageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionsTableAnnotationComposer(
            $db: $db,
            $table: $db.questions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PassagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PassagesTable,
          Passage,
          $$PassagesTableFilterComposer,
          $$PassagesTableOrderingComposer,
          $$PassagesTableAnnotationComposer,
          $$PassagesTableCreateCompanionBuilder,
          $$PassagesTableUpdateCompanionBuilder,
          (Passage, $$PassagesTableReferences),
          Passage,
          PrefetchHooks Function({bool questionsRefs})
        > {
  $$PassagesTableTableManager(_$AppDatabase db, $PassagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$PassagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$PassagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$PassagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String?> cefr = const Value.absent(),
                Value<int> wordCount = const Value.absent(),
                Value<String?> audioPath = const Value.absent(),
              }) => PassagesCompanion(
                id: id,
                title: title,
                body: body,
                cefr: cefr,
                wordCount: wordCount,
                audioPath: audioPath,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String body,
                Value<String?> cefr = const Value.absent(),
                required int wordCount,
                Value<String?> audioPath = const Value.absent(),
              }) => PassagesCompanion.insert(
                id: id,
                title: title,
                body: body,
                cefr: cefr,
                wordCount: wordCount,
                audioPath: audioPath,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$PassagesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({questionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (questionsRefs) db.questions],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (questionsRefs)
                    await $_getPrefetchedData<
                      Passage,
                      $PassagesTable,
                      Question
                    >(
                      currentTable: table,
                      referencedTable: $$PassagesTableReferences
                          ._questionsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$PassagesTableReferences(
                                db,
                                table,
                                p0,
                              ).questionsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.passageId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PassagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PassagesTable,
      Passage,
      $$PassagesTableFilterComposer,
      $$PassagesTableOrderingComposer,
      $$PassagesTableAnnotationComposer,
      $$PassagesTableCreateCompanionBuilder,
      $$PassagesTableUpdateCompanionBuilder,
      (Passage, $$PassagesTableReferences),
      Passage,
      PrefetchHooks Function({bool questionsRefs})
    >;
typedef $$QuestionsTableCreateCompanionBuilder =
    QuestionsCompanion Function({
      Value<int> id,
      required int passageId,
      required String type,
      required String prompt,
      Value<String?> options,
      required String answer,
      Value<String?> explanation,
    });
typedef $$QuestionsTableUpdateCompanionBuilder =
    QuestionsCompanion Function({
      Value<int> id,
      Value<int> passageId,
      Value<String> type,
      Value<String> prompt,
      Value<String?> options,
      Value<String> answer,
      Value<String?> explanation,
    });

final class $$QuestionsTableReferences
    extends BaseReferences<_$AppDatabase, $QuestionsTable, Question> {
  $$QuestionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PassagesTable _passageIdTable(_$AppDatabase db) =>
      db.passages.createAlias(
        $_aliasNameGenerator(db.questions.passageId, db.passages.id),
      );

  $$PassagesTableProcessedTableManager get passageId {
    final $_column = $_itemColumn<int>('passage_id')!;

    final manager = $$PassagesTableTableManager(
      $_db,
      $_db.passages,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_passageIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$QuestionsTableFilterComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableFilterComposer({
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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prompt => $composableBuilder(
    column: $table.prompt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get options => $composableBuilder(
    column: $table.options,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get answer => $composableBuilder(
    column: $table.answer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnFilters(column),
  );

  $$PassagesTableFilterComposer get passageId {
    final $$PassagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.passageId,
      referencedTable: $db.passages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PassagesTableFilterComposer(
            $db: $db,
            $table: $db.passages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuestionsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prompt => $composableBuilder(
    column: $table.prompt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get options => $composableBuilder(
    column: $table.options,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answer => $composableBuilder(
    column: $table.answer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnOrderings(column),
  );

  $$PassagesTableOrderingComposer get passageId {
    final $$PassagesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.passageId,
      referencedTable: $db.passages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PassagesTableOrderingComposer(
            $db: $db,
            $table: $db.passages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuestionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get prompt =>
      $composableBuilder(column: $table.prompt, builder: (column) => column);

  GeneratedColumn<String> get options =>
      $composableBuilder(column: $table.options, builder: (column) => column);

  GeneratedColumn<String> get answer =>
      $composableBuilder(column: $table.answer, builder: (column) => column);

  GeneratedColumn<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => column,
  );

  $$PassagesTableAnnotationComposer get passageId {
    final $$PassagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.passageId,
      referencedTable: $db.passages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PassagesTableAnnotationComposer(
            $db: $db,
            $table: $db.passages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuestionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuestionsTable,
          Question,
          $$QuestionsTableFilterComposer,
          $$QuestionsTableOrderingComposer,
          $$QuestionsTableAnnotationComposer,
          $$QuestionsTableCreateCompanionBuilder,
          $$QuestionsTableUpdateCompanionBuilder,
          (Question, $$QuestionsTableReferences),
          Question,
          PrefetchHooks Function({bool passageId})
        > {
  $$QuestionsTableTableManager(_$AppDatabase db, $QuestionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$QuestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$QuestionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$QuestionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> passageId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> prompt = const Value.absent(),
                Value<String?> options = const Value.absent(),
                Value<String> answer = const Value.absent(),
                Value<String?> explanation = const Value.absent(),
              }) => QuestionsCompanion(
                id: id,
                passageId: passageId,
                type: type,
                prompt: prompt,
                options: options,
                answer: answer,
                explanation: explanation,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int passageId,
                required String type,
                required String prompt,
                Value<String?> options = const Value.absent(),
                required String answer,
                Value<String?> explanation = const Value.absent(),
              }) => QuestionsCompanion.insert(
                id: id,
                passageId: passageId,
                type: type,
                prompt: prompt,
                options: options,
                answer: answer,
                explanation: explanation,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$QuestionsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({passageId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                if (passageId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.passageId,
                            referencedTable: $$QuestionsTableReferences
                                ._passageIdTable(db),
                            referencedColumn:
                                $$QuestionsTableReferences
                                    ._passageIdTable(db)
                                    .id,
                          )
                          as T;
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

typedef $$QuestionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuestionsTable,
      Question,
      $$QuestionsTableFilterComposer,
      $$QuestionsTableOrderingComposer,
      $$QuestionsTableAnnotationComposer,
      $$QuestionsTableCreateCompanionBuilder,
      $$QuestionsTableUpdateCompanionBuilder,
      (Question, $$QuestionsTableReferences),
      Question,
      PrefetchHooks Function({bool passageId})
    >;
typedef $$UserTextsTableCreateCompanionBuilder =
    UserTextsCompanion Function({
      Value<int> id,
      required String prompt,
      required String body,
      required int createdAt,
      Value<int?> selfScore,
    });
typedef $$UserTextsTableUpdateCompanionBuilder =
    UserTextsCompanion Function({
      Value<int> id,
      Value<String> prompt,
      Value<String> body,
      Value<int> createdAt,
      Value<int?> selfScore,
    });

class $$UserTextsTableFilterComposer
    extends Composer<_$AppDatabase, $UserTextsTable> {
  $$UserTextsTableFilterComposer({
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

  ColumnFilters<String> get prompt => $composableBuilder(
    column: $table.prompt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get selfScore => $composableBuilder(
    column: $table.selfScore,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserTextsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserTextsTable> {
  $$UserTextsTableOrderingComposer({
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

  ColumnOrderings<String> get prompt => $composableBuilder(
    column: $table.prompt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get selfScore => $composableBuilder(
    column: $table.selfScore,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserTextsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserTextsTable> {
  $$UserTextsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get prompt =>
      $composableBuilder(column: $table.prompt, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get selfScore =>
      $composableBuilder(column: $table.selfScore, builder: (column) => column);
}

class $$UserTextsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserTextsTable,
          UserText,
          $$UserTextsTableFilterComposer,
          $$UserTextsTableOrderingComposer,
          $$UserTextsTableAnnotationComposer,
          $$UserTextsTableCreateCompanionBuilder,
          $$UserTextsTableUpdateCompanionBuilder,
          (UserText, BaseReferences<_$AppDatabase, $UserTextsTable, UserText>),
          UserText,
          PrefetchHooks Function()
        > {
  $$UserTextsTableTableManager(_$AppDatabase db, $UserTextsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$UserTextsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$UserTextsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$UserTextsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> prompt = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int?> selfScore = const Value.absent(),
              }) => UserTextsCompanion(
                id: id,
                prompt: prompt,
                body: body,
                createdAt: createdAt,
                selfScore: selfScore,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String prompt,
                required String body,
                required int createdAt,
                Value<int?> selfScore = const Value.absent(),
              }) => UserTextsCompanion.insert(
                id: id,
                prompt: prompt,
                body: body,
                createdAt: createdAt,
                selfScore: selfScore,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserTextsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserTextsTable,
      UserText,
      $$UserTextsTableFilterComposer,
      $$UserTextsTableOrderingComposer,
      $$UserTextsTableAnnotationComposer,
      $$UserTextsTableCreateCompanionBuilder,
      $$UserTextsTableUpdateCompanionBuilder,
      (UserText, BaseReferences<_$AppDatabase, $UserTextsTable, UserText>),
      UserText,
      PrefetchHooks Function()
    >;
typedef $$RecordingsTableCreateCompanionBuilder =
    RecordingsCompanion Function({
      Value<int> id,
      required String prompt,
      required String filePath,
      required int durationMs,
      Value<String?> sttText,
      Value<double?> score,
      required int createdAt,
    });
typedef $$RecordingsTableUpdateCompanionBuilder =
    RecordingsCompanion Function({
      Value<int> id,
      Value<String> prompt,
      Value<String> filePath,
      Value<int> durationMs,
      Value<String?> sttText,
      Value<double?> score,
      Value<int> createdAt,
    });

class $$RecordingsTableFilterComposer
    extends Composer<_$AppDatabase, $RecordingsTable> {
  $$RecordingsTableFilterComposer({
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

  ColumnFilters<String> get prompt => $composableBuilder(
    column: $table.prompt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sttText => $composableBuilder(
    column: $table.sttText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecordingsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecordingsTable> {
  $$RecordingsTableOrderingComposer({
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

  ColumnOrderings<String> get prompt => $composableBuilder(
    column: $table.prompt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sttText => $composableBuilder(
    column: $table.sttText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecordingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecordingsTable> {
  $$RecordingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get prompt =>
      $composableBuilder(column: $table.prompt, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sttText =>
      $composableBuilder(column: $table.sttText, builder: (column) => column);

  GeneratedColumn<double> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RecordingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecordingsTable,
          Recording,
          $$RecordingsTableFilterComposer,
          $$RecordingsTableOrderingComposer,
          $$RecordingsTableAnnotationComposer,
          $$RecordingsTableCreateCompanionBuilder,
          $$RecordingsTableUpdateCompanionBuilder,
          (
            Recording,
            BaseReferences<_$AppDatabase, $RecordingsTable, Recording>,
          ),
          Recording,
          PrefetchHooks Function()
        > {
  $$RecordingsTableTableManager(_$AppDatabase db, $RecordingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$RecordingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$RecordingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$RecordingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> prompt = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
                Value<String?> sttText = const Value.absent(),
                Value<double?> score = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
              }) => RecordingsCompanion(
                id: id,
                prompt: prompt,
                filePath: filePath,
                durationMs: durationMs,
                sttText: sttText,
                score: score,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String prompt,
                required String filePath,
                required int durationMs,
                Value<String?> sttText = const Value.absent(),
                Value<double?> score = const Value.absent(),
                required int createdAt,
              }) => RecordingsCompanion.insert(
                id: id,
                prompt: prompt,
                filePath: filePath,
                durationMs: durationMs,
                sttText: sttText,
                score: score,
                createdAt: createdAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecordingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecordingsTable,
      Recording,
      $$RecordingsTableFilterComposer,
      $$RecordingsTableOrderingComposer,
      $$RecordingsTableAnnotationComposer,
      $$RecordingsTableCreateCompanionBuilder,
      $$RecordingsTableUpdateCompanionBuilder,
      (Recording, BaseReferences<_$AppDatabase, $RecordingsTable, Recording>),
      Recording,
      PrefetchHooks Function()
    >;
typedef $$DailyStatsTableCreateCompanionBuilder =
    DailyStatsCompanion Function({
      required String day,
      Value<int> minutes,
      Value<int> xp,
      Value<int> itemsReviewed,
      Value<int> goalMet,
      Value<int> rowid,
    });
typedef $$DailyStatsTableUpdateCompanionBuilder =
    DailyStatsCompanion Function({
      Value<String> day,
      Value<int> minutes,
      Value<int> xp,
      Value<int> itemsReviewed,
      Value<int> goalMet,
      Value<int> rowid,
    });

class $$DailyStatsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyStatsTable> {
  $$DailyStatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minutes => $composableBuilder(
    column: $table.minutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get xp => $composableBuilder(
    column: $table.xp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get itemsReviewed => $composableBuilder(
    column: $table.itemsReviewed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get goalMet => $composableBuilder(
    column: $table.goalMet,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyStatsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyStatsTable> {
  $$DailyStatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minutes => $composableBuilder(
    column: $table.minutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get xp => $composableBuilder(
    column: $table.xp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get itemsReviewed => $composableBuilder(
    column: $table.itemsReviewed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get goalMet => $composableBuilder(
    column: $table.goalMet,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyStatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyStatsTable> {
  $$DailyStatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<int> get minutes =>
      $composableBuilder(column: $table.minutes, builder: (column) => column);

  GeneratedColumn<int> get xp =>
      $composableBuilder(column: $table.xp, builder: (column) => column);

  GeneratedColumn<int> get itemsReviewed => $composableBuilder(
    column: $table.itemsReviewed,
    builder: (column) => column,
  );

  GeneratedColumn<int> get goalMet =>
      $composableBuilder(column: $table.goalMet, builder: (column) => column);
}

class $$DailyStatsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyStatsTable,
          DailyStat,
          $$DailyStatsTableFilterComposer,
          $$DailyStatsTableOrderingComposer,
          $$DailyStatsTableAnnotationComposer,
          $$DailyStatsTableCreateCompanionBuilder,
          $$DailyStatsTableUpdateCompanionBuilder,
          (
            DailyStat,
            BaseReferences<_$AppDatabase, $DailyStatsTable, DailyStat>,
          ),
          DailyStat,
          PrefetchHooks Function()
        > {
  $$DailyStatsTableTableManager(_$AppDatabase db, $DailyStatsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$DailyStatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$DailyStatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$DailyStatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> day = const Value.absent(),
                Value<int> minutes = const Value.absent(),
                Value<int> xp = const Value.absent(),
                Value<int> itemsReviewed = const Value.absent(),
                Value<int> goalMet = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyStatsCompanion(
                day: day,
                minutes: minutes,
                xp: xp,
                itemsReviewed: itemsReviewed,
                goalMet: goalMet,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String day,
                Value<int> minutes = const Value.absent(),
                Value<int> xp = const Value.absent(),
                Value<int> itemsReviewed = const Value.absent(),
                Value<int> goalMet = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyStatsCompanion.insert(
                day: day,
                minutes: minutes,
                xp: xp,
                itemsReviewed: itemsReviewed,
                goalMet: goalMet,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyStatsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyStatsTable,
      DailyStat,
      $$DailyStatsTableFilterComposer,
      $$DailyStatsTableOrderingComposer,
      $$DailyStatsTableAnnotationComposer,
      $$DailyStatsTableCreateCompanionBuilder,
      $$DailyStatsTableUpdateCompanionBuilder,
      (DailyStat, BaseReferences<_$AppDatabase, $DailyStatsTable, DailyStat>),
      DailyStat,
      PrefetchHooks Function()
    >;
typedef $$StreaksTableCreateCompanionBuilder =
    StreaksCompanion Function({
      Value<int> id,
      Value<int> current,
      Value<int> best,
      Value<int> freezes,
      Value<String> lastDay,
      Value<int> totalDays,
    });
typedef $$StreaksTableUpdateCompanionBuilder =
    StreaksCompanion Function({
      Value<int> id,
      Value<int> current,
      Value<int> best,
      Value<int> freezes,
      Value<String> lastDay,
      Value<int> totalDays,
    });

class $$StreaksTableFilterComposer
    extends Composer<_$AppDatabase, $StreaksTable> {
  $$StreaksTableFilterComposer({
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

  ColumnFilters<int> get current => $composableBuilder(
    column: $table.current,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get best => $composableBuilder(
    column: $table.best,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get freezes => $composableBuilder(
    column: $table.freezes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastDay => $composableBuilder(
    column: $table.lastDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalDays => $composableBuilder(
    column: $table.totalDays,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StreaksTableOrderingComposer
    extends Composer<_$AppDatabase, $StreaksTable> {
  $$StreaksTableOrderingComposer({
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

  ColumnOrderings<int> get current => $composableBuilder(
    column: $table.current,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get best => $composableBuilder(
    column: $table.best,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get freezes => $composableBuilder(
    column: $table.freezes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastDay => $composableBuilder(
    column: $table.lastDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalDays => $composableBuilder(
    column: $table.totalDays,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StreaksTableAnnotationComposer
    extends Composer<_$AppDatabase, $StreaksTable> {
  $$StreaksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get current =>
      $composableBuilder(column: $table.current, builder: (column) => column);

  GeneratedColumn<int> get best =>
      $composableBuilder(column: $table.best, builder: (column) => column);

  GeneratedColumn<int> get freezes =>
      $composableBuilder(column: $table.freezes, builder: (column) => column);

  GeneratedColumn<String> get lastDay =>
      $composableBuilder(column: $table.lastDay, builder: (column) => column);

  GeneratedColumn<int> get totalDays =>
      $composableBuilder(column: $table.totalDays, builder: (column) => column);
}

class $$StreaksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StreaksTable,
          Streak,
          $$StreaksTableFilterComposer,
          $$StreaksTableOrderingComposer,
          $$StreaksTableAnnotationComposer,
          $$StreaksTableCreateCompanionBuilder,
          $$StreaksTableUpdateCompanionBuilder,
          (Streak, BaseReferences<_$AppDatabase, $StreaksTable, Streak>),
          Streak,
          PrefetchHooks Function()
        > {
  $$StreaksTableTableManager(_$AppDatabase db, $StreaksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$StreaksTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$StreaksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$StreaksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> current = const Value.absent(),
                Value<int> best = const Value.absent(),
                Value<int> freezes = const Value.absent(),
                Value<String> lastDay = const Value.absent(),
                Value<int> totalDays = const Value.absent(),
              }) => StreaksCompanion(
                id: id,
                current: current,
                best: best,
                freezes: freezes,
                lastDay: lastDay,
                totalDays: totalDays,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> current = const Value.absent(),
                Value<int> best = const Value.absent(),
                Value<int> freezes = const Value.absent(),
                Value<String> lastDay = const Value.absent(),
                Value<int> totalDays = const Value.absent(),
              }) => StreaksCompanion.insert(
                id: id,
                current: current,
                best: best,
                freezes: freezes,
                lastDay: lastDay,
                totalDays: totalDays,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StreaksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StreaksTable,
      Streak,
      $$StreaksTableFilterComposer,
      $$StreaksTableOrderingComposer,
      $$StreaksTableAnnotationComposer,
      $$StreaksTableCreateCompanionBuilder,
      $$StreaksTableUpdateCompanionBuilder,
      (Streak, BaseReferences<_$AppDatabase, $StreaksTable, Streak>),
      Streak,
      PrefetchHooks Function()
    >;
typedef $$AchievementsTableCreateCompanionBuilder =
    AchievementsCompanion Function({
      required String code,
      required int unlockedAt,
      Value<int> rowid,
    });
typedef $$AchievementsTableUpdateCompanionBuilder =
    AchievementsCompanion Function({
      Value<String> code,
      Value<int> unlockedAt,
      Value<int> rowid,
    });

class $$AchievementsTableFilterComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AchievementsTableOrderingComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AchievementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AchievementsTable> {
  $$AchievementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<int> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => column,
  );
}

class $$AchievementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AchievementsTable,
          Achievement,
          $$AchievementsTableFilterComposer,
          $$AchievementsTableOrderingComposer,
          $$AchievementsTableAnnotationComposer,
          $$AchievementsTableCreateCompanionBuilder,
          $$AchievementsTableUpdateCompanionBuilder,
          (
            Achievement,
            BaseReferences<_$AppDatabase, $AchievementsTable, Achievement>,
          ),
          Achievement,
          PrefetchHooks Function()
        > {
  $$AchievementsTableTableManager(_$AppDatabase db, $AchievementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$AchievementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$AchievementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$AchievementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> code = const Value.absent(),
                Value<int> unlockedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AchievementsCompanion(
                code: code,
                unlockedAt: unlockedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String code,
                required int unlockedAt,
                Value<int> rowid = const Value.absent(),
              }) => AchievementsCompanion.insert(
                code: code,
                unlockedAt: unlockedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AchievementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AchievementsTable,
      Achievement,
      $$AchievementsTableFilterComposer,
      $$AchievementsTableOrderingComposer,
      $$AchievementsTableAnnotationComposer,
      $$AchievementsTableCreateCompanionBuilder,
      $$AchievementsTableUpdateCompanionBuilder,
      (
        Achievement,
        BaseReferences<_$AppDatabase, $AchievementsTable, Achievement>,
      ),
      Achievement,
      PrefetchHooks Function()
    >;
typedef $$GameSessionsTableCreateCompanionBuilder =
    GameSessionsCompanion Function({
      Value<int> id,
      required String game,
      Value<String?> mode,
      Value<int?> level,
      required int startedAt,
      required int durationMs,
      required double accuracy,
      required int score,
      required int xpEarned,
      Value<int> hintsUsed,
      Value<String?> extraJson,
    });
typedef $$GameSessionsTableUpdateCompanionBuilder =
    GameSessionsCompanion Function({
      Value<int> id,
      Value<String> game,
      Value<String?> mode,
      Value<int?> level,
      Value<int> startedAt,
      Value<int> durationMs,
      Value<double> accuracy,
      Value<int> score,
      Value<int> xpEarned,
      Value<int> hintsUsed,
      Value<String?> extraJson,
    });

class $$GameSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $GameSessionsTable> {
  $$GameSessionsTableFilterComposer({
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

  ColumnFilters<String> get game => $composableBuilder(
    column: $table.game,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get accuracy => $composableBuilder(
    column: $table.accuracy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get xpEarned => $composableBuilder(
    column: $table.xpEarned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hintsUsed => $composableBuilder(
    column: $table.hintsUsed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get extraJson => $composableBuilder(
    column: $table.extraJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GameSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $GameSessionsTable> {
  $$GameSessionsTableOrderingComposer({
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

  ColumnOrderings<String> get game => $composableBuilder(
    column: $table.game,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get accuracy => $composableBuilder(
    column: $table.accuracy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get xpEarned => $composableBuilder(
    column: $table.xpEarned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hintsUsed => $composableBuilder(
    column: $table.hintsUsed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get extraJson => $composableBuilder(
    column: $table.extraJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GameSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GameSessionsTable> {
  $$GameSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get game =>
      $composableBuilder(column: $table.game, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<double> get accuracy =>
      $composableBuilder(column: $table.accuracy, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<int> get xpEarned =>
      $composableBuilder(column: $table.xpEarned, builder: (column) => column);

  GeneratedColumn<int> get hintsUsed =>
      $composableBuilder(column: $table.hintsUsed, builder: (column) => column);

  GeneratedColumn<String> get extraJson =>
      $composableBuilder(column: $table.extraJson, builder: (column) => column);
}

class $$GameSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GameSessionsTable,
          GameSession,
          $$GameSessionsTableFilterComposer,
          $$GameSessionsTableOrderingComposer,
          $$GameSessionsTableAnnotationComposer,
          $$GameSessionsTableCreateCompanionBuilder,
          $$GameSessionsTableUpdateCompanionBuilder,
          (
            GameSession,
            BaseReferences<_$AppDatabase, $GameSessionsTable, GameSession>,
          ),
          GameSession,
          PrefetchHooks Function()
        > {
  $$GameSessionsTableTableManager(_$AppDatabase db, $GameSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$GameSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$GameSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$GameSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> game = const Value.absent(),
                Value<String?> mode = const Value.absent(),
                Value<int?> level = const Value.absent(),
                Value<int> startedAt = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
                Value<double> accuracy = const Value.absent(),
                Value<int> score = const Value.absent(),
                Value<int> xpEarned = const Value.absent(),
                Value<int> hintsUsed = const Value.absent(),
                Value<String?> extraJson = const Value.absent(),
              }) => GameSessionsCompanion(
                id: id,
                game: game,
                mode: mode,
                level: level,
                startedAt: startedAt,
                durationMs: durationMs,
                accuracy: accuracy,
                score: score,
                xpEarned: xpEarned,
                hintsUsed: hintsUsed,
                extraJson: extraJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String game,
                Value<String?> mode = const Value.absent(),
                Value<int?> level = const Value.absent(),
                required int startedAt,
                required int durationMs,
                required double accuracy,
                required int score,
                required int xpEarned,
                Value<int> hintsUsed = const Value.absent(),
                Value<String?> extraJson = const Value.absent(),
              }) => GameSessionsCompanion.insert(
                id: id,
                game: game,
                mode: mode,
                level: level,
                startedAt: startedAt,
                durationMs: durationMs,
                accuracy: accuracy,
                score: score,
                xpEarned: xpEarned,
                hintsUsed: hintsUsed,
                extraJson: extraJson,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GameSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GameSessionsTable,
      GameSession,
      $$GameSessionsTableFilterComposer,
      $$GameSessionsTableOrderingComposer,
      $$GameSessionsTableAnnotationComposer,
      $$GameSessionsTableCreateCompanionBuilder,
      $$GameSessionsTableUpdateCompanionBuilder,
      (
        GameSession,
        BaseReferences<_$AppDatabase, $GameSessionsTable, GameSession>,
      ),
      GameSession,
      PrefetchHooks Function()
    >;
typedef $$PersonalBestsTableCreateCompanionBuilder =
    PersonalBestsCompanion Function({
      required String game,
      required String mode,
      required String metric,
      required double value,
      required int setAt,
      Value<int> rowid,
    });
typedef $$PersonalBestsTableUpdateCompanionBuilder =
    PersonalBestsCompanion Function({
      Value<String> game,
      Value<String> mode,
      Value<String> metric,
      Value<double> value,
      Value<int> setAt,
      Value<int> rowid,
    });

class $$PersonalBestsTableFilterComposer
    extends Composer<_$AppDatabase, $PersonalBestsTable> {
  $$PersonalBestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get game => $composableBuilder(
    column: $table.game,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metric => $composableBuilder(
    column: $table.metric,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get setAt => $composableBuilder(
    column: $table.setAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PersonalBestsTableOrderingComposer
    extends Composer<_$AppDatabase, $PersonalBestsTable> {
  $$PersonalBestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get game => $composableBuilder(
    column: $table.game,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metric => $composableBuilder(
    column: $table.metric,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get setAt => $composableBuilder(
    column: $table.setAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PersonalBestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersonalBestsTable> {
  $$PersonalBestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get game =>
      $composableBuilder(column: $table.game, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<String> get metric =>
      $composableBuilder(column: $table.metric, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<int> get setAt =>
      $composableBuilder(column: $table.setAt, builder: (column) => column);
}

class $$PersonalBestsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PersonalBestsTable,
          PersonalBest,
          $$PersonalBestsTableFilterComposer,
          $$PersonalBestsTableOrderingComposer,
          $$PersonalBestsTableAnnotationComposer,
          $$PersonalBestsTableCreateCompanionBuilder,
          $$PersonalBestsTableUpdateCompanionBuilder,
          (
            PersonalBest,
            BaseReferences<_$AppDatabase, $PersonalBestsTable, PersonalBest>,
          ),
          PersonalBest,
          PrefetchHooks Function()
        > {
  $$PersonalBestsTableTableManager(_$AppDatabase db, $PersonalBestsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$PersonalBestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$PersonalBestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$PersonalBestsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> game = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<String> metric = const Value.absent(),
                Value<double> value = const Value.absent(),
                Value<int> setAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PersonalBestsCompanion(
                game: game,
                mode: mode,
                metric: metric,
                value: value,
                setAt: setAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String game,
                required String mode,
                required String metric,
                required double value,
                required int setAt,
                Value<int> rowid = const Value.absent(),
              }) => PersonalBestsCompanion.insert(
                game: game,
                mode: mode,
                metric: metric,
                value: value,
                setAt: setAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PersonalBestsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PersonalBestsTable,
      PersonalBest,
      $$PersonalBestsTableFilterComposer,
      $$PersonalBestsTableOrderingComposer,
      $$PersonalBestsTableAnnotationComposer,
      $$PersonalBestsTableCreateCompanionBuilder,
      $$PersonalBestsTableUpdateCompanionBuilder,
      (
        PersonalBest,
        BaseReferences<_$AppDatabase, $PersonalBestsTable, PersonalBest>,
      ),
      PersonalBest,
      PrefetchHooks Function()
    >;
typedef $$WildItemsTableCreateCompanionBuilder =
    WildItemsCompanion Function({
      Value<int> id,
      Value<int?> wordId,
      required String sentence,
      Value<String?> source,
      required int savedAt,
    });
typedef $$WildItemsTableUpdateCompanionBuilder =
    WildItemsCompanion Function({
      Value<int> id,
      Value<int?> wordId,
      Value<String> sentence,
      Value<String?> source,
      Value<int> savedAt,
    });

final class $$WildItemsTableReferences
    extends BaseReferences<_$AppDatabase, $WildItemsTable, WildItem> {
  $$WildItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WordsTable _wordIdTable(_$AppDatabase db) => db.words.createAlias(
    $_aliasNameGenerator(db.wildItems.wordId, db.words.id),
  );

  $$WordsTableProcessedTableManager? get wordId {
    final $_column = $_itemColumn<int>('word_id');
    if ($_column == null) return null;
    final manager = $$WordsTableTableManager(
      $_db,
      $_db.words,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_wordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WildItemsTableFilterComposer
    extends Composer<_$AppDatabase, $WildItemsTable> {
  $$WildItemsTableFilterComposer({
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

  ColumnFilters<String> get sentence => $composableBuilder(
    column: $table.sentence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$WordsTableFilterComposer get wordId {
    final $$WordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableFilterComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WildItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $WildItemsTable> {
  $$WildItemsTableOrderingComposer({
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

  ColumnOrderings<String> get sentence => $composableBuilder(
    column: $table.sentence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$WordsTableOrderingComposer get wordId {
    final $$WordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableOrderingComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WildItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WildItemsTable> {
  $$WildItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sentence =>
      $composableBuilder(column: $table.sentence, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<int> get savedAt =>
      $composableBuilder(column: $table.savedAt, builder: (column) => column);

  $$WordsTableAnnotationComposer get wordId {
    final $$WordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.words,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableAnnotationComposer(
            $db: $db,
            $table: $db.words,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WildItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WildItemsTable,
          WildItem,
          $$WildItemsTableFilterComposer,
          $$WildItemsTableOrderingComposer,
          $$WildItemsTableAnnotationComposer,
          $$WildItemsTableCreateCompanionBuilder,
          $$WildItemsTableUpdateCompanionBuilder,
          (WildItem, $$WildItemsTableReferences),
          WildItem,
          PrefetchHooks Function({bool wordId})
        > {
  $$WildItemsTableTableManager(_$AppDatabase db, $WildItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$WildItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$WildItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$WildItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> wordId = const Value.absent(),
                Value<String> sentence = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<int> savedAt = const Value.absent(),
              }) => WildItemsCompanion(
                id: id,
                wordId: wordId,
                sentence: sentence,
                source: source,
                savedAt: savedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> wordId = const Value.absent(),
                required String sentence,
                Value<String?> source = const Value.absent(),
                required int savedAt,
              }) => WildItemsCompanion.insert(
                id: id,
                wordId: wordId,
                sentence: sentence,
                source: source,
                savedAt: savedAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$WildItemsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({wordId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                if (wordId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.wordId,
                            referencedTable: $$WildItemsTableReferences
                                ._wordIdTable(db),
                            referencedColumn:
                                $$WildItemsTableReferences._wordIdTable(db).id,
                          )
                          as T;
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

typedef $$WildItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WildItemsTable,
      WildItem,
      $$WildItemsTableFilterComposer,
      $$WildItemsTableOrderingComposer,
      $$WildItemsTableAnnotationComposer,
      $$WildItemsTableCreateCompanionBuilder,
      $$WildItemsTableUpdateCompanionBuilder,
      (WildItem, $$WildItemsTableReferences),
      WildItem,
      PrefetchHooks Function({bool wordId})
    >;
typedef $$SkillLevelsTableCreateCompanionBuilder =
    SkillLevelsCompanion Function({
      Value<int> id,
      required String skill,
      required String cefrEstimate,
      required double score,
      required int measuredAt,
      Value<String?> source,
    });
typedef $$SkillLevelsTableUpdateCompanionBuilder =
    SkillLevelsCompanion Function({
      Value<int> id,
      Value<String> skill,
      Value<String> cefrEstimate,
      Value<double> score,
      Value<int> measuredAt,
      Value<String?> source,
    });

class $$SkillLevelsTableFilterComposer
    extends Composer<_$AppDatabase, $SkillLevelsTable> {
  $$SkillLevelsTableFilterComposer({
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

  ColumnFilters<String> get skill => $composableBuilder(
    column: $table.skill,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cefrEstimate => $composableBuilder(
    column: $table.cefrEstimate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get measuredAt => $composableBuilder(
    column: $table.measuredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SkillLevelsTableOrderingComposer
    extends Composer<_$AppDatabase, $SkillLevelsTable> {
  $$SkillLevelsTableOrderingComposer({
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

  ColumnOrderings<String> get skill => $composableBuilder(
    column: $table.skill,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cefrEstimate => $composableBuilder(
    column: $table.cefrEstimate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get measuredAt => $composableBuilder(
    column: $table.measuredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SkillLevelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SkillLevelsTable> {
  $$SkillLevelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get skill =>
      $composableBuilder(column: $table.skill, builder: (column) => column);

  GeneratedColumn<String> get cefrEstimate => $composableBuilder(
    column: $table.cefrEstimate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<int> get measuredAt => $composableBuilder(
    column: $table.measuredAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);
}

class $$SkillLevelsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SkillLevelsTable,
          SkillLevel,
          $$SkillLevelsTableFilterComposer,
          $$SkillLevelsTableOrderingComposer,
          $$SkillLevelsTableAnnotationComposer,
          $$SkillLevelsTableCreateCompanionBuilder,
          $$SkillLevelsTableUpdateCompanionBuilder,
          (
            SkillLevel,
            BaseReferences<_$AppDatabase, $SkillLevelsTable, SkillLevel>,
          ),
          SkillLevel,
          PrefetchHooks Function()
        > {
  $$SkillLevelsTableTableManager(_$AppDatabase db, $SkillLevelsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$SkillLevelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$SkillLevelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$SkillLevelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> skill = const Value.absent(),
                Value<String> cefrEstimate = const Value.absent(),
                Value<double> score = const Value.absent(),
                Value<int> measuredAt = const Value.absent(),
                Value<String?> source = const Value.absent(),
              }) => SkillLevelsCompanion(
                id: id,
                skill: skill,
                cefrEstimate: cefrEstimate,
                score: score,
                measuredAt: measuredAt,
                source: source,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String skill,
                required String cefrEstimate,
                required double score,
                required int measuredAt,
                Value<String?> source = const Value.absent(),
              }) => SkillLevelsCompanion.insert(
                id: id,
                skill: skill,
                cefrEstimate: cefrEstimate,
                score: score,
                measuredAt: measuredAt,
                source: source,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SkillLevelsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SkillLevelsTable,
      SkillLevel,
      $$SkillLevelsTableFilterComposer,
      $$SkillLevelsTableOrderingComposer,
      $$SkillLevelsTableAnnotationComposer,
      $$SkillLevelsTableCreateCompanionBuilder,
      $$SkillLevelsTableUpdateCompanionBuilder,
      (
        SkillLevel,
        BaseReferences<_$AppDatabase, $SkillLevelsTable, SkillLevel>,
      ),
      SkillLevel,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WordsTableTableManager get words =>
      $$WordsTableTableManager(_db, _db.words);
  $$ExamplesTableTableManager get examples =>
      $$ExamplesTableTableManager(_db, _db.examples);
  $$WordFamiliesTableTableManager get wordFamilies =>
      $$WordFamiliesTableTableManager(_db, _db.wordFamilies);
  $$CollocationsTableTableManager get collocations =>
      $$CollocationsTableTableManager(_db, _db.collocations);
  $$SrsCardsTableTableManager get srsCards =>
      $$SrsCardsTableTableManager(_db, _db.srsCards);
  $$ReviewLogsTableTableManager get reviewLogs =>
      $$ReviewLogsTableTableManager(_db, _db.reviewLogs);
  $$SentenceStructuresTableTableManager get sentenceStructures =>
      $$SentenceStructuresTableTableManager(_db, _db.sentenceStructures);
  $$ParagraphsTableTableManager get paragraphs =>
      $$ParagraphsTableTableManager(_db, _db.paragraphs);
  $$ChunkSentencesTableTableManager get chunkSentences =>
      $$ChunkSentencesTableTableManager(_db, _db.chunkSentences);
  $$PassagesTableTableManager get passages =>
      $$PassagesTableTableManager(_db, _db.passages);
  $$QuestionsTableTableManager get questions =>
      $$QuestionsTableTableManager(_db, _db.questions);
  $$UserTextsTableTableManager get userTexts =>
      $$UserTextsTableTableManager(_db, _db.userTexts);
  $$RecordingsTableTableManager get recordings =>
      $$RecordingsTableTableManager(_db, _db.recordings);
  $$DailyStatsTableTableManager get dailyStats =>
      $$DailyStatsTableTableManager(_db, _db.dailyStats);
  $$StreaksTableTableManager get streaks =>
      $$StreaksTableTableManager(_db, _db.streaks);
  $$AchievementsTableTableManager get achievements =>
      $$AchievementsTableTableManager(_db, _db.achievements);
  $$GameSessionsTableTableManager get gameSessions =>
      $$GameSessionsTableTableManager(_db, _db.gameSessions);
  $$PersonalBestsTableTableManager get personalBests =>
      $$PersonalBestsTableTableManager(_db, _db.personalBests);
  $$WildItemsTableTableManager get wildItems =>
      $$WildItemsTableTableManager(_db, _db.wildItems);
  $$SkillLevelsTableTableManager get skillLevels =>
      $$SkillLevelsTableTableManager(_db, _db.skillLevels);
}
