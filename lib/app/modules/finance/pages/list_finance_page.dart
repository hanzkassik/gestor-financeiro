import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gestor_financeiro/app/helpers/date_format_ddmmyyyy.dart';
import 'package:gestor_financeiro/app/helpers/date_format_mmyyyy.dart';
import 'package:gestor_financeiro/app/helpers/format_moeda.dart';
import 'package:gestor_financeiro/app/modules/finance/controllers/list_finance_controller.dart';
import 'package:gestor_financeiro/app/routes/app_routes.dart';
import 'package:get/get.dart';

class ListFinancePage extends GetView<ListFinanceController> {
  const ListFinancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Finanças')),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Material(
                      elevation: 2,
                      child: Scrollbar(
                        controller: controller.scrollControllerHorizontal,
                        thumbVisibility: true,
                        thickness: 2,
                        child: SingleChildScrollView(
                          controller: controller.scrollControllerHorizontal,
                          scrollDirection: Axis.horizontal,
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
                                        ? Colors.blue.shade50
                                        : Colors.transparent,
                                    border: Border(
                                      bottom: BorderSide(
                                        color: isSelected
                                            ? Colors.blue
                                            : Colors.transparent,
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
                  IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(
                          text: json.encode(
                            controller.finances.map((e) => e.toMap()).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Container(
                width: 600,
                child: Column(
                  children: [
                    Row(
                      children: semana
                          .map(
                            (dia) => Expanded(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  child: Text(
                                    dia,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.grey,
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
                      physics: const NeverScrollableScrollPhysics(),
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

                        final dataDoDia = DateTime(data.year, data.month, dia);

                        final isHoje =
                            DateTime.now().year == dataDoDia.year &&
                            DateTime.now().month == dataDoDia.month &&
                            DateTime.now().day == dataDoDia.day;

                        return InkWell(
                          onTap: () {},
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isHoje
                                  ? Colors.blue.shade50
                                  : Colors.white,
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dia.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: itens
                                            .where(
                                              (element) =>
                                                  element.date.day == dia,
                                            )
                                            .map((e) {
                                              return Container(
                                                margin: const EdgeInsets.only(
                                                  top: 2,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 4,
                                                              vertical: 2,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: Colors
                                                              .green
                                                              .shade100,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                4,
                                                              ),
                                                        ),
                                                        child: Text(
                                                          e.description ?? '',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 8,
                                                                color:
                                                                    Colors.grey,
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
              Expanded(
                child: RefreshIndicator(
                  onRefresh: controller.fetchData,
                  child: Scrollbar(
                    controller: controller.scrollController,
                    thumbVisibility: true,
                    child: ListView.builder(
                      controller: controller.scrollController,
                      itemCount: itens.length,
                      itemBuilder: (context, index) {
                        final finance = itens[index];
                        return Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            constraints: const BoxConstraints(
                              maxWidth: 600,
                              minWidth: 300,
                            ),
                            child: ListTile(
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
                                      finance.calcularAntecipacaoParcela() > 0)
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
}
