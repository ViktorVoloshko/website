import 'package:flutter/material.dart';

void main() {
  runApp(
    MainApp(
      viewModel: HomeViewModel(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({
    super.key,
    required this.viewModel,
  });

  final HomeViewModel viewModel;

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  // #docregion addListener
  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }
  // #enddocregion addListener

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // #docregion ListenableBuilder
        body: ListenableBuilder(
          listenable: widget.viewModel.load,
          builder: (context, child) {
            if (widget.viewModel.load.running) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            // #enddocregion ListenableBuilder

            if (widget.viewModel.load.error != null) {
              return Center(
                child: Text('Error: ${widget.viewModel.load.error}'),
              );
            }

            return child!;
          },
          child: ListenableBuilder(
            listenable: widget.viewModel,
            builder: (context, _) {
              if (widget.viewModel.user == null) {
                return const Center(
                  child: Text('No user'),
                );
              }

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Name: ${widget.viewModel.user!.name}'),
                    Text('Email: ${widget.viewModel.user!.email}'),
                  ],
                ),
              );
            },
          ),
          // #docregion ListenableBuilder
        ),
        // #enddocregion ListenableBuilder
      ),
    );
  }

  // #docregion addListener
  void _onViewModelChanged() {
    if (widget.viewModel.load.error != null) {
      // Show Snackbar
    }
  }
  // #enddocregion addListener
}

class User {
  User({required this.name, required this.email});

  final String name;
  final String email;
}

class HomeViewModel extends ChangeNotifier {
  HomeViewModel() {
    load = Command(_load)..execute();
  }

  User? _user;
  User? get user => _user;

  late final Command load;

  Future<void> _load() async {
    // load user
    await Future.delayed(const Duration(seconds: 2));
    _user = User(name: 'John Doe', email: 'john@example.com');
    notifyListeners();
  }
}

// #docregion HomeViewModel2
// #docregion getUser
// #docregion load1
// #docregion UiState1
class HomeViewModel2 extends ChangeNotifier {
  // #enddocregion HomeViewModel2

  User? get user => null;
  // #enddocregion getUser
  // #enddocregion load1

  bool get running => false;

  Exception? get error => null;

  // #docregion load1
  void load() {
    // load user
  }
  // #enddocregion load1

  // #docregion load2
  void load2() {
    if (running) {
      return;
    }

    // load user
  }
  // #enddocregion load2

  // #docregion load1
  // #docregion HomeViewModel2
  // #docregion getUser
}
// #enddocregion HomeViewModel2
// #enddocregion getUser
// #enddocregion load1
// #enddocregion UiState1

// #docregion HomeViewModel3
class HomeViewModel3 extends ChangeNotifier {
  User? get user => null;

  bool get runningLoad => false;

  Exception? get errorLoad => null;

  bool get runningEdit => false;

  Exception? get errorEdit => null;

  void load() {
    // load user
  }

  void edit(String name) {
    // edit user
  }
}
// #enddocregion HomeViewModel3

class Command extends ChangeNotifier {
  Command(this._action);

  bool _running = false;
  bool get running => _running;

  Exception? _error;
  Exception? get error => _error;

  bool _completed = false;
  bool get completed => _completed;

  final Future<void> Function() _action;

  Future<void> execute() async {
    if (_running) {
      return;
    }

    _running = true;
    _completed = false;
    _error = null;
    notifyListeners();

    try {
      await _action();
      _completed = true;
    } on Exception catch (error) {
      _error = error;
    } finally {
      _running = false;
      notifyListeners();
    }
  }

  void clear() {
    _running = false;
    _error = null;
    _completed = false;
  }
}
