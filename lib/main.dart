import 'package:employees_hub/BlocControllers/employeesCubit.dart';
import 'package:employees_hub/Screen/employeesList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';

Future<void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();
  runApp(BlocProvider(
      create:(_)=>EmployeesCubit(),
      child: const MyApp()
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme:ColorScheme.fromSeed(seedColor:Color(0xff1DA1F2)),
        textTheme:GoogleFonts.robotoTextTheme(Theme.of(context).textTheme)
      ),
      home:EmployeeList(),
    );
  }
}
