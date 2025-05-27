// ignore_for_file: unused_import

import 'package:flutter_notes/features/notes/domain/domain.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([GetNotes, DeleteNote, CreateNote, UpdateNote])
import 'notes_usecases.mocks.dart';
