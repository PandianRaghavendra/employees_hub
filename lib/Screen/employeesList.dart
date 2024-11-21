import 'package:employees_hub/BlocControllers/employeesCubit.dart';
import 'package:employees_hub/BlocControllers/employeesEvent.dart';
import 'package:employees_hub/Model/employee.dart';
import 'package:employees_hub/Screen/addEditEmployee.dart';
import 'package:employees_hub/Utils/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeList extends StatefulWidget {

  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  List<Employee> previousEmployee=[],currentEmployee=[];
  Widget listEmployee(List<Employee> employList,String type){
    return Column(
      mainAxisAlignment:MainAxisAlignment.start,
      crossAxisAlignment:CrossAxisAlignment.start,
      children: [
        Padding(
          padding:EdgeInsets.all(12),
          child:Text(type,style:TextStyle(fontWeight:FontWeight.bold,color:AppColors.primaryColor,fontSize:16),),
        ),
        ...employList.map((item){
          return Dismissible(
            key:Key(item.id.toString()),
            onDismissed:(direction){
              context.read<EmployeesCubit>().deleteEmployee(item.id);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Employee ${item.name} is deleted')));
            },
            background:Container(
              alignment:Alignment.centerRight,
              padding:EdgeInsets.only(right:50),
              color:Color(0xffF34642),
              child:Icon(Icons.delete,color:Colors.white,),
            ),
            child: ListTile(
              tileColor:Colors.white,
              title:Text(item.name,style:TextStyle(fontWeight: FontWeight.bold,color:Colors.black,fontSize:16),),
              subtitle:Column(
                mainAxisAlignment:MainAxisAlignment.start,
                crossAxisAlignment:CrossAxisAlignment.start,
                children: [
                  SizedBox(height:7,),
                  Text(item.role,style:TextStyle(fontWeight: FontWeight.normal,color:AppColors.greyText),),
                  SizedBox(height:7,),
                  item.endDate==""?
                  Text("From ${item.startDate}",style:TextStyle(fontWeight: FontWeight.normal,color:AppColors.greyText,fontSize:14),):
                  Text("${item.startDate} - ${item.endDate}",style:TextStyle(fontWeight: FontWeight.normal,color:AppColors.greyText,fontSize:12),),
                ],
              ),
              trailing:IconButton(onPressed:(){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddEditEmployee(isEdit:true,id:item.id,)),
                );
              }, icon:Icon(Icons.edit)),
            ),
          );
        }).toList(),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:AppColors.primaryColor,
        title: Text("Employee List",style: TextStyle(
            fontSize: 18,
            fontWeight:FontWeight.bold,
            color: Colors.white
        )),
      ),
      backgroundColor:AppColors.backGround,
      body: BlocBuilder<EmployeesCubit,EmployeeEvents>(builder:(context,state){
        if(state.props.length>0){
          previousEmployee.clear();
          currentEmployee.clear();
          state.props.forEach((e){
            e.endDate!=""?previousEmployee.add(e):currentEmployee.add(e);
          });
        }
        return state is Loading ? CircularProgressIndicator():state.props.length>0?
        Column(
          mainAxisAlignment:MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView(
                children: [
                  currentEmployee.length>0?listEmployee(currentEmployee,"Current employees"):SizedBox(),
                  previousEmployee.length>0?listEmployee(previousEmployee,"Previous employees"):SizedBox(),
                ],
              ),
            ),
            Container(
              alignment:Alignment.bottomLeft,
              padding:EdgeInsets.all(12),
              child:Text("Swipe left to delete",style:TextStyle(fontWeight:FontWeight.bold,color:AppColors.greyText),),
            ),
          ],
        ):
        Image.asset("assets/noEmployee.png",alignment:Alignment.center);
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor:AppColors.buttonColor,
        elevation:0,
        shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(7)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditEmployee()),
          );
        },
        child: const Icon(Icons.add,color: Colors.white,size:30,),
      ),
    );
  }
}
