import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hnc/stories/bloc/stories_bloc.dart';
import 'package:hnc/stories/widgets/story.dart';

class Stories extends StatelessWidget {
  const Stories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoriesBloc, StoriesState>(
      builder: ((context, state) {
        final storiesState = state is StoriesCargadas ? state : null;
        return Card(
          color: Colors.white,
          child: SizedBox(
            height: 95,
            child: storiesState == null
                ? const CircularProgressIndicator()
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: ((context, index) {
                      return Story(
                        story: storiesState.usuariosStories[index],
                      );
                    }),
                    itemCount: storiesState.usuariosStories.length,
                  ),
          ),
        );
      }),
    );
  }
}
