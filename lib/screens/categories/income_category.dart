import 'package:flutter/material.dart';
import 'package:my_money/db/category/category_db.dart';
import 'package:my_money/models/category/category_model.dart';

class IncomeCategoryScreen extends StatelessWidget {
  const IncomeCategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(valueListenable: CategoryDb().incomeCategoryListListener,
      builder:(BuildContext ctx, List<CategoryModel> newList, Widget?_) {
        return ListView.separated(
            padding: EdgeInsets.all(10),
            itemBuilder: (ctx,index){
              final category = newList[index];

              return Card(
                elevation: 3,
                child: ListTile(
                  title: Text(category.name),
                  trailing: IconButton(onPressed: (){
                    CategoryDb.instance.deleteCategory(category.id);
                  },
                      icon: Icon(Icons.delete,
                        color: Colors.red,)),
                ),
              );

            },
            separatorBuilder: (ctx, index){
              return SizedBox(height: 1);
            },
            itemCount: newList.length);
      },
    );
  }
}
