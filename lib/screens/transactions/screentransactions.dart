
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:my_money/db/category/category_db.dart';
import 'package:my_money/db/transactions/transaction_db.dart';
import 'package:my_money/models/category/category_model.dart';
import 'package:my_money/models/transaction/transaction_model.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    //call transaction refresh function:
    TransactionDb.instance.refreshTrans();
    CategoryDb.instance.refreshUI();
    return  ValueListenableBuilder(
        valueListenable: TransactionDb.instance.transListnotifier,
        builder: (BuildContext ctx, List<TransactionModel>newList, Widget?_) {
          return ListView.separated(
            padding: EdgeInsets.all(10),

              // getting values:
            itemBuilder: (ctx, index){
              final _values = newList[index];
              return Slidable(
                key: Key(_values.id!),
                 startActionPane: ActionPane(motion: ScrollMotion(),
                     children: [
                       SlidableAction(
                           onPressed: (ctx){
                             TransactionDb.instance.deleteTransactions(_values.id!);
                           },
                         icon: Icons.delete,
                         label: 'Delete',
                       )
                     ] ),
                        child: Card(
                          elevation: 3,
                          color: Colors.white,
                          child: ListTile(
                            leading: CircleAvatar(
                                backgroundColor: _values.type==CategoryType.income?
                                Colors.green:
                                Colors.red,
                                radius: 25,
                                child: Text(parseDate(_values.date),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),)),
                            title: Text("Rs.${_values.amount}"),
                            subtitle: Text(_values.category.name),

                          ),
                        ),
              );
            },
            separatorBuilder: (ctx, index){
              return SizedBox(height: 10);
            },
            itemCount: newList.length);
        }
    );
  }

  String parseDate (DateTime date){
    final _date = DateFormat.MMMd().format(date);
    final _splitDate = _date.split(' ');
    return '${_splitDate.last}\n${_splitDate.first}';
   // return '${date.day}\n${date.month}';
  }

}