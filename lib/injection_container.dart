import 'package:flutter_notes/features/notes/data/data.dart';
import 'package:flutter_notes/features/notes/domain/entities/note.dart';
import 'package:flutter_notes/features/notes/domain/repositories/notes_repository.dart';
import 'package:flutter_notes/features/notes/domain/usecases/usecases.dart';
import 'package:flutter_notes/features/notes/presentation/bloc/add_edit_note_bloc.dart';
import 'package:flutter_notes/features/notes/presentation/bloc/notes_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl
    // Blocs
    ..registerFactory(
      () => NotesBloc(getNotes: sl<GetNotes>(), deleteNote: sl<DeleteNote>()),
    )
    ..registerFactoryParam<AddEditNoteBloc, Note?, void>(
      (initialNote, _) => AddEditNoteBloc(
        createNote: sl<CreateNote>(),
        updateNote: sl<UpdateNote>(),
        initialNote: initialNote,
      ),
    )
    // Use cases
    ..registerLazySingleton(() => GetNotes(sl<NotesRepository>()))
    ..registerLazySingleton(() => CreateNote(sl<NotesRepository>()))
    ..registerLazySingleton(() => UpdateNote(sl<NotesRepository>()))
    ..registerLazySingleton(() => DeleteNote(sl<NotesRepository>()))
    // Repositories
    ..registerLazySingleton<NotesRepository>(
      () => NotesRepositoryImplementation(
        remoteDatasource: sl<RemoteDatasource>(),
      ),
    )
    // Data sources
    ..registerLazySingleton<RemoteDatasource>(RemoteDatasourceImpl.new);
}
