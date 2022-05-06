class Contenido {
  final String idContenido;
  final String titulo;
  final String cuerpo;
  final String avatar;
  final String creador;
  final String fecha;
  final String cuando;
  final String multimedia;
  final String url;
  final List<int> idscategorias;
  final String categorias;
  final bool gusta;
  final int modo;
  final bool propietario;

  Contenido(
      {this.idContenido = '',
      this.titulo = '',
      this.cuerpo = '',
      this.avatar = '',
      this.creador = '',
      this.fecha = '',
      this.cuando = '',
      this.multimedia = '',
      this.url = '',
      this.idscategorias = const [],
      this.categorias = '',
      this.gusta = false,
      this.modo = 1,
      this.propietario = false});

  Contenido.fromMap(Map map)
      : idContenido = map['idContenido'] ?? '',
        titulo = map['titulo'] ?? '',
        cuerpo = map['cuerpo'] ?? '',
        avatar = map['avatar'] ?? '',
        creador = map['creador'] ?? '',
        fecha = map['fecha'] ?? '',
        cuando = map['cuando'] ?? '',
        multimedia = map['multimedia'] ?? '',
        url = map['url'] ?? '',
        idscategorias = (map['idscategorias']).cast<int>(),
        categorias = map['categorias'] ?? '',
        gusta = map['gusta'] ?? false,
        modo = map['modo'] ?? 1,
        propietario = map['propietario'];

  factory Contenido.fromJson(Map<String, dynamic> json) =>
      _$ContenidoFromJson(json);

  static Contenido _$ContenidoFromJson(Map<String, dynamic> json) => Contenido(
      idContenido: json['idContenido'] ?? '',
      titulo: json['titulo'] ?? '',
      cuerpo: json['cuerpo'] ?? '',
      multimedia: json['multimedia'] ?? '',
      url: json['url'] ?? '',
      avatar: json['avatar'] ?? '',
      creador: json['creador'] ?? '',
      fecha: json['fecha'] ?? '',
      cuando: json['cuando'] ?? '',
      idscategorias: (json['idscategorias']).cast<int>(),
      categorias: json['categorias'] ?? '',
      gusta: json['gusta'] ?? false,
      modo: json['modo'] ?? 1,
      propietario: json['propietario'] ?? false);

  Contenido copyWith(
      String? idContenido,
      String? titulo,
      String? cuerpo,
      String? multimedia,
      String? url,
      String? avatar,
      String? creador,
      String? fecha,
      String? cuando,
      List<int>? idsCategorias,
      String? categorias,
      bool? gusta,
      int? modo,
      bool? propietario) {
    return Contenido(
        idContenido: idContenido ?? this.idContenido,
        titulo: titulo ?? this.titulo,
        cuerpo: cuerpo ?? this.cuerpo,
        multimedia: multimedia ?? this.multimedia,
        url: url ?? this.url,
        avatar: avatar ?? this.avatar,
        fecha: fecha ?? this.fecha,
        cuando: cuando ?? this.cuando,
        idscategorias: idsCategorias ?? idscategorias,
        categorias: categorias ?? this.categorias,
        gusta: gusta ?? this.gusta,
        modo: modo ?? this.modo,
        propietario: propietario ?? this.propietario);
  }
}
