
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../Firebase/NotifiFirebase.dart';


class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now(); // Initialize _selectedDay
  String title = ''; // Initialize title
  String description = ''; // Initialize description
  TimeOfDay _selectedTime = TimeOfDay.now();
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  void _selectTime(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      setState(() {
        _selectedTime = selectedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Календарь'),
      ),
      body: TableCalendar(
        firstDay: DateTime.utc(2023, 1, 1),
        lastDay: DateTime.utc(2023, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          _showEventInfo(context, selectedDay);
        },
        calendarFormat: _calendarFormat,
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showEventInfo(context, _selectedDay);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showEventInfo(BuildContext context, DateTime selectedDate) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Добавить напоминание'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    title = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Заголовок',
                ),
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    description = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Текст уведомления',
                ),
              ),
              ListTile(
                title: Text('Выберите время уведомления'),
                onTap: () {
                  _selectTime(context);
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                saveNoteToFirebase(title,description,_selectedDay,_selectedTime);
                Navigator.pop(context);
              },
              child: Text('Сохранить'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Отмена'),
            ),
          ],
        );
      },
    );
  }
}
