import 'package:helpncare/editor/models/editado.dart';
import 'package:helpncare/repository/models/usuario_story.dart';

import 'repository/models/contenido.dart';

typedef CallbackContenido = void Function(Contenido);
typedef CallbackContenidoAsync = Future<void> Function(Contenido);
typedef CallbackUsuarioStory = void Function(UsuarioStory);
typedef CallbackEditado = void Function(Editado);
