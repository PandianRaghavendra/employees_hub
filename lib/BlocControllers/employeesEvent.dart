import 'package:employees_hub/Model/employee.dart';
import 'package:equatable/equatable.dart';

abstract class EmployeeEvents extends Equatable {
  EmployeeEvents();
  @override
  List<Employee> get props=>[];
}

class Loading extends EmployeeEvents{}

class InitialLoad extends EmployeeEvents{}

class Warning extends EmployeeEvents{}

class EmployeesLoaded extends EmployeeEvents{
  final List<Employee> employee;
  EmployeesLoaded({required this.employee});
  @override
  List<Employee> get props=>employee;
}
