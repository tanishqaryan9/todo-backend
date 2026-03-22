# 📱 ToDo App — Flutter Frontend

A clean, Apple-inspired Flutter frontend for the Spring Boot ToDo backend.

---

## 🏗️ Project Architecture

```
lib/
├── main.dart                         # App entry point & providers
├── models/
│   └── task_model.dart               # Task data model + helpers (isOverdue, isDueToday)
├── services/
│   └── task_service.dart             # HTTP API layer (maps to all backend endpoints)
├── providers/
│   └── task_provider.dart            # State management (ChangeNotifier)
├── screens/
│   ├── main_shell.dart               # Bottom nav scaffold + IndexedStack
│   ├── all_tasks/
│   │   └── all_tasks_screen.dart     # All tasks tab with stats
│   ├── completed_tasks/
│   │   └── completed_tasks_screen.dart
│   └── pending_tasks/
│       └── pending_tasks_screen.dart
├── widgets/
│   ├── task_card.dart                # Swipeable task card (edit/delete)
│   ├── task_list_view.dart           # Shared list + delete confirmation
│   ├── add_edit_task_sheet.dart      # Bottom sheet for add/edit
│   └── empty_state.dart             # Empty state with optional Add button
└── theme/
    └── app_theme.dart                # Colors, typography, spacing constants
```

---

## 🚀 Setup

### 1. Install dependencies

```bash
flutter pub get
```

### 2. Configure Backend URL

Open `lib/services/task_service.dart` and update the base URL:

```dart
static const String baseUrl = 'http://localhost:8080';
// For Android emulator:  'http://10.0.2.2:8080'
// For iOS simulator:     'http://localhost:8080'
// For physical device:   'http://<your-machine-ip>:8080'
```

### 3. Run

```bash
flutter run
```

---

## ✨ Features

| Feature | Details |
|---|---|
| **Bottom Navigation** | All Tasks · Pending · Completed — with live badge counts |
| **Empty State** | Main screen shows a prominent "Add a Task" button when no tasks exist |
| **Sort by Due Date** | Toggle button in every tab's app bar |
| **Swipe to Edit/Delete** | Swipe left on any task card |
| **Tap to Complete** | Tap the circle or the card to toggle completion |
| **Add/Edit Sheet** | Full bottom sheet with task name, notes, and date picker |
| **Overdue Indicators** | Red label + icon for overdue tasks, orange for today |
| **Stats Bar** | All Tasks tab shows Total / Done / Pending chips |
| **Error Handling** | Snackbar errors from API responses |

---

## 📦 Dependencies

| Package | Purpose |
|---|---|
| `provider` | State management |
| `http` | REST API calls |
| `google_fonts` | SF Pro Display/Text fonts |
| `flutter_slidable` | Swipe-to-action on task cards |
| `intl` | Date formatting |

---

## 🔌 Backend API Mapping

| Flutter Action | HTTP Call |
|---|---|
| Load all tasks | `GET /tasks` |
| Sort by due date | Client-side sort (toggle in provider) |
| Add task | `POST /` |
| Edit task (full) | `PUT /{task}` |
| Toggle complete | `PATCH /{task}` with `{isCompleted: bool}` |
| Delete by ID | `DELETE /{id}` |

> **Note:** The backend's `getByStatus` endpoint returns a single `TaskDto` instead of a `List<TaskDto>`. The service handles both gracefully. The completed/pending filtering is done client-side from the full task list for a snappier experience.
