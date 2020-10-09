import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ng_github/main/bottom/BottomLayout.dart';
import 'package:ng_github/main/env/config_wrapper.dart';
import 'package:ng_github/main/env/dev.dart';
import 'package:ng_github/main/env/env_config.dart';
import 'package:ng_github/main/login/LoginLayout.dart';

void main(){

  //全局异常捕获
  runZoned(() {
    runApp(ConfigWrapper(
      child: BottomLayout(),
      config: EnvConfig.fromJson(config),
    ));
  }, onError: (Object obj, StackTrace stack) {
    print(obj);
    print(stack);
  });
}
