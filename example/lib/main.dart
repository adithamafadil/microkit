import 'package:example/bloc/movies_bloc.dart';
import 'package:example/di/inject.dart';
import 'package:example/screen/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  await configureDependencies();
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          inject<MoviesBloc>()..add(const MoviesEvent.loadMovies()),
      lazy: false,
      child: MaterialApp(home: Homescreen()),
    );
  }
}

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(Cubit cubit) {
    super.onCreate(cubit);
    print(cubit.runtimeType);
  }

  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print('Bloc: ${bloc.runtimeType} and Event: $event');
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stacktrace) {
    super.onError(cubit, error, stacktrace);
    print('Bloc: ${cubit.runtimeType}, Error: $error, $stacktrace');
  }

  @override
  void onClose(Cubit cubit) {
    super.onClose(cubit);
    print('Bloc ${cubit.runtimeType} Closed');
  }
}
