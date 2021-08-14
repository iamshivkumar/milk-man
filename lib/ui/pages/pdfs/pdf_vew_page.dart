import 'package:flutter/material.dart';
import 'package:milk_man_app/core/models/file_model.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewPage extends StatelessWidget {
  final FileModel fileModel;

  const PdfViewPage({Key? key, required this.fileModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fileModel.name),
      ),
      body: SfPdfViewer.file(fileModel.file),
    );
  }
}