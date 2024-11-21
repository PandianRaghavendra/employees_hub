import 'package:employees_hub/BlocControllers/employeesCubit.dart';
import 'package:employees_hub/Database/localDatabase.dart';
import 'package:employees_hub/Model/employee.dart';
import 'package:employees_hub/Utils/color.dart';
import 'package:employees_hub/Widgets/customDatePicker.dart';
import 'package:employees_hub/Widgets/reusable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class AddEditEmployee extends StatefulWidget {
  bool isEdit=false;
  int id=0;
  AddEditEmployee({super.key,this.isEdit=false,this.id=0});

  @override
  State<AddEditEmployee> createState() => _AddEditEmployeeState();
}

class _AddEditEmployeeState extends State<AddEditEmployee> {
  String role="",startDay="",endDay="",hold="";
  TextEditingController name=TextEditingController();
  LocalDatabase localDatabase=new LocalDatabase();
  Employee? emp;
  @override
  void initState(){
    initial();
    super.initState();
  }
  void initial()async{
    if(widget.isEdit){
      emp=await localDatabase.getEmployee(widget.id);
      role=emp!.role;
      name.text=emp!.name;
      startDay=emp!.startDate;
      endDay=emp!.endDate;
      setState(() {});
    }
  }
  void bottomSheet(context) {
    List<String> roles=["Product Designer","Flutter Developer","QA Tester","Product Owner"];
    double height = MediaQuery.of(context).size.height;
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height:height*0.3,
            child: ListView(
              children: ListTile.divideTiles(
                  color:Colors.grey.withOpacity(0.7),
                  context: context,
                  tiles:roles.map((item){
                    return ListTile(
                      onTap:(){
                        setState(() {
                          role=item;
                        });
                        Navigator.pop(context);
                      },
                      title:Text(item,style:TextStyle(fontWeight:FontWeight.w400,fontSize:16),textAlign:TextAlign.center,),
                    );
                  }).toList()
              ).toList(),
            ),
          );
        });
  }
  Widget datePicker(String dateHolder,{bool isEnd = false}){
    return  InkWell(
      onTap:(){
        CustomDatePicker.show(
          context,
          onDateSelected: (DateTime selectedDate) {
            setState(() {
              dateHolder=DateFormat('dd MMM yy').format(selectedDate);
              isEnd?endDay=dateHolder:startDay=dateHolder;
            });
          },
          isEnd:isEnd,
          initialDate: DateTime.now(),
        );
      },
      child: Container(
        height: 40,
        width: MediaQuery.sizeOf(context).width * 0.38,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: SvgPicture.asset(
                "assets/calendar.svg",
              ),
            ),
            Text(
              dateHolder!=""?dateHolder.toString():isEnd?"End Date":"Start Date",
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue,
          title: Text("${widget.isEdit?"Edit":"Add"} Employee Details",
              style: TextStyle(fontSize: 18, color: Colors.white)),
          actions:[
            widget.isEdit?IconButton(onPressed:(){
              Navigator.pop(context);
              context.read<EmployeesCubit>().deleteEmployee(widget.id);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Employee ${name.text} is deleted')));
            }, icon:Icon(Icons.delete_outline_sharp,color:Colors.white,)):SizedBox(),
          ]
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(top: 10),
        color:Colors.white,
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.text,
              controller:name,
              decoration: InputDecoration(
                prefixIcon:Icon(Icons.person_2_outlined,color:AppColors.primaryColor,size:24,),
                enabledBorder:OutlineInputBorder(
                  borderRadius:BorderRadius.circular(4),
                  borderSide:BorderSide(color:Colors.grey.withOpacity(0.5))
                ),
                focusedBorder:OutlineInputBorder(
                  borderRadius:BorderRadius.circular(4),
                    borderSide:BorderSide(color:Colors.grey.withOpacity(0.5))
                ),
                hintText: "Employee name",
                hintStyle: TextStyle(color: Colors.grey),
                isDense: true,
              ),
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.black,
              ),
            ),
            InkWell(
              onTap: () {
                bottomSheet(context);
              },
              child: Container(
                margin:EdgeInsets.only(top:20),
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.5),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: SvgPicture.asset(
                        "assets/emp_desg.svg",
                      ),
                    ),
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            role!=""?role:"Select role",
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey,
                            ),
                          ),
                        )),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_drop_down_sharp,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  datePicker(isEnd:false,startDay),
                  SvgPicture.asset("assets/arrow.svg",),
                  datePicker(isEnd:true,endDay),
                ],
              ),
            )
          ],
        ),
      ),
      bottomSheet: Container(
        padding:EdgeInsets.all(10),
        decoration:BoxDecoration(
          color:Colors.white,
          border:Border(
            top:BorderSide(
              width:1,
              color:Colors.grey.withOpacity(0.5)
            )
          )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Reusable().button("Cancel",AppColors.buttonLightColor,(){
              Navigator.pop(context);
            }),
            SizedBox(
              width: 10,
            ),
            Reusable().button("Save",AppColors.primaryColor, () {
              if(name.text.toString().trim().length==0) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Enter employee name"),
                ));
              } else if (role.toString().trim().length==0) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Select role"),
                ));
              }else if (startDay.toString().trim().length==0) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Select Start date"),
                ));
              } else {
                Employee emp1 = new Employee(name: name.text,
                    role: role,
                    startDate: startDay,
                    endDate: endDay);
                if (widget.isEdit) {
                  emp1.id = widget.id;
                  context.read<EmployeesCubit>().editEmployee(emp1);
                } else
                  context.read<EmployeesCubit>().createEmployee(emp1);
                Navigator.pop(context);
              }
            }),
          ],
        ),
      ), // Your footer
    );
  }
}
