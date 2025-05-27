import 'package:flutter_notes/core/errors/failures.dart' show Failure;
import 'package:flutter_notes/features/notes/domain/domain.dart';
import 'package:uuid/uuid.dart' show Uuid;

const tUuid = Uuid();
final tId = tUuid.v4();

final tNow = DateTime.now();
const tTitle = 'New Note Title';
const tContent = 'New Note Content';
final tDateTime = DateTime.now();
final tNote = Note(
  id: '1',
  title: 'Test Note',
  content: 'Test Content',
  createdAt: tDateTime,
  updatedAt: tDateTime,
);
final tNotesList = [tNote];
const tFailureServer = Failure.serverFailure(message: 'Server Error');
const tFailureCache = Failure.cacheFailure(message: 'Cache Error');
const tFailureGeneral = Failure.generalFailure(message: 'General Error');

Note createTestNote1() => Note(
  id: tUuid.v4(),
  title: 'Test Note 1',
  content: 'Content 1',
  createdAt: tNow,
  updatedAt: tNow,
);

Note createTestNote2() => Note(
  id: tUuid.v4(),
  title: 'Test Note 2',
  content: 'Content 2',
  createdAt: tNow.subtract(const Duration(days: 1)),
  updatedAt: tNow.subtract(const Duration(days: 1)),
);
