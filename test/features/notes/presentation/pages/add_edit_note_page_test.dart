// ignore_for_file: avoid_redundant_argument_values

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes/features/notes/domain/entities/note.dart';
import 'package:flutter_notes/features/notes/presentation/bloc/add_edit_note_bloc.dart';
import 'package:flutter_notes/features/notes/presentation/pages/add_edit_note_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/constants.dart';

class MockAddEditNoteBloc extends MockBloc<AddEditNoteEvent, AddEditNoteState>
    implements AddEditNoteBloc {}

void main() {
  late MockAddEditNoteBloc mockAddEditNoteBloc;

  setUp(() {
    mockAddEditNoteBloc = MockAddEditNoteBloc();
  });

  Widget createWidgetUnderTest({Note? note}) {
    return MaterialApp(
      home: BlocProvider<AddEditNoteBloc>.value(
        value: mockAddEditNoteBloc,
        child: const AddEditNoteView(),
      ),
    );
  }

  group('AddEditNotePage', () {
    testWidgets('renders "Add Note" AppBar title when not editing', (
      tester,
    ) async {
      when(
        () => mockAddEditNoteBloc.state,
      ).thenReturn(const AddEditNoteState());
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('Add Note'), findsOneWidget);
    });

    testWidgets('renders "Edit Note" AppBar title when editing', (
      tester,
    ) async {
      when(() => mockAddEditNoteBloc.state).thenReturn(
        AddEditNoteState(
          initialNote: tNote,
          title: tNote.title,
          description: tNote.content,
        ),
      );
      await tester.pumpWidget(createWidgetUnderTest(note: tNote));
      expect(find.text('Edit Note'), findsOneWidget);
    });

    testWidgets('shows loader when status is saving', (tester) async {
      when(
        () => mockAddEditNoteBloc.state,
      ).thenReturn(const AddEditNoteState(status: AddEditNoteStatus.saving));
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Save button is enabled when form is valid and not saving', (
      tester,
    ) async {
      when(() => mockAddEditNoteBloc.state).thenReturn(
        const AddEditNoteState(
          isFormValid: true,
          status: AddEditNoteStatus.initial,
        ),
      );
      await tester.pumpWidget(createWidgetUnderTest());
      final saveButton = find.widgetWithIcon(IconButton, Icons.save_outlined);
      expect(tester.widget<IconButton>(saveButton).onPressed, isNotNull);
    });

    testWidgets('Save button is disabled when form is invalid', (tester) async {
      when(() => mockAddEditNoteBloc.state).thenReturn(
        const AddEditNoteState(
          isFormValid: false,
          status: AddEditNoteStatus.initial,
        ),
      );
      await tester.pumpWidget(createWidgetUnderTest());
      final saveButton = find.widgetWithIcon(IconButton, Icons.save_outlined);
      expect(tester.widget<IconButton>(saveButton).onPressed, isNull);
    });

    testWidgets('Save button is disabled when saving', (tester) async {
      when(() => mockAddEditNoteBloc.state).thenReturn(
        const AddEditNoteState(
          isFormValid: true,
          status: AddEditNoteStatus.saving,
        ),
      );
      await tester.pumpWidget(createWidgetUnderTest());
      // When saving, the button is replaced by a loader
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(
        find.widgetWithIcon(IconButton, Icons.save_outlined),
        findsNothing,
      );
    });

    testWidgets('populates form fields when initialNote is provided', (
      tester,
    ) async {
      when(() => mockAddEditNoteBloc.state).thenReturn(
        AddEditNoteState(
          initialNote: tNote,
          title: tNote.title,
          description: tNote.content,
        ),
      );
      await tester.pumpWidget(createWidgetUnderTest(note: tNote));
      expect(find.text(tNote.title), findsOneWidget);
      expect(find.text(tNote.content), findsOneWidget);
    });

    testWidgets('dispatches TitleChanged event when title field is changed', (
      tester,
    ) async {
      when(
        () => mockAddEditNoteBloc.state,
      ).thenReturn(const AddEditNoteState());
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.enterText(find.byType(TextFormField).first, 'New Title');
      verify(
        () => mockAddEditNoteBloc.add(
          const AddEditNoteEvent.titleChanged('New Title'),
        ),
      ).called(1);
    });

    testWidgets(
      'dispatches DescriptionChanged event when description field is changed',
      (tester) async {
        when(
          () => mockAddEditNoteBloc.state,
        ).thenReturn(const AddEditNoteState());
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.enterText(
          find.byType(TextFormField).last,
          'New Description',
        );
        verify(
          () => mockAddEditNoteBloc.add(
            const AddEditNoteEvent.descriptionChanged('New Description'),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'dispatches SaveNotePressed event when save button is pressed',
      (tester) async {
        when(() => mockAddEditNoteBloc.state).thenReturn(
          const AddEditNoteState(
            isFormValid: true,
            status: AddEditNoteStatus.initial,
          ),
        );
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.tap(find.widgetWithIcon(IconButton, Icons.save_outlined));
        verify(
          () => mockAddEditNoteBloc.add(const AddEditNoteEvent.save()),
        ).called(1);
      },
    );

    testWidgets('shows success SnackBar and pops when status is success', (
      tester,
    ) async {
      final navigator = GlobalKey<NavigatorState>();
      whenListen(
        mockAddEditNoteBloc,
        Stream.fromIterable([
          const AddEditNoteState(status: AddEditNoteStatus.initial),
          const AddEditNoteState(status: AddEditNoteStatus.success),
        ]),
        initialState: const AddEditNoteState(),
      );

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigator,
          home: BlocProvider<AddEditNoteBloc>.value(
            value: mockAddEditNoteBloc,
            child: const AddEditNotePage(),
          ),
        ),
      );

      // Wait for the listener to process the state change and show SnackBar
      await tester.pumpAndSettle();

      expect(find.text('Note saved successfully!'), findsOneWidget);
    }, skip: true);

    testWidgets('shows error SnackBar when status is error', (tester) async {
      whenListen(
        mockAddEditNoteBloc,
        Stream.fromIterable([
          const AddEditNoteState(status: AddEditNoteStatus.initial),
          const AddEditNoteState(
            status: AddEditNoteStatus.error,
            errorMessage: 'Test Error',
          ),
        ]),
        initialState: const AddEditNoteState(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Test Error'), findsOneWidget);
    }, skip: true);
  });
}
