import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';


class PdfViewerPage extends StatefulWidget {

  final String pdfUrl,title; // Provide the URL of your PDF

  const PdfViewerPage({Key? key, required this.pdfUrl, required this.title}) : super(key: key);

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  late File Pfile;


  @override
  void initState() {
    super.initState();
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Color(0xff254ba0),
      ),
      body: Center(
          child: pdfviewer(widget.pdfUrl)
          // child:  SfPdfViewer.network(
          //   widget.pdfUrl,
          // ),
        ),
    );
  }
  
  Widget pdfviewer(String pdf){
    if (widget.pdfUrl.endsWith('.pdf')) {
      return SfPdfViewer.network(
        widget.pdfUrl,
      );
    }else{
      return WebView(
        initialUrl: widget.pdfUrl,
        javascriptMode: JavascriptMode.unrestricted,
      );
    }

  }
  
}