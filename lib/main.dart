import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes/features/notes/presentation/bloc/notes_bloc.dart';
import 'package:flutter_notes/features/notes/presentation/pages/notes_list_page.dart';
import 'package:flutter_notes/injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const FlutterNotes());
}

class FlutterNotes extends StatelessWidget {
  const FlutterNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => di.sl<NotesBloc>()..add(const NotesEvent.getAllNotes()),
        child: const NotesListPage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
