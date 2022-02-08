import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:my_money/models/transaction/transaction_model.dart';

const TRANSACTION_DB_NAME = "transaction-db";

abstract class TransactionDbFunctions{

 Future <void> addTransaction(TransactionModel traModObj);

 Future <List<TransactionModel>> getAllTransactions();

 Future <void> deleteTransactions (String id);

}


class TransactionDb implements TransactionDbFunctions{

  //create Singleton for addTransaction: Use Constructor as internal:
  TransactionDb._internal();

  //assign the constructor to a var called instance:
  static TransactionDb instance = TransactionDb._internal();

  factory TransactionDb(){
    return instance;
  }

  ValueNotifier<List<TransactionModel>> transListnotifier = ValueNotifier([]);

  @override
  Future<void> addTransaction(TransactionModel traModObj) async{
    //open box:
    final _traDb = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    _traDb.put(traModObj.id,traModObj );
  }

  Future<void> refreshTrans()async{
    final _list = await getAllTransactions();
    _list.sort((first,second)=> second.date.compareTo(first.date));
    transListnotifier.value.clear();
    transListnotifier.value.addAll(_list);
    transListnotifier.notifyListeners();
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async{
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
     return _db.values.toList();
  }

  @override
  Future<void> deleteTransactions(String id) async{
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await _db.delete(id);
    refreshTrans();
  }
  
}