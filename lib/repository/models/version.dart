class Version {
  final String app;
  final String version;
  final bool bloqueada;
  final String mensaje;
  final String aviso;

  Version(
      {this.app = '',
      this.version = '',
      this.bloqueada = false,
      this.mensaje = '',
      this.aviso = ''});

  factory Version.fromJson(Map<String, dynamic> json) =>
      _$VersionFromJson(json);

  static Version _$VersionFromJson(Map<String, dynamic> json) => Version(
      app: json['app'] ?? '',
      version: json['version'] ?? '',
      bloqueada: json['bloqueada'] ?? false,
      mensaje: json['mensaje'] ?? '',
      aviso: json['aviso'] ?? '');
}
