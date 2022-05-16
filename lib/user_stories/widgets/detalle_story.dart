import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:hnc/contenido/bloc/contenido_bloc.dart';
//import 'package:hnc/contenido/widgets/un_contenido.dart';
import 'package:hnc/user_stories/bloc/user_stories_bloc.dart';
import 'package:hnc/user_stories/widgets/una_story.dart';

class DetalleStory extends StatelessWidget {
  const DetalleStory({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<UserStoriesBloc>(),
      child: BlocBuilder<UserStoriesBloc, UserStoriesState>(
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text(
              context.read<UserStoriesBloc>().state.stories[index].titulo,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          backgroundColor: Colors.grey,
          body: SingleChildScrollView(
            child: UnaStory(index: index, esDetalle: true),
          ),
        ),
      ),
    );
  }
}
