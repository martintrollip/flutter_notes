import 'package:flutter_notes/features/notes/data/datasources/datasources.dart';
import 'package:flutter_notes/features/notes/data/repositories/notes_repository.dart';
import 'package:flutter_notes/features/notes/domain/repositories/notes_repository.dart';
import 'package:flutter_notes/features/notes/domain/usecases/usecases.dart';
import 'package:flutter_notes/features/notes/presentation/bloc/notes_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl
    // Blocs
    ..registerFactory(
      () => NotesBloc(getNotes: sl<GetNotes>(), deleteNote: sl<DeleteNote>()),
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
