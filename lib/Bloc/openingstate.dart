part of 'openingbloc.dart';

abstract class openingState extends Equatable {
  const openingState();

  @override
  List<Object> get props => [];
}

class openingInitial extends openingState {}

class openingLoading extends openingState {}

class openingtrue extends openingState {
}

class openingfalse extends openingState {
}

class imagetrue extends openingState {
}

class imagefalse extends openingState {
}

class openingError extends openingState {
  final String message;
  const openingError(this.message);
}

class employeedata extends openingState{
  Employee emp;
  employeedata(this.emp);
  @override
  List<Object> get props => [emp];
}

