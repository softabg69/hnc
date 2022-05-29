import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:helpncare/enumerados.dart';
import 'package:helpncare/repository/hnc_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../components/log.dart';

part 'platform_event.dart';
part 'platform_state.dart';

class PlatformBloc extends Bloc<PlatformEvent, PlatformState> {
  PlatformBloc({required this.hncRepository}) : super(const PlatformState()) {
    on<PlatformLoadEvent>(_load);
  }
  final HncRepository hncRepository;

  void _load(PlatformLoadEvent event, Emitter<PlatformState> emit) async {
    emit(const PlatformState(estado: EstadoPlatform.cargando));
    final info = await PackageInfo.fromPlatform();
    final version = await hncRepository.getVersion();

    if (version.bloqueada) {
      emit(AplicacionBloqueada(msg: version.mensaje));
    } else {
      if (info.version == version.version) {
        emit(PlatformState(
            estado: EstadoPlatform.disponible,
            appName: info.appName,
            packageName: info.packageName,
            version: info.version,
            buildNumber: info.buildNumber,
            buildSignature: info.buildSignature,
            resultadoVersion: ResultadoComparaVersion.iguales));
      } else {
        Log.registra('version: ${version.version}');
        Log.registra('info: ${info.version}');
        final vApp = version.version.split('.');
        final vBD = info.version.split('.');
        final nvApp = int.parse(vApp[2]);
        final nvBD = int.parse(vBD[2]);
        if (vApp[0] == vBD[0] && vApp[1] == vBD[1] && nvApp > nvBD) {
          emit(PlatformState(
              estado: EstadoPlatform.disponible,
              appName: info.appName,
              packageName: info.packageName,
              version: info.version,
              buildNumber: info.buildNumber,
              buildSignature: info.buildSignature,
              resultadoVersion:
                  ResultadoComparaVersion.nuevaVersionDisponible));
        } else if (vApp[0] != vBD[0] || vApp[1] != vBD[1]) {
          emit(PlatformState(
              estado: EstadoPlatform.disponible,
              appName: info.appName,
              packageName: info.packageName,
              version: info.version,
              buildNumber: info.buildNumber,
              buildSignature: info.buildSignature,
              resultadoVersion: ResultadoComparaVersion.imcompatible));
        } else {
          emit(PlatformState(
              estado: EstadoPlatform.disponible,
              appName: info.appName,
              packageName: info.packageName,
              version: info.version,
              buildNumber: info.buildNumber,
              buildSignature: info.buildSignature,
              resultadoVersion: ResultadoComparaVersion.iguales));
        }
      }
    }
  }
}
