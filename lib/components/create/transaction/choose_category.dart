import 'package:finances/components/global/category_vertical.dart';
import 'package:finances/models/category.dart';
import 'package:finances/services/category_service.dart';
import 'package:finances/utils/enums.dart';
import 'package:finances/utils/get_it.dart';
import 'package:finances/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class ChooseCategory extends StatefulWidget {
  final TransactionType type;
  const ChooseCategory({super.key, required this.type});

  @override
  State<ChooseCategory> createState() => _ChooseCategoryState();
}

class _ChooseCategoryState extends State<ChooseCategory> {
  late Future<List<Category>> _categoriesBuilder;

  @override
  void initState() {
    _categoriesBuilder = getIt<CategoryService>().listCategories(
      limit: 99,
      type: widget.type,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.createCategory,
                      arguments: widget.type,
                    ).then((value) {
                      setState(() {
                        _categoriesBuilder = getIt<CategoryService>()
                            .listCategories(type: widget.type, limit: 99);
                      });
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    minimumSize: const Size(double.infinity, 40),
                    elevation: 0,
                  ),
                  child: Icon(
                    Symbols.add,
                    color: Theme.of(context).focusColor,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: FutureBuilder(
                    future: _categoriesBuilder,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        int missing = snapshot.data!.length;

                        while (missing >= 4) {
                          missing -= 4;
                        }

                        missing = 4 - missing;

                        return Wrap(
                          runSpacing: 10,
                          alignment: WrapAlignment.spaceAround,
                          children: [
                            for (var category in snapshot.data!)
                              CategoryVertical(
                                category: category,
                                onTap: () {
                                  Navigator.pop(context, category);
                                },
                                selected: false,
                              ),
                            for (var i = 0; i < missing; i++)
                              const SizedBox(
                                height: 110,
                                width: 80,
                              )
                          ],
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
