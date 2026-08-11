import 'dart:io';
import 'package:dio/dio.dart';

class MediaFormModel {
  final File file;
  final String mediaType;

  MediaFormModel({
    required this.file,
    required this.mediaType,
  });

  Future<FormData> toFormData() async {
    final data = <String, dynamic>{};

    // Add media type
    data["media_type"] = mediaType;

    // Add file
    data["file"] = await MultipartFile.fromFile(
      file.path,
      filename: file.path.split('/').last,
    );

    return FormData.fromMap(data);
  }
}