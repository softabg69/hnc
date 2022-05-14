import 'package:flutter/material.dart';

class UsuarioStory {
  final String idUsuario;
  final String usuario;
  final String avatar;
  Image? imagen;

  UsuarioStory({this.idUsuario = '', this.usuario = '', this.avatar = ''});

  UsuarioStory.fromMap(Map map)
      : idUsuario = map['idUsuario'],
        usuario = map['usuario'],
        avatar = map['avatar'];

  factory UsuarioStory.fromJson(Map<String, dynamic> json) => UsuarioStory(
      idUsuario: json['diUsuario'] ?? '',
      usuario: json['usuario'] ?? '',
      avatar: json['avatar'] ?? '');
}
