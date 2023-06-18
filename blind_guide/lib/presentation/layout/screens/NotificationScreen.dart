import 'package:blind_guide/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late FlutterLocalNotificationsPlugin _notifications;
  List<NotificationSchedule> _schedules = [];

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _loadSchedules();
  }

  void _initializeNotifications() {
    _notifications = FlutterLocalNotificationsPlugin();
    final androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );
    _notifications.initialize(initializationSettings);
  }

  Future<void> _scheduleNotification(
      int id, String title, DateTime scheduledTime) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'schedule_channel',
      'Scheduled Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _notifications.schedule(
      id,
      title,
      'Your scheduled event is due!',
      scheduledTime,
      platformChannelSpecifics,
      payload: scheduledTime.toString(), // Store the scheduled time as payload
    );

    setState(() {
      _schedules.add(
        NotificationSchedule(
          id: id,
          title: title,
          time: scheduledTime,
        ),
      );
    });
  }

  Future<void> _cancelNotification(int id) async {
    await _notifications.cancel(id);

    setState(() {
      _schedules.removeWhere((schedule) => schedule.id == id);
    });
  }

  Future<void> _loadSchedules() async {
    final pendingNotifications =
    await _notifications.pendingNotificationRequests();

    setState(() {
      _schedules = pendingNotifications
          .map(
            (notification) {
          final scheduledTimeStr = notification.payload;
          final scheduledTime =
              DateTime.tryParse(scheduledTimeStr ?? '') ?? DateTime.now();

          return NotificationSchedule(
            id: notification.id,
            title: notification.title ?? '',
            time: scheduledTime,
          );
        },
      )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: Dimensions.p20),
              child: Row(
                children: [
                  IconButton(onPressed: () {
                    Navigator.of(context).pop();
                  }, icon: Icon(Icons.keyboard_arrow_right,size: 30,),color: Colors.teal[600],),
                  Text("الإشعارات",style: TextStyle(color: Colors.teal,fontSize: Dimensions.p22,fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            if (_schedules.length > 0)
              Expanded(
                child: ListView.builder(
                  itemCount: _schedules.length,
                  itemBuilder: (context, index) {
                    final schedule = _schedules[index];
                    return ListTile(
                      title: Text(schedule.title),
                      subtitle: Text(schedule.time.toString()),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _cancelNotification(schedule.id),
                      ),
                    );
                  },
                ),
              ),
            if (_schedules.length == 0)
              Container(
                color: Colors.teal[100],
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(vertical: Dimensions.p20),
                padding: EdgeInsets.all(10),
                child: Center(child: Text('لا يوجد أي تنبيهات مجدولة')),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                child: Text('إنشاء تنبيه',style:TextStyle(fontSize: Dimensions.p20),),
                onPressed: () => _showScheduleDialog(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showScheduleDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) => ScheduleDialog(),
    );

    if (result != null) {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000; // Unique ID
      _scheduleNotification(id, result.title, result.time);
    }
  }
}

class ScheduleDialog extends StatefulWidget {
  @override
  _ScheduleDialogState createState() => _ScheduleDialogState();
}

class _ScheduleDialogState extends State<ScheduleDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  late DateTime _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: Text('جدولة تنبيه',style: TextStyle(color: Colors.teal),),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'العنوان',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'من فضلك أدخل عنوان التنبيه';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(style: ElevatedButton.styleFrom(
                      primary: Colors.white, ),
                      child: Text(
                        'تحديد التاريخ',style: TextStyle(color: Colors.teal),
                      ),

                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _selectedDateTime,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365)),
                        );
                        if (date != null) {
                          setState(() {
                            _selectedDateTime = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              _selectedDateTime.hour,
                              _selectedDateTime.minute,
                            );
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child:  ElevatedButton(style: ElevatedButton.styleFrom(
                      primary: Colors.white, ),
                      child: Text(
                        'تحديد الوقت',style: TextStyle(color: Colors.teal),
                      ),
                      onPressed: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
                        );
                        if (time != null) {
                          setState(() {
                            _selectedDateTime = DateTime(
                              _selectedDateTime.year,
                              _selectedDateTime.month,
                              _selectedDateTime.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('إلغاء',style: TextStyle(color: Colors.teal),),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(style: ElevatedButton.styleFrom(
            primary: Colors.teal, ),

            child: Text('إنشاء',style: TextStyle(color: Colors.white),),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final result = ScheduleResult(
                  title: _titleController.text,
                  time: _selectedDateTime,
                );
                Navigator.pop(context, result);
              }
            },
          ),
        ],
      ),
    );
  }
}

class NotificationSchedule {
  final int id;
  final String title;
  final DateTime time;

  NotificationSchedule({
    required this.id,
    required this.title,
    required this.time,
  });
}

class ScheduleResult {
  final String title;
  final DateTime time;

  ScheduleResult({
    required this.title,
    required this.time,
  });
}