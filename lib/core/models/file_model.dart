import 'dart:io';

class FileModel {
  final String name;
  final File file;
  FileModel({required this.file, required this.name});

  factory FileModel.from(FileSystemEntity fileSystemEntity) {
    return FileModel(
      file: fileSystemEntity as File,
      name: fileSystemEntity.path.split("/").last
    );
  }
}