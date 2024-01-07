import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void saveNoteToFirebase(String title, String description, DateTime selectedDate, TimeOfDay selectedTime) {
  DateTime notificationDateTime = DateTime(
    selectedDate.year,
    selectedDate.month,
    selectedDate.day,
    selectedTime.hour,
    selectedTime.minute,
  );

  FirebaseFirestore.instance.collection('notes').add({
    'title': title,
    'description': description,
    'date': selectedDate,
    'notification_time': notificationDateTime,
  }).then((value) {
    print("Note added successfully with ID: ${value.id}");
   // _scheduleNotification(value.id, title, description, notificationDateTime);
  }).catchError((error) {
    print("Failed to add note: $error");
  });
}
void _scheduleNotification() {
  // Implement notification scheduling logic here
}
