import 'package:bloc/bloc.dart';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:mark/services/firebase_storage_service.dart';
import 'package:mark/services/firebase_service.dart';
import 'package:mark/models/employee.dart';

part 'openingevent.dart';
part 'openingstate.dart';

class openingBloc extends Bloc<openingEvent, openingState> {
  openingBloc() : super(openingInitial()) {
    final Imagestorage imagestorage = Imagestorage();
    final apirepository database = apirepository();

    on<openingapproval>((event, emit) async {
      try {
        emit(openingLoading());
        print('hari');
        bool status = await imagestorage.getstatus(event.empid);

        if(status == true) {
          emit(openingtrue());
        }else{
          emit(openingLoading());
          await imagestorage.delete(event.empid);
          emit(openingfalse());
        }
      } on Exception {
        emit(openingError("Failed to fetch data. is your device online?"));
      }
    });

      on<getemployeedata>((event, emit) async {
      try {
        emit(openingLoading());
        var data = await database.employee_getdata(event.userid);
        Employee emp = Employee.fromMap(data.data);
        emit(employeedata(emp));
      } on Exception {
        emit(openingError("Failed to fetch data. is your device online?"));
      }
    }
    );

      on<captureimage>((event, emit) async {
      try {
        emit(openingLoading());
        String img = await imagestorage.uploadFile(event.img, event.userid);
        if(img == null || img == "") {
          emit(imagefalse());
        }else{
          emit(imagetrue());
        }
      } on Exception {
        emit(openingError("Failed to fetch data. is your device online?"));
      }
    }
      );
  }
  }
