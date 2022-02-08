import 'package:flutter/material.dart';
import 'package:my_money/screens/categories/categoryScreen.dart';
import 'package:my_money/screens/categories/category_popup.dart';
import 'package:my_money/screens/home/widgets/bottomNavigation.dart';
import 'package:my_money/screens/transactions/Add_Transaction/screen_add_transaction.dart';
import 'package:my_money/screens/transactions/screentransactions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

 static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

 final _pages =const [
   TransactionScreen(),
   CategoryScreen(),
 ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Personal Money Manger",style:
            TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
            backgroundColor: Colors.white,
        ),
        bottomNavigationBar: const HomeBottomNavigation(),
        body: SafeArea(
            child: ValueListenableBuilder(
                valueListenable: selectedIndexNotifier,
                builder:(BuildContext context, int updatedIndex, _) {
              return _pages[updatedIndex];
                },)
        ),
        floatingActionButton: FloatingActionButton(

          backgroundColor: Colors.green,
            onPressed: (){

              if(selectedIndexNotifier.value==0){
                print("Add Transactions");
                Navigator.of(context).pushNamed(ScreenAddTransaction.routeName);
              }else{

                print("Add Category");
                showAddCategoryPopup(context);
                // final _sample = CategoryModel(id:
                // DateTime.now().millisecondsSinceEpoch.toString(),
                //     name: "TRAVEL",
                //     type: CategoryType.expense);
                // CategoryDb().insertCategory(_sample);
              }

        },
        child: Icon(Icons.add),
        ),
      ),
    );
  }
}
