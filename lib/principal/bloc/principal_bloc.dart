import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:collection/collection.dart';

// import '../../bloc/session/session_bloc.dart';
// import '../../components/log.dart';
// import '../../enumerados.dart';
// import '../../repository/hnc_repository.dart';

// part 'principal_event.dart';
// part 'principal_state.dart';

// Function eq = const ListEquality().equals;

// class PrincipalBloc extends Bloc<PrincipalEvent, PrincipalState> {
//   PrincipalBloc({required this.hncRepository, required this.session})
//       : super(const PrincipalState(estado: EstadoPrincipal.inicial)) {
//     on<PrincipalEvent>((event, emit) {
//       Log.registra("PrincEvent: $event");
//     });
//     on<PrincipalCambioDias>(
//       (event, emit) {
//         emit(state.copyWith(filtroFechas: event.dias));
//       },
//     );
//     on<PrincipalDrawerOpen>(
//       (event, emit) {
//         Log.registra(('drawer open'));
//         filtroPrevio = session.state.dias;
//         idsCategPrevio = [...session.state.filtroCategorias];
//       },
//     );
//     on<PrincipalDrawerClose>(
//       (event, emit) {
//         Log.registra(('drawer close'));
//         Log.registra('${session.state.dias}, $filtroPrevio');
//         Log.registra('${session.state.filtroCategorias}, $idsCategPrevio');
//         if (!eq(session.state.filtroCategorias, idsCategPrevio)) {
//           Log.registra("cambio en filtro categorias:");
//           Log.registra('${session.state.filtroCategorias}');
//         }
//         if (filtroPrevio != session.state.dias) {
//           Log.registra('cambio en días');
//         }
//         emit(state.copyWith(filtroFechas: session.state.dias));
//       },
//     );
//   }

//   final HncRepository hncRepository;
//   final SessionBloc session;
//   FiltroFechas filtroPrevio = FiltroFechas.ultimos5dias;
//   List<int> idsCategPrevio = [];
// }
