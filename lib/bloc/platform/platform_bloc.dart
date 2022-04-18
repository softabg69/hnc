import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'platform_event.dart';
part 'platform_state.dart';

enum platformState { pendiente, cargando, disponible }

class PlatformBloc extends Bloc<PlatformEvent, PlatformState> {
  PlatformBloc() : super(const PlatformState()) {
    on<PlatformLoadEvent>(_load);
  }

  void _load(PlatformLoadEvent event, Emitter<PlatformState> emit) async {
    emit(const PlatformState(estado: platformState.cargando));
    final info = await PackageInfo.fromPlatform();
    emit(PlatformState(
        estado: platformState.disponible,
        appName: info.appName,
        packageName: info.packageName,
        version: info.version,
        buildNumber: info.buildNumber,
        buildSignature: info.buildSignature));
  }
}
