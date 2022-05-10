class Categoria {
  final int id;
  final String descripcion;
  final String avatar;
  final bool seleccionada;

  Categoria(
      {required this.id,
      required this.descripcion,
      required this.avatar,
      required this.seleccionada});

  Categoria.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        descripcion = json['descripcion'],
        avatar = json['avatar'],
        seleccionada = json['seleccionada'];

  Categoria copyWith(
      {int? id, String? descripcion, String? avatar, bool? seleccionada}) {
    return Categoria(
        id: id ?? this.id,
        descripcion: descripcion ?? this.descripcion,
        avatar: avatar ?? this.avatar,
        seleccionada: seleccionada ?? this.seleccionada);
  }

  @override
  String toString() {
    return '$id - $descripcion: $seleccionada';
  }
}
