import 'dart:io';

import 'package:flutter/material.dart';

ImageProvider imageHandle(String? src) {
  if (src == null) {
    return const AssetImage(
      "assets/images/profile_avatar.jpg",
    );
  } else if (src.isEmpty) {
    return const AssetImage(
      "assets/images/profile_avatar.jpg",
    );
  } else {
    return FileImage(File(src));
  }
}
