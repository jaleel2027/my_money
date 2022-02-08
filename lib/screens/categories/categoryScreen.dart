import 'package:flutter/material.dart';
import 'package:my_money/db/category/category_db.dart';
import 'package:my_money/screens/categories/expense_category.dart';
import 'package:my_money/screens/categories/income_category.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this );
    //get categories:
    CategoryDb().refreshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        TabBar(
          controller: _tabController,
            labelColor: Colors.purple,
            indicatorColor: Color(0xE28635D4),
            unselectedLabelColor: Colors.black,
            tabs: [
          Tab(text: 'INCOME',),
          Tab(text: 'EXPENSE ',),
        ]),

        Expanded(
          child: TabBarView(
              controller: _tabController,
              children: [
                //1st view will be tabbars first item:
            IncomeCategoryScreen(),
                ExpenseCategoryScreen()
          ]),
        )
      ],
    );

  }
}