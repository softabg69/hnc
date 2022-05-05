part of 'principal_bloc.dart';

enum EstadoPrincipal { inicial, cargando, cargado, errorCarga }
enum FiltroFechas { ultimos5dias, todos }

class PrincipalState extends Equatable {
  const PrincipalState(
      {this.estado = EstadoPrincipal.inicial,
      this.filtroFechas = FiltroFechas.ultimos5dias});

  final EstadoPrincipal estado;
  final FiltroFechas filtroFechas;

  @override
  List<Object> get props => [estado, filtroFechas];
}
