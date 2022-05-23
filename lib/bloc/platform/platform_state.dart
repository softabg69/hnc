part of 'platform_bloc.dart';

class PlatformState extends Equatable {
  final EstadoPlatform estado;
  final String appName;
  final String packageName;
  final String version;
  final String buildNumber;
  final String buildSignature;
  final ResultadoComparaVersion resultadoVersion;
  final String mensaje;

  const PlatformState(
      {this.estado = EstadoPlatform.pendiente,
      this.appName = '',
      this.packageName = '',
      this.version = '',
      this.buildNumber = '',
      this.buildSignature = '',
      this.resultadoVersion = ResultadoComparaVersion.iguales,
      this.mensaje = ''});

  @override
  List<Object> get props =>
      [estado, appName, packageName, version, buildNumber, buildSignature];
}

class AplicacionBloqueada extends PlatformState {
  const AplicacionBloqueada({required this.msg});
  final String msg;
}
