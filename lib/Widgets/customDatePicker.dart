import 'package:employees_hub/Utils/color.dart';
import 'package:employees_hub/Widgets/reusable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final bool isEnd;
  final DateTime? initialDate;

  const CustomDatePicker({
    Key? key,
    required this.onDateSelected,
    this.isEnd = false,
    this.initialDate,
  }) : super(key: key);

  static void show(
      BuildContext context, {
        required Function(DateTime) onDateSelected,
        bool isEnd = false,
        DateTime? initialDate,
      }) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomDatePicker(
        onDateSelected: onDateSelected,
        isEnd: isEnd,
        initialDate: initialDate,
      ),
    );
  }

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateRangePickerController _controller;
  late String _selectedDateText;
  String sv='Today';
  @override
  void initState() {
    super.initState();
    _controller = DateRangePickerController();
    if (widget.initialDate != null) {
      _controller.selectedDate = widget.initialDate;
      _selectedDateText = _formatDate(widget.initialDate!);
    } else {
      _selectedDateText = _formatDate(DateTime.now());
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yy').format(date);
  }

  void _selectDate(DateTime date) {
    setState(() {
      _controller.selectedDate = date;
      _selectedDateText = _formatDate(date);
    });
  }

  Widget _buildQuickSelectButton(String text, DateTime date,bool selected) {
    return Expanded(
      child: TextButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          backgroundColor: WidgetStateProperty.all<Color>(!selected?AppColors.primaryLightColor:AppColors.primaryColor),
          foregroundColor: WidgetStateProperty.all<Color>(!selected?AppColors.primaryColor:Colors.white),
        ),
        onPressed: () {
          _selectDate(date);
          sv=text;
        },
        child: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      child: Container(
        height: 500,
        decoration:BoxDecoration(
            color:Colors.white,
          borderRadius:BorderRadius.circular(15)
        ),
        child: Column(
          children: [
            Padding(
              padding:EdgeInsets.all(16),
              child:Column(
                children: [
                  widget.isEnd?Row(
                    children: [
                      _buildQuickSelectButton(
                          'No Date',
                          DateTime.now(),sv=='No Date'
                      ),
                      const SizedBox(width: 10),
                      _buildQuickSelectButton(
                        'Today',
                        DateTime.now(),sv== 'Today',
                      ),
                    ],
                  ):
                  Row(
                    children: [
                      _buildQuickSelectButton(
                        'Today',
                        DateTime.now(),sv== 'Today',
                      ),
                      const SizedBox(width: 10),
                      _buildQuickSelectButton(
                          'Next Monday',
                          DateTime.now().add(Duration(days: (8 - DateTime.now().weekday) % 7),),
                          sv=='Next Monday'
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  widget.isEnd?SizedBox():Row(
                    children: [
                      _buildQuickSelectButton(
                          'Next Tuesday',
                          DateTime.now().add(
                            Duration(days: (9 - DateTime.now().weekday) % 7),
                          ),
                          sv=='Next Tuesday'
                      ),
                      const SizedBox(width: 10),
                      _buildQuickSelectButton(
                          'After 1 Week',
                          DateTime.now().add(const Duration(days: 7)),
                          sv=='After 1 Week'
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            Expanded(
              child: SfDateRangePicker(
                maxDate:widget.isEnd?DateTime.now():null,
                controller: _controller,
                backgroundColor: Colors.white,
                todayHighlightColor: const Color(0xffc4ecfc),
                selectionColor: Colors.blue,
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  if (args.value is DateTime) {
                    setState(() {
                      _selectedDateText = _formatDate(args.value);
                    });
                  }
                },
                monthViewSettings: const DateRangePickerMonthViewSettings(
                  dayFormat: 'EEE',
                ),
                headerStyle: const DateRangePickerHeaderStyle(
                  backgroundColor: Colors.white,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey.withOpacity(0.5)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/calendar.svg",
                      ),
                      SizedBox(width: 8),
                      Text(_selectedDateText),
                    ],
                  ),
                  Row(
                    children: [
                      Reusable().button("Cancel",AppColors.buttonLightColor,(){
                        Navigator.pop(context);
                      }),
                      const SizedBox(width: 10),
                      Reusable().button("Save",AppColors.primaryColor,(){
                        widget.onDateSelected(_controller.selectedDate!);
                        Navigator.pop(context);
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}