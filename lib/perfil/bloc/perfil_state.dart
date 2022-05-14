part of 'perfil_bloc.dart';

class PerfilState extends Equatable {
  const PerfilState(
      {this.email = '',
      this.avatar = '',
      this.origenAvatar = OrigenImagen.network,
      this.categorias = const [],
      this.estado = EstadoPerfil.inicial,
      this.bytesImg,
      this.index = 0});

  final String email;
  final String avatar;
  final OrigenImagen origenAvatar;
  final List<Categoria> categorias;
  final EstadoPerfil estado;
  final Uint8List? bytesImg;
  final int index;

  List<int> selecciondas() {
    final List<int> res = [];
    for (var cat in categorias) {
      if (cat.seleccionada) res.add(cat.id);
    }
    return res;
  }

  List<Categoria> get categoriasSelecciondas {
    final List<Categoria> res = [];
    for (var cat in categorias) {
      if (cat.seleccionada) res.add(cat);
    }
    Log.registra('categorias seleccionadas: $res');
    return res;
  }

  @override
  List<Object> get props => [email, avatar, origenAvatar, categorias, estado];

  PerfilState copyWith(
      {String? email,
      String? avatar,
      OrigenImagen? origenAvatar,
      List<Categoria>? categorias,
      EstadoPerfil? estado,
      Uint8List? bytesImg}) {
    return PerfilState(
        email: email ?? this.email,
        avatar: avatar ?? this.avatar,
        origenAvatar: origenAvatar ?? this.origenAvatar,
        categorias: categorias ?? this.categorias,
        estado: estado ?? this.estado,
        bytesImg: bytesImg ?? this.bytesImg,
        index: index + 1);
  }

  @override
  String toString() {
    return 'PerfilState: $index -> $categorias';
  }
}
