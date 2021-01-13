import 'package:example/bloc/movies_bloc.dart';
import 'package:example/interactor/state/interactor_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:microkit/microkit.dart';

class Homescreen extends StatelessWidget {
  var imageURL = 'http://image.tmdb.org/t/p/w500';
  var noImage =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHL78BFzD4eW6FOjaZsUuKfQYZljcexyonUA&usqp=CAU';
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoviesBloc, MoviesState>(
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: ProgressButton(
            onPressed: () {
              context.read<MoviesBloc>().add(const MoviesEvent.refetchMovies());
            },
            colorState: {
              ButtonStates.loading: Colors.grey,
              ButtonStates.succeed: Colors.green,
              ButtonStates.failed: Colors.red,
              ButtonStates.standby: Colors.blue,
            },
            widgetState: {
              ButtonStates.loading: Text(''),
              ButtonStates.succeed: Text('Succeed'),
              ButtonStates.failed: Text('Failed'),
              ButtonStates.standby: Text('Refetch'),
            },
            state: state.buttonState,
          ),
          body: ListView(
            children: [
              () {
                if (state.state == InteractorState.loading()) {
                  return Shimmer.listTile(itemCount: 10);
                } else if (state.state == InteractorState.error()) {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: Image.asset('assets/error.png'),
                    ),
                  );
                } else if (state.state == InteractorState.networkError()) {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: Image.asset('assets/no_connection.png'),
                    ),
                  );
                } else {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: state.movieResult.results.length,
                      itemBuilder: (context, index) {
                        var data = state.movieResult.results[index];

                        return ExpandableMenu(
                          title: {
                            MenuState.collapse:
                                _title(data, MenuState.collapse),
                            MenuState.expand: _title(data, MenuState.expand),
                          },
                          backroundTitleColor: {
                            MenuState.expand: Colors.blue[200],
                            MenuState.collapse: Colors.transparent,
                          },
                          collapsable: Container(
                            color: Colors.lightBlue[100],
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(data.overview),
                            ),
                          ),
                        );
                      });
                }
              }(),
            ],
          ),
        );
      },
    );
  }

  Widget _title(var data, MenuState menuState) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(
          data.posterPath != null
              ? '$imageURL' + '${data.posterPath}'
              : noImage,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.title,
            style: TextStyle(
              fontWeight: menuState == MenuState.expand
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.originalTitle,
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 3),
          Text(
            data.releaseDate,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
