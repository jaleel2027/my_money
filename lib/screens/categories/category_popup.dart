import 'package:flutter/material.dart';
import 'package:my_money/db/category/category_db.dart';
import 'package:my_money/models/category/category_model.dart';

  ValueNotifier<CategoryType> selectedCategoryNotifier = ValueNotifier(CategoryType.income);


  Future<void> showAddCategoryPopup(BuildContext context) async{

  //controller for TextField:
  final _nameEditingController = TextEditingController();

  showDialog(
    context: context,
      //in builder, we will get another context, with that context, we will close the dialog:
      builder: (ctx){
    return SimpleDialog(
      title: Text('Add Catergory'),
      children: [
         Padding(
           padding: const EdgeInsets.all(10.0),
           child: TextFormField(
             controller: _nameEditingController,
             decoration: InputDecoration(
               hintText: 'Category Name',
               border: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(10)
               )
             ),
            ),
         ),
          Padding(padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              CustomRadioButton(radioTitle: 'Income', type: CategoryType.income),
              CustomRadioButton(radioTitle: 'Expense', type: CategoryType.expense),
            ],
          ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
                onPressed: (){

              final _name = _nameEditingController.text;
              if(_name.isEmpty){
                return;
              }

              final _type = selectedCategoryNotifier.value;

             final _category = CategoryModel(
                 id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: _name,
                  type: _type);

             CategoryDb.instance.insertCategory(_category);
             Navigator.of(ctx).pop();
            },
                child:  Text("Add")),
          )
      ],
    );
      },
  );
}

class CustomRadioButton extends StatelessWidget {
 final String radioTitle;
 final CategoryType type;


  const CustomRadioButton({Key? key,
    required this.radioTitle,
    required this.type,

  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
      ValueListenableBuilder(valueListenable: selectedCategoryNotifier,
      builder:(BuildContext ctx, CategoryType newCategory, Widget?_){
        return   Radio<CategoryType>(
          activeColor: Colors.green,
            value: type,
            groupValue: newCategory,
            onChanged:(value){

              if(value==null){
                return;
              }
              selectedCategoryNotifier.value=value;
              selectedCategoryNotifier.notifyListeners();
            }
        );
    },
      ),
        Text(radioTitle),
      ],
    );
  }
}
