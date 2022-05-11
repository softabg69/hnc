import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hnc/perfil/bloc/perfil_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../bloc/session/session_bloc.dart';
import '../../components/configuracion.dart';

class PerfilAvatar extends StatelessWidget {
  PerfilAvatar({Key? key}) : super(key: key);

  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: BlocBuilder<SessionBloc, SessionState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: GestureDetector(
                onTap: () async {
                  await _pickImage(context);
                },
                child: _imageAvatar()),
          );
        },
      ),
    );
  }

  Widget _imageAvatar() {
    return BlocBuilder<PerfilBloc, PerfilState>(
      builder: ((context, state) => state.origenAvatar == OrigenImagen.network
          ? Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: NetworkImage(
                    "${Environment().config!.baseUrlServicios}/data/avatarusuario?id=${state.avatar}",
                  ),
                ),
              ),
            )
          : Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.scaleDown,
                  image: Image.memory(state.bytesImg!).image,
                ),
              ),
            )),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 80,
      maxHeight: 80,
      imageQuality: null,
    );
    if (pickedFile != null) {
      final Uint8List img = await pickedFile.readAsBytes();
      context.read<PerfilBloc>().add(PerfilImageSelectedEvent(image: img));
    }
  }
}
