import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_money/db/category/category_db.dart';
import 'package:my_money/models/category/category_model.dart';
import 'package:my_money/models/transaction/transaction_model.dart';
import 'package:my_money/screens/home/homescreen.dart';
import 'package:my_money/screens/transactions/Add_Transaction/screen_add_transaction.dart';

Future <void> main() async{

  //create objects for categoryDB:
  final obj1 = CategoryDb();
  final obj2 = CategoryDb();

 WidgetsFlutterBinding.ensureInitialized();
 await Hive.initFlutter();

 if(Hive.isAdapterRegistered(CategoryTypeAdapter().typeId)){
   Hive.registerAdapter(CategoryTypeAdapter());
 }

 if(Hive.isAdapterRegistered(CategoryModelAdapter().typeId)){
  Hive.registerAdapter(CategoryModelAdapter());
}


  if(Hive.isAdapterRegistered(TransactionModelAdapter().typeId)){
    Hive.registerAdapter(TransactionModelAdapter());
  }

 runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
        routes: {
        ScreenAddTransaction.routeName: (ctx)=> const ScreenAddTransaction(),
    },
    );
  }
}

