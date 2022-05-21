import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hnc/bloc/session/session_bloc.dart';
//import 'package:hnc/contenido/bloc/contenido_bloc.dart';
import 'package:hnc/editor/bloc/editor_bloc.dart';
import 'package:hnc/editor/widgets/contenido_imagen.dart';
import 'package:hnc/tipos.dart';
//import 'package:hnc/repository/hnc_repository.dart';

import '../../components/configuracion.dart';
import '../../components/dialog.dart';
//mport '../../components/log.dart';
import '../../enumerados.dart';
import '../../repository/models/categoria.dart';
import '../../repository/models/contenido.dart';

class Editor extends StatefulWidget {
  const Editor(
      {Key? key,
      required this.contenido,
      required this.modo,
      required this.guardar})
      : super(key: key);

  final Contenido contenido;
  final int modo;
  final CallbackContenidoAsync guardar;

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  final _titulo = TextEditingController();
  final _texto = TextEditingController();
  final _url = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int textoLen = 100;
  String? idImagen;
  Uint8List? imagen;
  List<Categoria>? categorias = [];
  //ContenidoBloc? _contenidoBloc;
  bool navegado = false;

  @override
  void initState() {
    super.initState();
    _titulo.text = widget.contenido.titulo;
    _texto.text = widget.contenido.cuerpo;
    _url.text = widget.contenido.url;
    idImagen = widget.contenido.multimedia;
  }

  @override
  void didChangeDependencies() {
    categorias = [];
    for (final cat in context.read<SessionBloc>().state.categoriasUsuario) {
      final nueva = cat.copyWith(
          seleccionada: widget.contenido.idscategorias.contains(cat.id));
      categorias!.add(nueva);
    }
    //_contenidoBloc = context.read<ContenidoBloc>();
    super.didChangeDependencies();
  }

  List<int> get _categoriasSeleccionadas {
    final List<int> res = [];
    for (int index = 0; index < categorias!.length; index++) {
      if (categorias![index].seleccionada) {
        res.add(categorias![index].id);
      }
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    //Log.registra(_contenidoBloc.toString());
    return Scaffold(
      body: BlocListener<EditorBloc, EditorState>(
        listener: ((context, state) {
          if (state.estado == EstadoEditor.guardado && !navegado) {
            navegado = true;
            Navigator.pop(context);
          }
        }),
        child: Form(
          key: _formKey,
          child: BlocBuilder<EditorBloc, EditorState>(
            builder: (context, state) => state.estado == EstadoEditor.guardando
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : CustomScrollView(
                    slivers: _formulario(context),
                  ),
          ),
        ),
      ),
    );
  }

  void guarda() async {
    if (_formKey.currentState!.validate()) {
      if (_categoriasSeleccionadas.isEmpty) {
        await Dialogs.informacion(context, const Text('Error'),
            const Text('Debe seleccionar al menos una categoría'));
        return;
      }
      if (widget.contenido.idContenido.isEmpty && imagen == null) {
        await Dialogs.informacion(context, const Text('Error'),
            const Text('Debe seleccionar una imagen'));
        return;
      }
      context.read<EditorBloc>().add(EditorGuardarEvent(
          id: widget.contenido.idContenido,
          titulo: _titulo.text,
          cuerpo: _texto.text,
          url: _url.text,
          imagen: imagen,
          modo: widget.contenido.modo,
          categorias: _categoriasSeleccionadas));

      await widget.guardar(widget.contenido.copyWith(
          titulo: _titulo.text,
          cuerpo: _texto.text,
          url: _url.text,
          idsCategorias: _categoriasSeleccionadas));

      // if (widget.contenido != null) {
      //   datos['idContenido'] = widget.contenido!.idContenido;
      // }
      // datos['titulo'] = _titulo.text;
      // datos['texto'] = _texto.text;
      // datos['url'] = _url.text;

      // final categoriasSeleccionadas = [];
      // for (var cat in datas) {
      //   if (cat.seleccionada) {
      //     categoriasSeleccionadas.add(cat.id);
      //   }
      // }
      // datos['categorias'] = categoriasSeleccionadas;
      // datos['modo'] = widget.modo;
      // if (!imagenSeleccionada) datos['imagen'] = null;
      // //print("Datos: $datos");

      // Llamadas.guardarStory(datos, () {
      //   recargar();
      //   Navigator.pop(context);
      // }, () {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(
      //       content: Text('Se ha producido un error'),
      //       backgroundColor: Colors.red,
      //     ),
      //   );
      // });
    }
  }

  List<Widget> _formulario(BuildContext context) {
    return <Widget>[
      appBar(context),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: titulo(),
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: texto(),
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: url(),
        ),
      ),
      ContenidoImagen(
          idImagen: idImagen,
          imagen: imagen,
          cambiada: (bytes) {
            setState(() {
              idImagen = '';
              imagen = bytes;
            });
          }),
      // SliverToBoxAdapter(
      //   child: imagePicker(),
      // ),
      SliverToBoxAdapter(
        child: listCategorias(),
      ),
    ];
  }

  Widget appBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      title: Text(widget.modo == 1
          ? widget.contenido.idContenido.isEmpty
              ? 'Crear contenido'
              : 'Editar contenido'
          : widget.contenido.idContenido.isEmpty
              ? 'Crear story'
              : 'Editar story'),
      actions: [
        IconButton(
          icon: const Icon(Icons.save),
          tooltip: 'Guardar',
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              guarda();
            }
          },
        ),
      ],
    );
  }

  // Widget imagePicker() {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: ConstrainedBox(
  //       constraints: const BoxConstraints(
  //         maxHeight: 200,
  //         maxWidth: double.infinity,
  //       ),
  //       child: ImageContentPicker(
  //         cambiada: (img) {
  //           //print("imagen seleccionada");
  //           datos['imagen'] = img;
  //           imagenSeleccionada = true;
  //           //print("cambiada");
  //           //print("Datos imagen: ${datos['imagen']}");
  //         },
  //         imagenActual:
  //             widget.contenido != null ? widget.contenido!.multimedia : '',
  //       ),
  //     ),
  //   );
  // }

  Widget categoriaWidget(int index) {
    return Column(
      children: [
        SizedBox(
          width: 90,
          child: Center(
            child: FittedBox(
              child: Text(
                categorias![index].descripcion,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.contain,
              image: NetworkImage(
                  "${Environment().config!.baseUrlServicios}/data/avatarCategoria?id=${categorias![index].avatar}"),
            ),
          ),
        ),
        Switch(
          value: categorias![index].seleccionada,
          onChanged: (a) {
            setState(() {
              categorias![index] = categorias![index]
                  .copyWith(seleccionada: !categorias![index].seleccionada);
            });

            // setState(() {
            //   categoria.seleccionada = !categoria.seleccionada;
            //   //categoria.cambiaSeleccionada(context, categoria.id);
            // });

            // setState(() {
            //   categoria.seleccionada =
            //       !categoria.seleccionada;
            // });
          },
        ),
      ],
    );
  }

  Widget listCategorias() {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categorias!.length,
            itemBuilder: (BuildContext context, int index) {
              return categoriaWidget(index);
            },
          ),
        ),
      ),
    );
  }

  Widget titulo() {
    return TextFormField(
      controller: _titulo,
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      style: const TextStyle(color: Colors.black),
      decoration: const InputDecoration(
        label: Text('Título'),
        errorStyle: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      validator: (String? value) {
        if (value == null) return 'El título no puede estar vacío';
        if (value.length > 100) {
          return 'El título tiene un límite de 100 caracteres. El tamaño actual es de ${value.length}.';
        }
        return null;
      },
    );
  }

  Widget texto() {
    return TextFormField(
      controller: _texto,
      maxLines: 5,
      keyboardType: TextInputType.multiline,
      style: const TextStyle(color: Colors.black),
      decoration: const InputDecoration(
        label: Text('Contenido de la story'),
        errorStyle: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      validator: (String? value) {
        if (value == null) return 'Debe tener contenido';
        if (value.length > 2500) {
          return 'El texto tiene un límite de 2500 caracteres. El tamaño actual es de ${value.length}.';
        }
        return null;
      },
    );
  }

  Widget url() {
    return TextFormField(
      controller: _url,
      keyboardType: TextInputType.url,
      style: const TextStyle(color: Colors.black),
      decoration: const InputDecoration(
        label: Text('Url relacionada'),
        errorStyle: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      validator: (String? value) {
        if (value != null && value.length > 100) {
          return 'La url tiene un límite de 100 caracteres. El tamaño actual es de ${value.length}.';
        }
        return null;
      },
    );
  }
}
