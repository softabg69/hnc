part of 'platform_bloc.dart';

class PlatformState extends Equatable {
  final platformState estado;
  final String appName;
  final String packageName;
  final String version;
  final String buildNumber;
  final String buildSignature;

  const PlatformState(
      {this.estado = platformState.pendiente,
      this.appName = '',
      this.packageName = '',
      this.version = '',
      this.buildNumber = '',
      this.buildSignature = ''});

  @override
  List<Object> get props =>
      [estado, appName, packageName, version, buildNumber, buildSignature];
}
