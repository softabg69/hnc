part of 'principal_bloc.dart';

abstract class PrincipalState extends Equatable {
  const PrincipalState();
  
  @override
  List<Object> get props => [];
}

class PrincipalInitial extends PrincipalState {}
