import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../../widgets/primaryText.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: Dimensions.p20,
              ),
              PrimaryText(
                text: Constants.checkInternetConnection_STR,
              ),
              Image.asset(Constants.noInternet),
            ],
          ),
        ),
      ),
    );
  }
}
