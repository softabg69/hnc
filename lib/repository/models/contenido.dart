class Contenido {
  final int id;
  final String idContenido;
  final String titulo;
  final String cuerpo;
  final String multimedia;
  final String url;
  final int idCreador;
  final String creador;
  final String fecha;
  final List<int> idscategorias;
  final String categorias;
  final bool gusta;
  final int modo;
  final bool propietario;

  Contenido(
      {this.id = 0,
      this.idContenido = '',
      this.titulo = '',
      this.cuerpo = '',
      this.multimedia = '',
      this.url = '',
      this.idCreador = 0,
      this.creador = '',
      this.fecha = '',
      this.idscategorias = const [],
      this.categorias = '',
      this.gusta = false,
      this.modo = 1,
      this.propietario = false});

  // Contenido.desdeId(int idc)
  //     : id = -1,
  //       idContenido = idc,
  //       titulo = '',
  //       cuerpo = '',
  //       multimedia = '',
  //       url = '',
  //       creador = '',
  //       fecha = '',
  //       grupos = '',
  //       idu = 0,
  //       gusta = false;

  Contenido.fromMap(Map map)
      : id = map['id'] ?? 0,
        idContenido = map['idContenido'] ?? '',
        titulo = map['titulo'] ?? "",
        cuerpo = map['cuerpo'] ?? "",
        multimedia = map['multimedia'] ?? "",
        url = map['url'] ?? "",
        idCreador = map['idCreador'] ?? 0,
        creador = map['creador'] ?? "",
        fecha = map['fecha'] ?? "",
        idscategorias = (map['idscategorias']).cast<int>(),
        categorias = map['categorias'] ?? "",
        gusta = map['gusta'] ?? false,
        modo = map['modo'] ?? 1,
        propietario = map['propietario'];

  factory Contenido.fromJson(Map<String, dynamic> json) =>
      _$ContenidoFromJson(json);

  static Contenido _$ContenidoFromJson(Map<String, dynamic> json) => Contenido(
      id: json['id'] ?? 0,
      idContenido: json['idContenido'] ?? '',
      titulo: json['titulo'] ?? '',
      cuerpo: json['cuerpo'] ?? '',
      multimedia: json['multimedia'] ?? '',
      url: json['url'] ?? '',
      idCreador: json['idCreador'] ?? 0,
      creador: json['creador'] ?? '',
      fecha: json['fecha'] ?? '',
      idscategorias: (json['idscategorias']).cast<int>(),
      categorias: json['categorias'] ?? '',
      gusta: json['gusta'] ?? false,
      modo: json['modo'] ?? 1,
      propietario: json['propietario'] ?? false);
}
