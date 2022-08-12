part of 'baja_bloc.dart';

abstract class BajaState extends Equatable {
  const BajaState();

  @override
  List<Object> get props => [];
}

class BajaInitial extends BajaState {}

class BajaCompletada extends BajaState {}

class BajaError extends BajaState {}
