
import 'package:employees_hub/BlocControllers/employeesEvent.dart';
import 'package:employees_hub/Database/localDatabase.dart';
import 'package:employees_hub/Model/employee.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeesCubit extends Cubit<EmployeeEvents>{
  List<Employee> employees=[];
  LocalDatabase method=new LocalDatabase();
  EmployeesCubit():super(InitialLoad()){
    getEmployees();
  }

  void getEmployees()async{
    emit(Loading());
    try{
      employees=await method.getEmployeesList();
      emit(EmployeesLoaded(employee: employees));
    }catch(e){
      emit(Warning());
    }
  }

  void createEmployee(Employee employee){
    emit(Loading());
    try{
      method.create(employee).then((_)=> getEmployees());
    }catch(e){
      emit(Warning());
    }
  }

  void editEmployee(Employee employee){
    emit(Loading());
    try{
      method.edit(employee).then((_)=> getEmployees());
    }catch(e){
      emit(Warning());
    }
  }

  void deleteEmployee(int id){
    emit(Loading());
    try{
      method.delete(id).then((_)=> getEmployees());
    }catch(e){
      emit(Warning());
    }
  }
}