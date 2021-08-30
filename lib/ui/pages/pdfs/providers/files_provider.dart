import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/models/file_model.dart';
import 'path_giver.dart';

final filesProvider = FutureProvider<List<FileModel>>((ref)async{
   final List<FileModel> files = [];
    Directory? appDocDir = await getExternalStorageDirectory();
    if(appDocDir==null){
      return Future.error("Error loading files");
    }
    ref.read(pathProvider).state = appDocDir.path;
    appDocDir.listSync().forEach(
      (element) {
        print(element.path);
        if (element.path.endsWith(".pdf")) {
          print(element.path);
          files.add(FileModel.from(element));
        }
      },
    );
    return files;
});