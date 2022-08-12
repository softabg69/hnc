part of 'baja_bloc.dart';

abstract class BajaEvent extends Equatable {
  const BajaEvent();

  @override
  List<Object> get props => [];
}

class BajaProcesar extends BajaEvent {}
