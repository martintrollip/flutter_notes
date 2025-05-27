# Flutter Notes App

A simple note-taking application built with Flutter. This project makes use of best practices for Flutter architecture, state management, and API integration.

## Description

The Flutter Notes App allows users to create, view, and delete notes. Each note consists of a title and a description. The application is designed with a focus on a maintainable and scalable architecture.

## Features

The application implements the following core functionalities across a minimal set of screens:

*   **View a list of notes:**
    *   **`NotesListPage`**: Displays all existing notes.
    *   Handles and displays loading, error, and empty states appropriately.

*   **Create a new note:**
    *   Users can navigate from the `NotesListPage` to an `AddEditNotePage`.
    *   **`AddEditNotePage`**: Provides input fields for a note's title and description.
  
*   **Delete a note:**
    *   Functionality to delete notes is available directly from the `NotesListPage`.

## Architecture

![Reso Architecture](/docs/arch_reso.webp)

This project implements **Clean Architecture** principles to ensure a separation of concerns, making the application more testable, maintainable, and scalable. The architecture is divided into three main layers:

1.  **Presentation Layer:**
    *   Responsible for the UI and user interaction.
    *   Uses **BLoC (Business Logic Component)** for state management, handling events from the UI and emitting states to be rendered.
    *   Contains Widgets, Pages (Screens), and BLoCs.
  
2.  **Domain Layer:**
    *   Contains the core business logic and rules of the application.
    *   Includes Entities (business objects, e.g., `Note` entity), Use Cases (application-specific business rules, e.g., `GetAllNotes`, `CreateNote`), and Repository Contracts (abstract interfaces for data operations).
    *   This layer is independent of any framework or infrastructure details.
  
3.  **Data Layer:**
    *   Responsible for data retrieval and storage.
    *   Includes Repository Implementations (concrete implementations of the domain layer's repository contracts), Data Sources (which can be remote like an API or local like a database/mocked data), and Models (data transfer objects that might include serialization logic, e.g., `NoteModel`).
    *   API calls (Fetch all notes, Create/update a note, Delete a note) are mocked in this layer using `Future.delayed` or a similar mechanism.

**Dependency Injection:** `get_it` is used to manage dependencies between layers and components.

## Getting Started

### Prerequisites

To run this project, you need to have the following installed:
-   Flutter SDK 

### Running the App

To run the Flutter Notes App, follow these steps:
1.  Clone the repository:
    ```bash
        git clone
    ```

2.  Navigate to the project directory:
    ```bash
        cd flutter_notes_app
    ```

3.  Install dependencies:
    ```bash
        flutter pub get
    ```

4. Generate the necessary files:
    ```bash
        dart run build_runner build --delete-conflicting-outputs

        OR 

        flutter pub run build_runner build --delete-conflicting-outputs
    ```

5.  Run the application:
    ```bash
        flutter run
    ```

### Testing
To run tests, use the following command:
```bash
    flutter test
```

TODO Prerequisites install Flutter SDK, Dart SDK, and any other dependencies.
TODO Screenshots of the app in action.
TODO Martin errors (server vs no data) and how the data was mocked
TODO Martin add screenshots here
TODO Martin add app icons (also in the readme)
TODO Martin add features list like swipe to refresh, etc.
TODO Martin add recommendations like arb and other features
TODO more well defined exceptions from the remote source and handling 
TODO Martin setup github action and a status badge
TODO Martin snap bar for errors and success messages
TODO Martin remove example package name 

TODO Martin refresh indicator
//TODO Martin
// RefreshIndicator
//  onRefresh: () async {
        //   final bloc = context.read<NotesBloc>();
        //   context.read<NotesBloc>().add(const NotesEvent.refreshNotes());
        //   await bloc.stream.firstWhere(
        //     (state) => state.status == NotesListStatus.loading,
        //   );
        //   await bloc.stream.firstWhere(
        //     (state) => state.status != NotesListStatus.loading,
        //   );
        // },