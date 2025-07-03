# Flutter Posts App

A Flutter application that displays posts from JSONPlaceholder API with search functionality.

## Current Implementation

### Features
- Fetch and display posts from JSONPlaceholder API
- Search posts by title or body content
- Edit posts via bottom sheet
- Pull-to-refresh functionality
- Basic error handling

### Architecture
- **State Management**: Provider
- **Network Layer**: Direct HTTP calls in provider
- **UI Components**:
    - Landing screen with posts list
    - Search functionality
    - Edit post bottom sheet

### Key Files
- `lib/ui/home/landing_screen.dart` - Main screen with posts list
- `lib/providers/home_provider.dart` - Business logic and state management
- `lib/models/post.dart` - Post data model

## Clean Architecture Migration Plan

### Target Architecture

lib/
├── core/
│ ├── error/ # Failure handling
│ ├── network/ # Dio client setup
│ └── usecases/ # Base use case
├── features/
│ └── posts/
│ ├── data/ # Data layer
│ ├── domain/ # Business logic
│ └── presentation/ # UI layer
test/ # Unit and widget tests


### Phase 1: Data Layer Implementation
1. **Data Sources**
    - [ ] Implement `PostRemoteDataSource` with Dio
    - [ ] Add local data source (Hive/SQLite) for caching
2. **Models**
    - [ ] Create `PostModel` with JSON serialization
3. **Repositories**
    - [ ] Implement `PostRepository` contract
    - [ ] Create `PostRepositoryImpl`

### Phase 2: Domain Layer
1. **Entities**
    - [ ] Create `Post` entity
2. **Repositories**
    - [ ] Define abstract `PostRepository`
3. **Use Cases**
    - [ ] `GetPosts` - Fetch all posts
    - [ ] `SearchPosts` - Search posts
    - [ ] `UpdatePost` - Edit post

### Phase 3: Presentation Layer
1. **State Management**
    - [ ] Migrate from Provider to Bloc/Cubit
    - [ ] Implement `PostBloc` with states:
        - `PostInitial`
        - `PostLoading`
        - `PostLoaded`
        - `PostError`
2. **UI Components**
    - [ ] Refactor screens to use Bloc
    - [ ] Create reusable widgets

### Phase 4: Testing
1. **Unit Tests**
    - [ ] Data sources
    - [ ] Repositories
    - [ ] Use cases
    - [ ] Bloc
2. **Widget Tests**
    - [ ] Main screen
    - [ ] Search functionality
    - [ ] Edit post flow

### Phase 5: Additional Features
1. **Pagination**
    - [ ] Implement pagination with lazy loading
2. **Offline Support**
    - [ ] Cache posts locally
    - [ ] Add offline-first functionality
3. **Authentication**
    - [ ] Add login flow
    - [ ] Secure API calls

## Getting Started

### Prerequisites
- Flutter SDK
- Dart 2.17+
- IDE (VSCode/Android Studio)

### Installation
1. Clone the repository
2. Install dependencies:
```bash
flutter pub get