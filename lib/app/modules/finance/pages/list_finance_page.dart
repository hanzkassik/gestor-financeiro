import 'package:flutter/material.dart';
import 'package:gestor_financeiro/app/domain/models/finance_model.dart';
import 'package:gestor_financeiro/app/shared/helpers/date_format_ddmmyyyy.dart';
import 'package:gestor_financeiro/app/shared/helpers/date_format_mmyyyy.dart';
import 'package:gestor_financeiro/app/shared/helpers/format_moeda.dart';
import 'package:gestor_financeiro/app/modules/finance/controllers/list_finance_controller.dart';
import 'package:gestor_financeiro/app/routes/app_routes.dart';
import 'package:get/get.dart';

class ListFinancePage extends GetView<ListFinanceController> {
  const ListFinancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Finanças')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Text('Menu'),
            ),
            ListTile(
              title: const Text('Preferências do App'),
              onTap: () {
                Get.toNamed(AppRoutes.appPreferences);
              },
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.finances.isEmpty) {
          return const Center(child: Text('Nenhuma finança encontrada.'));
        } else {
          final data = controller.selectedDate.value;
          final primeiroDiaDoMes = DateTime(data.year, data.month, 1);
          final quantidadeDias = DateTime(data.year, data.month + 1, 0).day;

          // Segunda = 1, Domingo = 7
          final deslocamentoInicial = primeiroDiaDoMes.weekday - 1;

          final totalCelulas = deslocamentoInicial + quantidadeDias;

          final dias = List.generate(totalCelulas, (index) {
            if (index < deslocamentoInicial) return null;
            return index - deslocamentoInicial + 1;
          });
          const semana = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab', 'Dom'];

          final itens = controller.finances
              .where(
                (finance) =>
                    finance.date.year == controller.selectedDate.value.year &&
                    finance.date.month == controller.selectedDate.value.month,
              )
              .toList();
          itens.sort(
            (a, b) => (a.description ?? '').compareTo(b.description ?? ''),
          );
          return Column(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Switch(
                      value: controller.calendarIsVisible.value,
                      onChanged: (value) {
                        controller.calendarIsVisible.toggle();
                      },
                      thumbIcon: WidgetStateProperty.all(
                        Icon(
                          controller.calendarIsVisible.value
                              ? Icons.list
                              : Icons.calendar_today_outlined,
                          color: Theme.of(
                            context,
                          ).switchTheme.trackColor!.resolve({}),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Material(
                      elevation: 2,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Scrollbar(
                        controller: controller.dateHorizontalScrollController,
                        thumbVisibility: true,
                        thickness: 2,
                        child: SingleChildScrollView(
                          controller: controller.dateHorizontalScrollController,
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: controller.months.map<Widget>((data) {
                              bool isSelected =
                                  data.year ==
                                      controller.selectedDate.value.year &&
                                  data.month ==
                                      controller.selectedDate.value.month;
                              return InkWell(
                                onTap: () {
                                  controller.onChangeSelectedDate(data);
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
                                        : Theme.of(
                                            context,
                                          ).scaffoldBackgroundColor,
                                    border: Border(
                                      bottom: BorderSide(
                                        color: isSelected
                                            ? Theme.of(
                                                context,
                                              ).secondaryHeaderColor
                                            : Theme.of(
                                                context,
                                              ).scaffoldBackgroundColor,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    dateFormatMmyyyy.format(data),
                                    key:
                                        controller.monthKeys[controller.months
                                            .indexOf(data)],
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
              ),
              if (controller.calendarIsVisible.value)
                Expanded(
                  child: Scrollbar(
                    controller: controller.calendarVerticalScrollController,
                    child: SingleChildScrollView(
                      controller: controller.calendarVerticalScrollController,
                      child: Column(
                        children: [
                          Scrollbar(
                            controller:
                                controller.calendarHorizontalScrollController,
                            child: SingleChildScrollView(
                              controller:
                                  controller.calendarHorizontalScrollController,
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width >
                                              800
                                          ? 800
                                          : MediaQuery.of(context).size.width <
                                                300
                                          ? 300
                                          : MediaQuery.of(context).size.width,
                                      minWidth: 300,
                                      minHeight: 200,
                                      maxHeight: 700,
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                children: semana
                                                    .map(
                                                      (dia) => Expanded(
                                                        child: Center(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  vertical: 6,
                                                                ),
                                                            child: Text(
                                                              dia,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12,
                                                                color: Theme.of(context)
                                                                    .textTheme
                                                                    .titleSmall!
                                                                    .color,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                              GridView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount: dias.length,
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 7,
                                                      childAspectRatio: 1,
                                                    ),
                                                itemBuilder: (context, index) {
                                                  final dia = dias[index];

                                                  if (dia == null) {
                                                    return const SizedBox.shrink();
                                                  }

                                                  final dataDoDia = DateTime(
                                                    data.year,
                                                    data.month,
                                                    dia,
                                                  );

                                                  final isHoje =
                                                      DateTime.now().year ==
                                                          dataDoDia.year &&
                                                      DateTime.now().month ==
                                                          dataDoDia.month &&
                                                      DateTime.now().day ==
                                                          dataDoDia.day;

                                                  return InkWell(
                                                    onTap: () {
                                                      _showPopUpDetailDay(
                                                        dataDoDia,
                                                      );
                                                    },
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                            4,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: isHoje
                                                            ? Theme.of(
                                                                context,
                                                              ).cardColor
                                                            : Theme.of(
                                                                context,
                                                              ).scaffoldBackgroundColor,
                                                        border: Border.all(
                                                          color: Colors
                                                              .grey
                                                              .shade300,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                              4,
                                                            ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              dia.toString(),
                                                              style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: SingleChildScrollView(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: itens
                                                                      .where(
                                                                        (
                                                                          element,
                                                                        ) =>
                                                                            element.date.day ==
                                                                            dia,
                                                                      )
                                                                      .map((e) {
                                                                        return Container(
                                                                          margin: const EdgeInsets.only(
                                                                            top:
                                                                                2,
                                                                          ),
                                                                          child: Row(
                                                                            children: [
                                                                              Expanded(
                                                                                child: Container(
                                                                                  padding: const EdgeInsets.symmetric(
                                                                                    horizontal: 4,
                                                                                    vertical: 2,
                                                                                  ),
                                                                                  decoration: BoxDecoration(
                                                                                    color:
                                                                                        e.category?.color !=
                                                                                            null
                                                                                        ? e.category!.color
                                                                                        : Theme.of(
                                                                                            context,
                                                                                          ).primaryColor,
                                                                                    borderRadius: BorderRadius.circular(
                                                                                      4,
                                                                                    ),
                                                                                  ),
                                                                                  child: Text(
                                                                                    e.description ??
                                                                                        '',
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    style: const TextStyle(
                                                                                      fontSize: 10,
                                                                                      color: Colors.grey,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      })
                                                                      .toList(),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (!controller.calendarIsVisible.value)
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: controller.fetchData,
                    child: Scrollbar(
                      controller: controller.listTileScrollController,
                      thumbVisibility: true,
                      child: ListView.builder(
                        controller: controller.listTileScrollController,
                        itemCount: itens.length,
                        itemBuilder: (context, index) {
                          final finance = itens[index];
                          return Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              constraints: const BoxConstraints(
                                maxWidth: 600,
                                minWidth: 300,
                              ),
                              child: ListTile(
                                onTap: () {
                                  _showPopUpFinanceDetails(finance);
                                },
                                title: Text(finance.description ?? ''),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Parcela: ${finance.installmentNumber ?? 0}/${controller.finances.fold(1, (previousValue, element) => ((element.fatherUuid != null && element.fatherUuid == finance.fatherUuid) || (finance.fatherUuid == null && element.fatherUuid == finance.uuid)) ? previousValue + 1 : previousValue)}',
                                    ),
                                    Text(
                                      'Data vencimento: ${dateFormatDdmmyyyy.format(finance.date)}',
                                    ),
                                    if (finance.calcularAntecipacaoParcela() !=
                                            finance.value &&
                                        finance.calcularAntecipacaoParcela() >
                                            0)
                                      Text(
                                        'Valor antecipação: ${formatMoeda.format(finance.calcularAntecipacaoParcela())}',
                                      ),
                                    Text(
                                      'Valor: ${formatMoeda.format(finance.value)}',
                                    ),
                                  ],
                                ),

                                trailing: IconButton(
                                  onPressed: () {
                                    controller.deleteFinance(finance.uuid);
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              Text(
                'Total: ${formatMoeda.format(itens.fold(0.0, (previousValue, element) => previousValue + element.value))}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // FinanceModel novaFinanca = FinanceModel(
          //   uuid: '123',
          //   description: 'Nova Finança',
          //   value: 307.66,
          //   tax: 6.99,
          //   date: DateTime.now(),
          //   startDate: DateTime(2026, 04, 05),
          //   endDate: DateTime(2028, 02, 05),
          //   createdAt: DateTime.now(),
          // );
          // final antecipacao = novaFinanca.calcularAntecipacaoParcela();
          // print('Antecipação parcela: R\$ ${antecipacao.toStringAsFixed(2)}');
          // final antecipacaoTotal = novaFinanca.calcularAntecipacaoTotal();
          // print(
          //   'Antecipação total: R\$ ${antecipacaoTotal.toStringAsFixed(2)}',
          // );
          await Get.toNamed(AppRoutes.addFinance);
          controller.fetchData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  _showPopUpFinanceDetails(FinanceModel finance) {
    final fatherFinance = controller.finances.firstWhereOrNull(
      (element) =>
          finance.fatherUuid == element.uuid ||
          (finance.fatherUuid == null && element.uuid == finance.uuid),
    );
    final childrenFinances = controller.finances
        .where(
          (element) =>
              element.uuid == fatherFinance?.uuid ||
              element.fatherUuid == fatherFinance?.uuid,
        )
        .toList();
    showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: const Text('Detalhes da Finança'),
          content: Container(
            constraints: BoxConstraints(maxWidth: 600, minWidth: 300),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Descrição: ${finance.description}'),
                  Text(
                    'Data de Vencimento: ${dateFormatDdmmyyyy.format(finance.date)}',
                  ),
                  Text(
                    'Parcela: ${finance.installmentNumber ?? 0}/${controller.finances.fold(1, (previousValue, element) => ((element.fatherUuid != null && element.fatherUuid == finance.fatherUuid) || (finance.fatherUuid == null && element.fatherUuid == finance.uuid)) ? previousValue + 1 : previousValue)}',
                  ),
                  Text('Valor parcela: ${formatMoeda.format(finance.value)}'),
                  Text(
                    'Valor antecipação parcela: ${formatMoeda.format(finance.calcularAntecipacaoParcela())}',
                  ),
                  Text(
                    'Valor total: ${formatMoeda.format(childrenFinances.fold(0.0, (previousValue, element) => previousValue + element.value))}',
                  ),
                  Text(
                    'Valor total pagamento antecipado: ${formatMoeda.format(childrenFinances.fold(0.0, (previousValue, element) => previousValue + element.calcularAntecipacaoParcela()))}',
                  ),
                  Text('Categoria: ${finance.category ?? ''}'),
                  if (childrenFinances.isNotEmpty)
                    const Text(
                      'Parcelas:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  if (childrenFinances.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: childrenFinances
                          .map(
                            (e) => ListTile(
                              title: Text(e.description ?? ''),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Parcela: ${e.installmentNumber ?? 0}/${controller.finances.fold(1, (previousValue, element) => ((element.fatherUuid != null && element.fatherUuid == e.fatherUuid) || (e.fatherUuid == null && element.fatherUuid == e.uuid)) ? previousValue + 1 : previousValue)}',
                                  ),
                                  Text(
                                    'Data vencimento: ${dateFormatDdmmyyyy.format(e.date)}',
                                  ),
                                  if (e.calcularAntecipacaoParcela() !=
                                          e.value &&
                                      e.calcularAntecipacaoParcela() > 0)
                                    Text(
                                      'Valor antecipação: ${formatMoeda.format(e.calcularAntecipacaoParcela())}',
                                    ),
                                  Text('Valor: ${formatMoeda.format(e.value)}'),
                                ],
                              ),

                              trailing: IconButton(
                                onPressed: () {
                                  controller.deleteFinance(e.uuid);
                                },
                                icon: Icon(Icons.delete),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  _showPopUpDetailDay(DateTime date) {
    final financesDay = controller.finances
        .where(
          (finance) =>
              finance.date.day == date.day &&
              finance.date.month == date.month &&
              finance.date.year == date.year,
        )
        .toList();
    financesDay.sort(
      (a, b) => (a.description ?? '').compareTo(b.description ?? ''),
    );
    showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: Text('Finanças do dia ${dateFormatDdmmyyyy.format(date)}'),
          content: Builder(
            builder: (context) {
              if (financesDay.isEmpty) {
                return const Text('Nenhuma finança para este dia');
              }
              return Container(
                constraints: BoxConstraints(maxWidth: 600, minWidth: 300),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: financesDay.map((finance) {
                      return ListTile(
                        title: Text(finance.description ?? ''),
                        subtitle: Text(
                          'Valor: ${formatMoeda.format(finance.value)}',
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}
