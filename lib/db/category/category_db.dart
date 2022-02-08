import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:my_money/models/category/category_model.dart';

const CATEGORY_DB_NAME = 'category-database';

 abstract class CategoryDbFunctions{

   //we need get a list of category model:
 Future <List<CategoryModel>> getCategories();

 //insert
  Future <void> insertCategory(CategoryModel value);

  //delete:
 Future<void> deleteCategory(String categoryId);

}

// create a class to implement these functioins:
class CategoryDb implements CategoryDbFunctions{

   //create singlton:
  //create named constructor internal:
  CategoryDb._internal();
  //send the internal value to instance:
  //while instance call, object intern returns:
  static CategoryDb instance= CategoryDb._internal();


  //make sure, only 1 object returns: so, we use factory method:
  //while creating categorydb, instance will return:
  factory CategoryDb(){
    return CategoryDb.instance;
  }


   ValueNotifier<List<CategoryModel>> incomeCategoryListListener = ValueNotifier([]);

   ValueNotifier<List<CategoryModel>> expenseCategoryListListener = ValueNotifier([]);

   //we can override & use these functions:
  @override
  Future<void> insertCategory(CategoryModel value) async{

    //we have to create objects, then only we can call our functions:
   final _categoryDb = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
   _categoryDb.put(value.id, value);
   refreshUI();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final _categoryDb = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
   return _categoryDb.values.toList();
  }

  Future<void> refreshUI() async {
   final _getAllCategories= await getCategories();
   incomeCategoryListListener.value.clear();
   expenseCategoryListListener.value.clear();

   await Future.forEach(_getAllCategories, (CategoryModel category) {
     if(category.type==CategoryType.income){
       incomeCategoryListListener.value.add(category);
     }else{
       expenseCategoryListListener.value.add(category);
     }
   },
   );

   incomeCategoryListListener.notifyListeners();
   expenseCategoryListListener.notifyListeners();

  }

  @override
  Future <void> deleteCategory(String categoryId) async{

    //initiating categoryDb as Hive box:
    final _categoryDb = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    _categoryDb.delete(categoryId);
    refreshUI();
  }

}