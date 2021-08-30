import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../core/models/file_model.dart';

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