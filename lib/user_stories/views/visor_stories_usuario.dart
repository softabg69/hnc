import 'package:flutter/material.dart';
import 'package:hnc/user_stories/views/stories_usuario.dart';

import '../../components/log.dart';

class VisorStoriesUsuario extends StatefulWidget {
  const VisorStoriesUsuario({Key? key}) : super(key: key);

  @override
  State<VisorStoriesUsuario> createState() => _VisorStoriesUsuarioState();
}

class _VisorStoriesUsuarioState extends State<VisorStoriesUsuario> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      Log.registra('alcanzado final contenidos');
      //widget.contenidoBloc.add(ContenidoCargarEvent());
    }
  }

  bool get _isBottom {
    //Log.registra('isBottom');
    if (!_scrollController.hasClients) return false;
    //Log.registra('isBottom 2');
    final maxScroll = _scrollController.position.maxScrollExtent;
    //Log.registra('maxScroll: $maxScroll');
    final currentScroll = _scrollController.offset;
    //Log.registra('currentScroll: $currentScroll');
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: const [
          StoriesUsuario(),
        ],
      ),
    );
  }
}
