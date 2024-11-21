class Employee{
  int id;
  String name,startDate,endDate,role;
  Employee({this.id=0,required this.name,required this.role,required this.startDate,required this.endDate});

  Map<String,dynamic> toMap(){
    return {
      'id':id,
      'name':name,
      'role':role,
      'startDate':startDate,
      'endDate':endDate
    };
  }

  factory Employee.fromMap(Map<String,dynamic> map){
    return Employee(id:map['id']??0,name: map['name'], role: map['designation'], startDate: map['startTime'], endDate: map['endTime']);
  }
}