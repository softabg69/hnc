enum EstadoPrincipal { inicial, cargando, cargado, errorCarga }

enum FiltroFechas { ultimos5dias, todos }

enum OrigenImagen { network, bytes }

enum AuthMethod { ninguno, local, google, apple }

enum EstadoStories { inicial, cargando, cargado, error }

enum EstadoEditor { editando, guardando, guardado, error }

enum EstadoPlatform { pendiente, cargando, disponible }

enum ResultadoComparaVersion { iguales, nuevaVersionDisponible, imcompatible }

enum EstadoContenido {
  inicial,
  cargando,
  cargado,
  error,
  actualizado,
  eliminando,
  eliminado,
  errorEliminar
}

enum EstadoGusta { normal, cambiando, error }

enum EstadoLogin {
  inicial,
  datosUsuarioCandidatos,
  autenticandoLocal,
  autenticandoGoogle,
  autenticandoApple,
  autenticado,
  localError,
  googleError,
  appleError,
  procesado,
  perfilDefinido,
  definirPerfil,
  solicitudCierre,
  cerrado,
  cerrando,
  cargadasCredenciales
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
