import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpncare/perfil/bloc/perfil_bloc.dart';
import 'package:helpncare/utils/camera.dart';
import 'package:image_picker/image_picker.dart';

import '../../bloc/session/session_bloc.dart';
import '../../components/configuracion.dart';

import '../../components/dialog.dart';
import '../../components/log.dart';
import '../../enumerados.dart';

class PerfilAvatar extends StatelessWidget {
  PerfilAvatar({Key? key}) : super(key: key);

  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: BlocBuilder<SessionBloc, SessionState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: GestureDetector(
                onTap: () async {
                  await _pickImage(context);
                },
                child: _imageAvatar(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _imageAvatar() {
    return BlocBuilder<PerfilBloc, PerfilState>(
      builder: ((context, state) => MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Stack(
              children: [
                Container(
                  width: 120.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: state.origenAvatar == OrigenImagen.network
                            ? BoxFit.contain
                            : BoxFit.scaleDown,
                        image: state.origenAvatar == OrigenImagen.network
                            ? NetworkImage(
                                "${Environment().config!.baseUrlServicios}/data/avatarusuario?id=${state.avatar}",
                              )
                            : Image.memory(state.bytesImg!).image),
                  ),
                ),
                Positioned(
                  child: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.primary,
                    size: 40,
                  ),
                  right: -5,
                  bottom: -5,
                ),
              ],
            ),
          )),
    );
  }

  Future<void> _seleccionaImagen(
      BuildContext context, ImageSource origen) async {
    final pickedFile = await _picker.pickImage(
      source: origen,
      maxWidth: 80,
      maxHeight: 80,
      imageQuality: null,
    );
    if (pickedFile != null) {
      final Uint8List img = await pickedFile.readAsBytes();
      context.read<PerfilBloc>().add(PerfilImageSelectedEvent(image: img));
    }
  }

  Future<void> _pickImage(BuildContext context) async {
    if (await Camera.hayCamaras()) {
      try {
        final origen = await Dialogs.selectorCamaraGaleria(context);
        await _seleccionaImagen(context, origen);
      } catch (e) {}
    } else {
      await _seleccionaImagen(context, ImageSource.gallery);
    }
  }
}
