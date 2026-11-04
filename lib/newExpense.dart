import 'package:expense_tracker_app/models/category_model.dart';
import 'package:expense_tracker_app/models/expense_functionality.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onaddexpense});
  final void Function(Expense expense) onaddexpense;

  @override
  State<NewExpense> createState() => _NewExpensestate();
}

void savecatagorytofirebase() {
  catagorydataref.update({"catagories": categoryList});
}

final catagorydataref = FirebaseDatabase.instance.ref("catagories");

class _NewExpensestate extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _ammountcontroller = TextEditingController();
  DateTime? _selecteddate;
  String? _selectedCategory;
  List<String> allItems = [];

  final formatter = DateFormat.yMd();

  @override
  void initState() {
    super.initState();
    // allItems = categoryList.map((e) => e).toList();
    // if (allItems.isNotEmpty) _selectedCategory = categoryList.first;
    // _savecatagorytofirebase();
  }

  void _submitExpensedata() {
    final enteredAmount = double.tryParse(_ammountcontroller.text);

    if (_titleController.text.trim().isEmpty ||
        enteredAmount == null ||
        enteredAmount <= 0 ||
        _selecteddate == null ||
        _selectedCategory == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("INVALID INPUT"),
          content: const Text("Please enter valid data in all fields"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"))
          ],
        ),
      );
      return;
    }

    widget.onaddexpense(
      Expense(
        amount: enteredAmount,
        title: _titleController.text,
        date: _selecteddate!,
        category: _selectedCategory!,
      ),
    );
    Navigator.of(context).pop();
  }

  void _pickcurrentdate() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: now,
    );

    setState(() => _selecteddate = pickedDate);
  }

  Future<void> _openCategoryPage() async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (ctx) => CategoryAddition()),
    );

    if (result == null) return;

    setState(() {
      if (!allItems.contains(result)) {
        allItems.add(result);

        categoryList.add(result);
        savecatagorytofirebase();
      }
      _selectedCategory = categoryList.first;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _ammountcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: const InputDecoration(label: Text("Title")),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ammountcontroller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      prefixText: "₹ ", label: Text("AMOUNT")),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      _selecteddate == null
                          ? "No Date Selected"
                          : formatter.format(_selecteddate!),
                    ),
                    IconButton(
                      onPressed: _pickcurrentdate,
                      icon: const Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FirebaseAnimatedList(
                  shrinkWrap: true,
                  query: catagorydataref,
                  itemBuilder: (context, snapshot, animation, index) {
                    final data = snapshot.value;

                    List<String> categoryName = (data as List<dynamic>)
                        .map((e) => e.toString())
                        .toList();
                    categoryList = categoryName;
                    return DropdownButton<String>(
                      hint: Text("categories"),
                      value: _selectedCategory,
                      items: categoryName
                          .map(
                            (item) => DropdownMenuItem(
                              value: item,
                              child: Text(
                                item.toUpperCase(),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedCategory = value),
                    );
                  }),
            ],
          ),
          Row(
            children: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("CANCEL")),
              ElevatedButton(
                  onPressed: _submitExpensedata,
                  child: const Text("Enter Expense")),
            ],
          ),
          ElevatedButton.icon(
            onPressed: _openCategoryPage,
            icon: const Icon(Icons.add),
            label: const Text("CATEGORY"),
          ),
          // FirebaseAnimatedList(
          //     shrinkWrap: true,
          //     query: catagorydataref,
          //     itemBuilder: (context, snapshot, animation, index) {
          //       final data = snapshot.value;
          //       print(
          //           " jklhbfkegfweughweughweghwejkghwejkghwjkhgwjkgghjkghwejkghjkweghwejkhgwe");

          //       print(data);

          //       final categoryName =
          //           (data as List<dynamic>).map((e) => e.toString()).toList();
          //       return DropdownButton<String>(
          //         value: _selectedCategory,
          //         items: categoryName
          //             .map((item) => DropdownMenuItem(
          //                 value: item, child: Text(item.toUpperCase())))
          //             .toList(),
          //         onChanged: (value) =>
          //             setState(() => _selectedCategory = value),
          //       );
          //     })
        ],
      ),
    );
  }
}
