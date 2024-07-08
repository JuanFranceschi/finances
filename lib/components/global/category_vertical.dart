import 'package:finances/models/category.dart';
import 'package:flutter/material.dart';

class CategoryVertical extends StatelessWidget {
  final Category category;
  final Function() onTap;
  final bool selected;

  const CategoryVertical({
    super.key,
    required this.category,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      onTap: onTap,
      child: Container(
        height: 110,
        width: 80,
        decoration: BoxDecoration(
          color: selected ? category.color : null,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: category.color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                category.icon,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 30,
              child: Center(
                child: Text(
                  category.name,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: selected ? Colors.white : Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
