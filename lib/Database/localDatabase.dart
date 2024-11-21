import 'dart:convert';
import 'package:employees_hub/Model/employee.dart';
import 'package:localstorage/localstorage.dart';

class LocalDatabase{

  Future<List<Employee>> getEmployeesList()async{
    List<Employee> employeesList=[];
    var output=localStorage.getItem('employeesData');
    if(output==null)return [];
    var empls=jsonDecode(output);
    empls.forEach((e){
      employeesList.add(Employee(
          id:int.parse(e['id'].toString()),
          name:e['name']??"",
          role:e['role']??"",
          startDate:e['startDate']??"",
          endDate:e['endDate']??""
      ));
    });
    return employeesList;
  }

  Future<void> create(Employee employee)async{
    var empl={'name':employee.name,'role':employee.role,'startDate':employee.startDate,'endDate':employee.endDate};
    var output=localStorage.getItem('employeesData');
    var data=[];
    var id=0;
    if(output!=null){
      var dd=jsonDecode(output);
      data=dd;
      id=data.length==0?1:int.parse(data[data.length-1]['id'])+1;
    }else{
      id=1;
    }
    empl['id']=id.toString();
    data.add(empl);
    localStorage.setItem('employeesData', jsonEncode(data));
    return;
  }
  Future<void> edit(Employee employee)async{
    var output=jsonDecode(localStorage.getItem('employeesData').toString());
    for(var item in output){
      if(int.parse(item['id'])==employee.id){
        item['name']=employee.name;
        item['role']=employee.role;
        item['startDate']=employee.startDate;
        item['endDate']=employee.endDate;
      }
    }
    localStorage.setItem('employeesData', jsonEncode(output));
    return;
  }

  Future<void> delete(int id)async{
    var output=jsonDecode(localStorage.getItem('employeesData').toString());
    output.removeWhere((item)=>int.parse(item['id'])==id);
    localStorage.setItem('employeesData', jsonEncode(output));
  }

  Future<Employee> getEmployee(int id)async{
    var output=jsonDecode(localStorage.getItem('employeesData').toString());
    var f=output.firstWhere((e)=>int.parse(e['id'])==id);
    return Employee(
        id:int.parse(f['id'].toString()),
        name:f['name'].toString(),
        role:f['role'].toString(),
        startDate:f['startDate'].toString(),
        endDate:f['endDate'].toString()
    );
  }
}