import 'package:final_project_sanbercode/blocs/order_bloc/order_bloc.dart';
import 'package:final_project_sanbercode/const/palllete.dart';
import 'package:final_project_sanbercode/widgets/button_primary.dart';
import 'package:final_project_sanbercode/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';

class FilterForm extends StatefulWidget {
  const FilterForm({super.key});

  @override
  _FilterFormState createState() => _FilterFormState();
}

class _FilterFormState extends State<FilterForm> {
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();
  final List<String> categories = [
    'All',
    'Kretek',
    'Filter',
    'Elektrik',
  ];
  String? selectedCategory = 'All';
  DateRange? selectedDateRange;

  @override
  void initState() {
    super.initState();
    minPriceController.text = '0'; 
    maxPriceController.text = '1000000'; 
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height / 1.8,
      child: Column(
        children: [
          const SizedBox(height: 20),
          DateRangeFormField(
            decoration: InputDecoration(
              label: const Text("Date range picker"),
              hintText: 'Please select a date range',
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Pallete.primary,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Pallete.secondary,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            pickerBuilder: (context, onDateRangeChanged) => datePickerBuilder(
                context, onDateRangeChanged, selectedDateRange),
          ),
          CustomFormField(
            text: 'Min Price',
            controller: minPriceController,
            keyboardType: TextInputType.number,
          ),
          CustomFormField(
            text: 'Max Price',
            controller: maxPriceController,
            keyboardType: TextInputType.number,
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select Category',
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Pallete.primary,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Pallete.secondary,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              value: selectedCategory,
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ButtonPrimary(
                  onPressed: () =>
                      context.read<OrderBloc>().add(ClearFilterEvent()),
                  text: 'Clear Filter',
                  size: const Size(50, 40)),
              ButtonPrimary(
                  onPressed: () {
                    DateTime? startDate = selectedDateRange?.start;
                    DateTime? endDate = selectedDateRange?.end;
                    num minPrice = num.tryParse(minPriceController.text) ?? 0;
                    num maxPrice =
                        num.tryParse(maxPriceController.text) ?? 1000000;

                    context.read<OrderBloc>().add(
                          FilterOrdersEvent(
                            startDate: startDate,
                            endDate: endDate,
                            minPrice: minPrice,
                            maxPrice: maxPrice,
                            category: selectedCategory != 'All'
                                ? selectedCategory
                                : null,
                          ),
                        );
                  },
                  text: 'Apply Filter',
                  size: const Size(50, 40))
            ],
          ),
        ],
      ),
    );
  }

  Widget datePickerBuilder(
    BuildContext context,
    dynamic Function(DateRange?) onDateRangeChanged,
    DateRange? dateRange,
  ) {
    return DateRangePickerWidget(
      doubleMonth: false,
      minimumDateRangeLength: 2,
      initialDateRange: dateRange,
      initialDisplayedDate: dateRange?.start ?? DateTime(2024, 08, 20),
      onDateRangeChanged: (newDateRange) {
        setState(() {
          selectedDateRange = newDateRange;
          onDateRangeChanged(newDateRange);
        });
      },
      height: 350,
      theme: const CalendarTheme(
        selectedColor: Colors.blue,
        dayNameTextStyle: TextStyle(color: Colors.black45, fontSize: 10),
        inRangeColor: Color(0xFFD9EDFA),
        inRangeTextStyle: TextStyle(color: Colors.blue),
        selectedTextStyle: TextStyle(color: Colors.white),
        todayTextStyle: TextStyle(fontWeight: FontWeight.bold),
        defaultTextStyle: TextStyle(color: Colors.black, fontSize: 12),
        radius: 10,
        tileSize: 40,
        disabledTextStyle: TextStyle(color: Colors.grey),
        quickDateRangeBackgroundColor: Color(0xFFFFF9F9),
        selectedQuickDateRangeColor: Colors.blue,
      ),
    );
  }
}
