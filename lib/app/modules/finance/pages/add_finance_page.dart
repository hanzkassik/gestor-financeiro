import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gestor_financeiro/app/domain/models/category_model.dart';
import 'package:gestor_financeiro/app/helpers/date_format_ddmmyyyy.dart';
import 'package:gestor_financeiro/app/helpers/mask_text_date.dart';
import 'package:gestor_financeiro/app/modules/finance/controllers/add_finance_controller.dart';
import 'package:get/get.dart';

class AddFinancePage extends GetView<AddFinanceController> {
  const AddFinancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Finança')),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const SizedBox(height: 16),
                _textField(
                  label: 'Descrição',
                  controller: controller.descriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'A descrição é obrigatória';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _textField(
                  label: 'Valor',
                  controller: controller.valueController,
                  keyboardType: TextInputType.number,
                  prefix: const Text('R\$ '),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O valor é obrigatório';
                    }
                    final parsedValue = double.tryParse(
                      value.replaceAll(',', '.'),
                    );
                    if (parsedValue == null) {
                      return 'Digite um número válido para o valor';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Autocomplete<CategoryModel>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    return controller.categories.where((
                      CategoryModel category,
                    ) {
                      return category.name.toLowerCase().contains(
                        textEditingValue.text.toLowerCase(),
                      );
                    }).toList();
                  },
                  displayStringForOption: (CategoryModel option) => option.name,
                  onSelected: (CategoryModel selection) {
                    controller.selectedCategory = selection;
                  },
                  optionsViewBuilder: (context, onSelected, options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 2,
                        child: Container(
                          constraints: BoxConstraints(maxHeight: 100),
                          color: Colors.white,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: options.length + 1,
                            itemBuilder: (context, index) {
                              if (index == options.length) {
                                return ListTile(
                                  title: Text('Adicionar nova categoria'),
                                  onTap: () {},
                                );
                              }
                              final CategoryModel option = options.elementAt(
                                index,
                              );
                              return ListTile(
                                title: Text(option.name),
                                onTap: () {
                                  onSelected(option);
                                  FocusScope.of(context).unfocus();
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  fieldViewBuilder:
                      (
                        context,
                        textEditingController,
                        focusNode,
                        onFieldSubmitted,
                      ) => _textField(
                        label: 'Categoria (opcional)',
                        focusNode: focusNode,
                        controller: textEditingController,
                        validator: (value) {
                          return null;
                        },
                      ),
                ),
                const SizedBox(height: 16),
                _textField(
                  label: 'Taxa (opcional)',
                  controller: controller.taxController,
                  keyboardType: TextInputType.number,
                  suffixIcon: const Icon(Icons.percent),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final parsedValue = double.tryParse(
                        value.replaceAll(',', '.'),
                      );
                      if (parsedValue == null) {
                        return 'Digite um número válido para a taxa';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _textField(
                  label: 'Data',
                  controller: controller.dateController,
                  keyboardType: TextInputType.datetime,
                  inputFormatters: [maskTextDate],
                  suffixIcon: IconButton(
                    onPressed: () async {
                      final response = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (response != null) {
                        controller.dateController.text = dateFormatDdmmyyyy
                            .format(response);
                      }
                    },
                    icon: Icon(Icons.calendar_month),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'A data é obrigatória';
                    }
                    try {
                      dateFormatDdmmyyyy.parseStrict(value);
                    } catch (e) {
                      return 'Digite uma data válida no formato dd/MM/yyyy';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _textField(
                  label: 'Data de inicio (opcional)',
                  controller: controller.startDateController,
                  keyboardType: TextInputType.datetime,
                  inputFormatters: [maskTextDate],
                  suffixIcon: IconButton(
                    onPressed: () async {
                      final response = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (response != null) {
                        controller.startDateController.text = dateFormatDdmmyyyy
                            .format(response);
                      }
                    },
                    icon: Icon(Icons.calendar_month),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null;
                    }
                    try {
                      dateFormatDdmmyyyy.parseStrict(value);
                    } catch (e) {
                      return 'Digite uma data válida no formato dd/MM/yyyy';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _textField(
                  label: 'Data de fim (opcional)',
                  controller: controller.endDateController,
                  keyboardType: TextInputType.datetime,
                  inputFormatters: [maskTextDate],
                  suffixIcon: IconButton(
                    onPressed: () async {
                      final response = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (response != null) {
                        controller.endDateController.text = dateFormatDdmmyyyy
                            .format(response);
                      }
                    },
                    icon: Icon(Icons.calendar_month),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null;
                    }
                    try {
                      dateFormatDdmmyyyy.parseStrict(value);
                    } catch (e) {
                      return 'Digite uma data válida no formato dd/MM/yyyy';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    await controller.saveFinance();
                  },
                  child: const Text('Salvar'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _textField({
    required String label,
    required TextEditingController controller,
    FocusNode? focusNode,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    Widget? suffixIcon,
    Widget? prefix,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        prefix: prefix,
        border: const OutlineInputBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
