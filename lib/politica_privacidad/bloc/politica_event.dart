part of 'politica_bloc.dart';

@immutable
abstract class PoliticaEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PoliticaRequestDataEvent extends PoliticaEvent {}
