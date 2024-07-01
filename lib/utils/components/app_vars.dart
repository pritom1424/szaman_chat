import 'package:flutter/material.dart';

class AppVars {
  static var screenSize = const Size(800, 600);

  String getFileFormatFromUrl(String url) {
    // Get the last part of the URL after the last slash
    String fileName = url.split('/').last;

    // Remove query parameters if present
    fileName = fileName.split('?').first;

    // Get the file format
    String fileFormat = fileName.split('.').last;
    return fileFormat;
  }

  String getFileNameFromUrl(String url) {
    // Get the last part of the URL after the last slash
    String fileName = url.split('/').last;

    // Remove query parameters if present
    fileName = fileName.split('?').first;

    // Get the file format
    var lastindex = fileName.lastIndexOf('.');
    String filelastName = fileName.substring(0, lastindex + 1);
    return filelastName;
  }
}
