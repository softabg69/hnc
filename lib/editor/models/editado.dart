import 'dart:typed_data';

class Editado {
  final String idContenido;
  final int modo;
  final String? titulo;
  final String? cuerpo;
  final Uint8List imagen;
  final List<int> categoriasSeleccionadas;

  Editado(this.idContenido, this.modo, this.titulo, this.cuerpo, this.imagen,
      this.categoriasSeleccionadas);
}
