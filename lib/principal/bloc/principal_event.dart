part of 'principal_bloc.dart';

abstract class PrincipalEvent extends Equatable {
  const PrincipalEvent();

  @override
  List<Object> get props => [];
}

class PrincipalDrawerOpen extends PrincipalEvent {}

class PrincipalDrawerClose extends PrincipalEvent {}
