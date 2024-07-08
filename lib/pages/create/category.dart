import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:finances/components/back_header.dart';
import 'package:finances/components/global/card.dart';
import 'package:finances/components/global/custom_switch.dart';
import 'package:finances/models/category.dart';
import 'package:finances/services/category_service.dart';
import 'package:finances/utils/app_locale.dart';
import 'package:finances/utils/enums.dart';
import 'package:finances/utils/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:uuid/uuid.dart';

class CreateCategory extends StatefulWidget {
  final TransactionType? type;
  const CreateCategory({super.key, this.type});

  @override
  State<CreateCategory> createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _valueEditingController = TextEditingController();
  final CurrencyTextInputFormatter mask = CurrencyTextInputFormatter.currency(symbol: '\$');
  IconData? _icon;
  Color? _color;
  TransactionType _type = TransactionType.expenses;

  final List<IconData> _icons = List.unmodifiable([
    Icons.shopping_cart,
    Icons.local_hospital,
    Icons.shopping_bag,
    Icons.fastfood,
    Icons.local_grocery_store,
    Icons.local_gas_station,
    Icons.school,
    Icons.house,
    Icons.flight,
    Icons.local_offer,
    Icons.directions_car,
    Icons.movie,
    Icons.phone_android,
    Icons.pets,
    Icons.fitness_center,
    Icons.gamepad,
    Icons.paid_sharp,
    Icons.business_center,
  ]);

  final List<Color> _colors = List.unmodifiable([
    const Color(0xffE63946),
    const Color(0xffEF476F),
    const Color(0xffFF577F),
    const Color(0xffEE4266),
    const Color(0xffF15BB5),
    const Color(0xff9B5DE5),
    const Color(0xff72147E),
    const Color(0xff8338EC),
    const Color(0xff8AB17D),
    const Color(0xff06D6A0),
    const Color(0xff2A9D8F),
    const Color(0xff36B5B0),
    const Color(0xff00F5D4),
    const Color(0xff00BBF9),
    const Color(0xff118AB2),
    const Color(0xff4E89AE),
    const Color(0xff264653),
    const Color(0xffFFD700),
    const Color(0xffF1FA3C),
    const Color(0xffFF9F1C),
    const Color(0xffFB5607),
    const Color(0xffFF6D00),
    const Color(0xffE76F51),
    const Color(0xffF4A261),
  ]);

  @override
  void initState() {
    _type = widget.type ?? TransactionType.expenses;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackHeaderWidget(title: AppLocale.newCategory.getString(context)),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomSwitchWidget(
                      options: {
                        TransactionType.expenses: AppLocale.expense.getString(context),
                        TransactionType.income: AppLocale.income.getString(context),
                      },
                      selected: _type,
                      onTap: (value) {
                        setState(() {
                          _type = value as TransactionType;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomCardWidget(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedOpacity(
                          opacity: _titleEditingController.text.isEmpty ? 1 : .5,
                          duration: const Duration(milliseconds: 400),
                          child: Text(
                            AppLocale.name.getString(context),
                            style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          controller: _titleEditingController,
                          onChanged: (value) => setState(
                            () => _titleEditingController,
                          ),
                        ),
                        const SizedBox(height: 20),
                        AnimatedOpacity(
                          opacity: _valueEditingController.text.isEmpty ? 1 : .5,
                          duration: const Duration(milliseconds: 400),
                          child: Text(
                            (_type == TransactionType.expenses
                                    ? AppLocale.spendingEstimate
                                    : AppLocale.earningsEstimate)
                                .getString(context),
                            style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 5),
                        TextField(
                          controller: _valueEditingController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefix: Text(' \$ '),
                          ),
                          inputFormatters: [mask],
                        ),
                      ],
                    )),
                    const SizedBox(height: 10),
                    CustomCardWidget(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedOpacity(
                          opacity: _icon == null ? 1 : .5,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOutQuart,
                          child: Text(
                            AppLocale.icon.getString(context),
                            style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            alignment: WrapAlignment.start,
                            children: [
                              for (var icon in _icons)
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _icon = icon;
                                    });
                                  },
                                  child: Container(
                                    width: (MediaQuery.of(context).size.width - 110) / 6,
                                    height: (MediaQuery.of(context).size.width - 110) / 6,
                                    decoration: BoxDecoration(
                                      color: _icon == icon
                                          ? Theme.of(context).focusColor
                                          : Theme.of(context).colorScheme.tertiary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      icon,
                                      color: Theme.of(context).colorScheme.primaryContainer,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    )),
                    const SizedBox(height: 10),
                    CustomCardWidget(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedOpacity(
                            opacity: _color == null ? 1 : .5,
                            duration: const Duration(milliseconds: 400),
                            child: Text(
                              AppLocale.color.getString(context),
                              style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 18),
                            ),
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            width: double.infinity,
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              alignment: WrapAlignment.start,
                              children: [
                                for (var color in _colors)
                                  InkWell(
                                    onTap: () {
                                      setState(() => _color = color);
                                    },
                                    child: Container(
                                      width: (MediaQuery.of(context).size.width - 110) / 6,
                                      height: (MediaQuery.of(context).size.width - 110) / 6,
                                      decoration: BoxDecoration(
                                        color: color,
                                        shape: BoxShape.circle,
                                      ),
                                      child: _color == color
                                          ? Icon(
                                              Icons.check,
                                              color: Theme.of(context).colorScheme.primaryContainer,
                                            )
                                          : null,
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
              if (_color != null && _icon != null && _titleEditingController.text.isNotEmpty)
                Positioned(
                  bottom: 20,
                  left: 100,
                  right: 100,
                  child: ElevatedButton(
                    onPressed: () async {
                      await getIt<CategoryService>().insertCategory(
                        Category(
                          id: const Uuid().v4(),
                          icon: _icon!,
                          color: _color!,
                          name: _titleEditingController.text,
                          transactionType: _type,
                          plannedOutlay: mask.getDouble(),
                        ),
                      );

                      if (context.mounted) Navigator.pop(context);
                    },
                    child: Text(AppLocale.save.getString(context)),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
