import 'dart:typed_data';

import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:helpncare/perfil/bloc/perfil_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../components/configuracion.dart';
import '../../components/dialog.dart';
import '../../components/log.dart';
import '../../utils/camera.dart';

typedef CallBackBytes = void Function(Uint8List);

class ContenidoImagen extends StatelessWidget {
  ContenidoImagen(
      {Key? key, this.idImagen, this.imagen, required this.cambiada})
      : super(key: key);

  final String? idImagen;
  final Uint8List? imagen;
  final CallBackBytes cambiada;

  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: GestureDetector(
          onTap: () async {
            await _pickImage(context);
          },
          child: _imageContenido(context),
        ),
      ),
    );
  }

  Widget _imageContenido(BuildContext context) {
    Log.registra(
        '${Environment().config!.baseUrlServicios}/data/imagen?id=$idImagen');
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: idImagen != null && idImagen!.isNotEmpty
          ? Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: NetworkImage(
                    '${Environment().config!.baseUrlServicios}/data/imagen?id=$idImagen',
                  ),
                ),
              ),
            )
          : imagen != null
              ? Center(
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: Image.memory(imagen!).image,
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      border: Border.all(color: Colors.grey, width: 2),
                    ),
                    width: 300,
                    height: 75,
                    child: const Center(
                      child: Text('Pulse aquí para seleccionar la imagen'),
                    ),
                  ),
                ),
    );
  }

  // Future<void> _pickImage(BuildContext context) async {
  //   final pickedFile = await _picker.pickImage(
  //     source: ImageSource.camera,
  //     maxWidth: 800,
  //     maxHeight: 800,
  //     imageQuality: null,
  //   );
  //   if (pickedFile != null) {
  //     final Uint8List img = await pickedFile.readAsBytes();
  //     cambiada(img);
  //     //context.read<PerfilBloc>().add(PerfilImageSelectedEvent(image: img));
  //   }
  // }

  Future<void> _seleccionaImagen(
      BuildContext context, ImageSource origen) async {
    final pickedFile = await _picker.pickImage(
      source: origen,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: null,
    );
    if (pickedFile != null) {
      final Uint8List img = await pickedFile.readAsBytes();
      cambiada(img);
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
