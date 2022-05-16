enum EstadoPrincipal { inicial, cargando, cargado, errorCarga }
enum FiltroFechas { ultimos5dias, todos }
enum OrigenImagen { network, bytes }
enum AuthMethod { ninguno, local, google }
enum EstadoStories { inicial, cargando, cargado, error }
enum EstadoContenido { inicial, cargando, cargado, error, actualizado }
enum EstadoLogin {
  inicial,
  datosUsuarioCandidatos,
  autenticandoLocal,
  autenticandoGoogle,
  autenticado,
  localError,
  googleError,
  procesado,
  perfilDefinido,
  definirPerfil,
  solicitudCierre,
  cerrado,
  cerrando
}

enum EstadoPerfil {
  inicial,
  cargando,
  cargado,
  error,
  guardando,
  guardado,
  errorGuardar,
  errorSeleccion,
  intentoSinSeleccion,
  yaTienePerfil
}
