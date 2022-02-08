import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_money/db/category/category_db.dart';
import 'package:my_money/db/transactions/transaction_db.dart';
import 'package:my_money/models/category/category_model.dart';
import 'package:my_money/models/transaction/transaction_model.dart';

class ScreenAddTransaction extends StatefulWidget {
  static const routeName = "add-transaction";

  const ScreenAddTransaction({Key? key}) : super(key: key);

  @override
  State<ScreenAddTransaction> createState() => _ScreenAddTransactionState();
}

class _ScreenAddTransactionState extends State<ScreenAddTransaction> {

  //Give options to save: & we r building UI with this value:
  DateTime? _selectedDate;
  CategoryType? _selectedCategoryType;
  CategoryModel? _selectedCategoryModel;

  @override
  void initState() {
    _selectedCategoryType=CategoryType.income;
  }

  String? _categoryID;

  //create 2 controllers to get values from textfield:
  final _purposeTextController = TextEditingController();
  final _amountTextController = TextEditingController();


  /*
  Purpose
  Date
  Amount
  Income or Expense
  Category type


   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 80,horizontal: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Purpose
                  TextFormField(
                    controller: _purposeTextController,
                    decoration: InputDecoration(
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.teal)
                        ),
                      hintText: "Purpose"
                    ),
                  ),
                  SizedBox(height: 10,),
                  //Amount
                  TextFormField(
                    controller: _amountTextController,
                    keyboardType:TextInputType.number ,
                    decoration: InputDecoration(
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.teal)
                        ),
                        hintText: "Amount"
                  ),
                  ),

                  //Calendar:
                  TextButton.icon(
                      onPressed: () async {
                      final _selectedDateTemp = await  showDatePicker(context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now().subtract(Duration(days: 30)),
                            lastDate: DateTime.now());

                      if(_selectedDateTemp==null){
                        return;
                      }else{
                        print(_selectedDateTemp.toString());

                        setState(() {
                          _selectedDate=_selectedDateTemp;
                        });

                      }

                      },
                      icon: Icon(Icons.calendar_today),
                      label: Text( _selectedDate==null? "Select Date": _selectedDate.toString())
                  ),

                  //Category:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Radio(
                              value: CategoryType.income,
                              groupValue: _selectedCategoryType,
                              onChanged: (newValue){
                                setState(() {
                                  _selectedCategoryType= CategoryType.income;
                                  _categoryID = null;
                                });
                              },
                          ),
                          Text("Income"),
                        ],
                      ),

                      Row(
                        children: [
                          Radio(value: CategoryType.expense,
                            groupValue: _selectedCategoryType,
                            onChanged: (newValue){
                              setState(() {
                                _selectedCategoryType= CategoryType.expense;
                                _categoryID = null;
                              });
                            },
                          ),
                          Text("Expense"),
                        ],
                      ),
                    ],
                  ),
                  //Category type:
                  DropdownButton<String>(
                    value: _categoryID,
                    hint: Text("Select Category"),
                    items: (_selectedCategoryType == CategoryType.income
                    //if condition is true:
                    ?CategoryDb().incomeCategoryListListener
                    //if condition is false:
                    : CategoryDb().expenseCategoryListListener)
                        .value
                        .map((e){
                      return DropdownMenuItem(
                        onTap: (){
                          _selectedCategoryModel = e;
                        },
                        value: e.id,
                          child: Text(e.name));
                    } ).toList() ,
                    onChanged: (_selectedValue){
                      print(_selectedValue);
                     setState(() {
                       _categoryID= _selectedValue;
                     });
                      },
                  ),
                  //SUBMIT:
                  ElevatedButton.icon(
                      onPressed: (){
                        addTransaction();
                  },
                      icon: Icon(Icons.check),
                      label: Text("SUBMIT"))
                ],
              ),
            ),
        ),

    );
  }

  Future<void>addTransaction() async{
    final purposeText = _purposeTextController.text;
    final amountText  = _amountTextController.text;

    //checking purpose:
    if(purposeText.isEmpty){
      return;
    }

    //checking amount:
    if(amountText.isEmpty){
      return;
    }

    // if(_categoryID==null){
    //   return;
    // }

    if(_selectedDate==null){
      return;
    }

    if(_selectedCategoryModel==null){
      return;
    }

   final _parsedAmount = double.tryParse(amountText);
    if(_parsedAmount==null){
      return;
    }
    
    //selectDate:
    //selectCategoryType:

    //categoryId:

   final _traModel = TransactionModel(
      purpose: purposeText,
      amount: _parsedAmount ,
      date: _selectedDate!,
      type: _selectedCategoryType!,
      category: _selectedCategoryModel!);

    await TransactionDb.instance.addTransaction(_traModel);
    Navigator.of(context).pop();
    TransactionDb.instance.refreshTrans();
  }

}
