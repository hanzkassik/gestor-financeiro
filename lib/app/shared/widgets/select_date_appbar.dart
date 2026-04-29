import 'package:flutter/material.dart';
import 'package:gestor_financeiro/app/shared/helpers/date_format_mmyyyy.dart';
import 'package:get/get.dart';

class SelectDateAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Rx<DateTime> selectedDate;
  final List<DateTime> months;
  final Function(DateTime) onChangeSelectedDate;
  const SelectDateAppbar({
    super.key,
    required this.months,
    required this.onChangeSelectedDate,
    required this.selectedDate,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final ScrollController dateHorizontalScrollController = ScrollController();

    return Obx(() {
      List<GlobalKey> monthKeys = List.generate(
        months.length,
        (_) => GlobalKey(),
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final index = months.indexWhere(
          (date) =>
              date.year == selectedDate.value.year &&
              date.month == selectedDate.value.month,
        );
        if (index != -1 && index < monthKeys.length) {
          final context = monthKeys[index].currentContext;
          if (context != null) {
            Scrollable.ensureVisible(
              context,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              alignment: 0.5,
            );
          }
        }
      });
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Material(
              elevation: 2,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Scrollbar(
                controller: dateHorizontalScrollController,
                thumbVisibility: true,
                thickness: 2,
                child: SingleChildScrollView(
                  controller: dateHorizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: months.map<Widget>((data) {
                      int index = months.indexOf(data);
                      bool isSelected =
                          data.year == selectedDate.value.year &&
                          data.month == selectedDate.value.month;
                      return InkWell(
                        onTap: () async {
                          final context = monthKeys[index].currentContext;
                          if (context == null) return;
                          await Scrollable.ensureVisible(
                            context,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                            alignment: 0.5,
                          );
                          onChangeSelectedDate(data);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(
                                    context,
                                  ).primaryColor.withValues(alpha: 0.1)
                                : Theme.of(context).scaffoldBackgroundColor,
                            border: Border(
                              bottom: BorderSide(
                                color: isSelected
                                    ? Theme.of(context).secondaryHeaderColor
                                    : Theme.of(context).scaffoldBackgroundColor,
                                width: 2,
                              ),
                            ),
                          ),
                          child: Text(
                            dateFormatMmyyyy.format(data),
                            key: monthKeys[index],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
