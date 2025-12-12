import 'package:flutter/material.dart';
import 'package:flutterflow_custom_widget/user_challenge_widget.dart';

class UserChallengeScreen extends StatefulWidget {
  const UserChallengeScreen({super.key});

  @override
  State<UserChallengeScreen> createState() => _UserChallengeScreenState();
}

class _UserChallengeScreenState extends State<UserChallengeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back,color: Colors.white,),),
      ),
      body: UserChallengeWidget(),
    );
  }
}