import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

Future main() async {
  await dotenv.load(fileName: '.env');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ZEGO ZOOM CLONE',
      home: HomePage(),
    );
  }
}

// Generate userId with 6 digit length
// Generate conferenceId with 10 digit length
final String userId = Random().nextInt(900000 + 100000).toString();
final String randomConferenceId =
    (Random().nextInt(1000000000) * 10 + Random().nextInt(10))
        .toString()
        .padLeft(10, '0');

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final conferenceIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color(0xff034ada),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://logos-world.net/wp-content/uploads/2021/03/Zoom-Logo.png',
              width: MediaQuery.of(context).size.width * 0.6,
            ),
            Text('Your UserId:  $userId'),
            const Text('Please test with two or more devices'),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              maxLength: 10,
              keyboardType: TextInputType.number,
              controller: conferenceIdController,
              decoration: const InputDecoration(
                labelText: 'Join a Meeting by Input an ID',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              style: buttonStyle,
              child: const Text('Join a Meeting'),
              onPressed: () => jumpToMeetingPage(
                context,
                conferenceId: conferenceIdController.text,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              style: buttonStyle,
              child: const Text('New Meeting'),
              onPressed: () => jumpToMeetingPage(
                context,
                conferenceId: randomConferenceId,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Go to Meeting Page
  jumpToMeetingPage(BuildContext context, {required String conferenceId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoConferencePage(
          conferenceID: conferenceId,
        ),
      ),
    );
  }
}

// VideoConferencePage Prebuilt UI from ZEGOCLOUD UIKits
class VideoConferencePage extends StatelessWidget {
  final String conferenceID;

  VideoConferencePage({super.key, required this.conferenceID});

  // Read AppID and AppSign from .env file
  // Make sure you replace with your own
  final int appID = int.parse(dotenv.get('ZEGO_APP_ID'));
  final String appSign = dotenv.get('ZEGO_APP_SIGN');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltVideoConference(
        appID:
            appID, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
        appSign:
            appSign, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
        userID: userId,
        userName: 'user_$userId',
        conferenceID: conferenceID,
        config: ZegoUIKitPrebuiltVideoConferenceConfig(
          leaveConfirmDialogInfo: ZegoLeaveConfirmDialogInfo(
            title: "Leave the conference",
            message: "Are you sure to leave the conference?",
            cancelButtonName: "Cancel",
            confirmButtonName: "Confirm",
          ),
        ),
      ),
    );
  }
}
