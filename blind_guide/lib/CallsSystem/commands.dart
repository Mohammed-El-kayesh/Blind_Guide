import 'package:blind_guide/bloc/emergencyCallCubit/emergency_CallCubit.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Command {
  static final commands = [
    one,
    two,
    three,
    four,
    five,
  ];

  static const one = 'one', two = 'two', three = 'three',four = 'four',five = 'five';
}

class Utils {

  static FlutterTts flutterTts = FlutterTts();


  Utils();
  static String _executeCommand({
    required String text,
    required String command,
  }) {
    final commandIndex = text.indexOf(command);
    final finalIndex = commandIndex + command.length;

    if (commandIndex == -1) {
      return '';
    } else {
      return text.substring(finalIndex).trim();
    }
  }

  static Future callPhoneNumber(String body, int index, context) async {
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setLanguage("ar-EG");
    await flutterTts.speak('الاتصال بي ${emergencyCallCubit.get(context).contacts[index]['name']}').then((value) async => await FlutterPhoneDirectCaller.callNumber(emergencyCallCubit.get(context).contacts[index]['number']));


  }




  static Future<void> scanVoicedText(String voicedText, context) async {
    final text = voicedText.toLowerCase();

    if (text.contains(Command.one.toString()) ||  text.contains(1.toString()) ) {
      final body = _executeCommand(text: text, command: Command.one);
      callPhoneNumber(body,0, context);
    } else if (text.contains(Command.two.toString()) ||  text.contains(2.toString())) {
      final body = _executeCommand(text: text, command: Command.one);
      callPhoneNumber(body,1, context);
    } else if (text.contains(Command.three.toString()) ||  text.contains(3.toString()) || text.contains('siri')) {
      final body = _executeCommand(text: text, command: Command.one);
      callPhoneNumber(body,2, context);
    } else if (text.contains(Command.four.toString()) ||  text.contains(4.toString()) || text.contains('for')) {
      final body = _executeCommand(text: text, command: Command.one);
      callPhoneNumber(body,3, context);
    } else if (text.contains(Command.five.toString()) ||  text.contains(5.toString())) {
      final body = _executeCommand(text: text, command: Command.one);
      callPhoneNumber(body,4, context);
    } else
    {
      await flutterTts.speak('رقم غير موجود، أو نطق غير صحيح، حاول مرة أخرى');
    }
  }
}
