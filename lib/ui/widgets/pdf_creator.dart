import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nagamanager/providers/chart_provider.dart';
import 'package:nagamanager/shared/helper.dart';
import 'package:nagamanager/shared/shared.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:supercharged/supercharged.dart';

class GeneratePDFWidget extends StatelessWidget {
  const GeneratePDFWidget(this.title, {Key? key}) : super(key: key);

  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 55.h,
              child: Row(
                children: [
                  SizedBox(
                    width: 16.w,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: "#E8ECF2".toColor(), elevation: 0),
                    child: Row(
                      children: [
                        Icon(Iconsax.arrow_square_left, color: text, size: 20),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          'Back',
                          style: normalText.copyWith(color: text),
                        )
                      ],
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, "/detail-chart");
                    },
                  ),
                ],
              ),
            ),
            Expanded(
                child: PdfPreview(
              build: (format) => _generatePdf(format, title, context),
              canChangeOrientation: false,
              canDebug: false,
            ))
          ],
        ),
      ),
    );
  }

  Future<Uint8List> _generatePdf(
      PdfPageFormat format, String title, context) async {
    ChartProvider chartProvider =
        Provider.of<ChartProvider>(context, listen: false);
    final pdf = pw.Document(
      version: PdfVersion.pdf_1_5,
      compress: true,
      author: "Nagatech",
      title: "Laporan Stock Barang",
      creator: "Nagatech",
    );
    final font = await PdfGoogleFonts.poppinsMedium();
    final fontLight = await PdfGoogleFonts.poppinsLight();
    List<BodyTable> listBodyTable = List<BodyTable>.from(chartProvider
        .chartDetailBarangModel!.historyDetail!
        .map((e) => BodyTable(
            tanggal: e.tanggal,
            stock_out: e.stockOut,
            stock_in: e.stockIn,
            available_stock: e.available)));
    var listData = chunkLength(31, listBodyTable);
    for (var i = 0; i < listData.length; i++) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pw.Column(
              children: [
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Laporan Stock Barang",
                          style: pw.TextStyle(font: font)),
                      pw.Text(
                          "Periode ${chartProvider.startDate} - ${chartProvider.endDate}",
                          style: pw.TextStyle(font: fontLight, fontSize: 9.sp)),
                      pw.SizedBox(height: 20),
                      pw.Text("Nama Barang : ${chartProvider.barangSelected}",
                          style: pw.TextStyle(font: font, fontSize: 11.sp)),
                      pw.SizedBox(height: 10),
                      pw.Table(
                          columnWidths: {
                            0: pw.FixedColumnWidth(50),
                            1: pw.FixedColumnWidth(50),
                            2: pw.FixedColumnWidth(50),
                            3: pw.FixedColumnWidth(50),
                          },
                          children: [
                            headerTable()
                          ],
                          border: pw.TableBorder.all(
                              color: PdfColor.fromHex("000"))),
                      pw.ListView.builder(
                          itemBuilder: (context, index) {
                            return pw.Container(
                                child: pw.Table(
                                    columnWidths: {
                                  0: pw.FixedColumnWidth(50),
                                  1: pw.FixedColumnWidth(50),
                                  2: pw.FixedColumnWidth(50),
                                  3: pw.FixedColumnWidth(50),
                                },
                                    children: [
                                  bodyTable(
                                      tanggal: Helper.formatDate(
                                          listData[i][index].tanggal),
                                      stock_out: listData[i][index].stock_out,
                                      available_stock:
                                          listData[i][index].available_stock,
                                      stock_in: listData[i][index].stock_in)
                                ],
                                    border: pw.TableBorder.all(
                                        color: PdfColor.fromHex("000"))));
                          },
                          itemCount: listData[i].length)
                    ])
              ],
            );
          },
        ),
      );
    }

    return pdf.save();
  }

  pw.TableRow headerTable() {
    return pw.TableRow(children: [
      pw.Container(
          height: 20,
          child:
              pw.Row(children: [pw.SizedBox(width: 3.w), pw.Text("Tanggal")])),
      pw.Container(
          height: 20,
          child:
              pw.Row(children: [pw.SizedBox(width: 3.w), pw.Text("Stock In")])),
      pw.Container(
          height: 20,
          child: pw.Row(
              children: [pw.SizedBox(width: 3.w), pw.Text("Stock Out")])),
      pw.Container(
          height: 20,
          child: pw.Row(
              children: [pw.SizedBox(width: 3.w), pw.Text("Available Stock")])),
    ]);
  }

  pw.TableRow bodyTable({tanggal, stock_in, stock_out, available_stock}) {
    return pw.TableRow(children: [
      pw.Container(
          height: 20,
          child: pw.Row(children: [
            pw.SizedBox(width: 3.w),
            pw.Text(tanggal.toString())
          ])),
      pw.Container(
          height: 20,
          child: pw.Row(children: [
            pw.SizedBox(width: 3.w),
            pw.Text(stock_in.toString())
          ])),
      pw.Container(
          height: 20,
          child: pw.Row(children: [
            pw.SizedBox(width: 3.w),
            pw.Text(stock_out.toString())
          ])),
      pw.Container(
          height: 20,
          child: pw.Row(children: [
            pw.SizedBox(width: 3.w),
            pw.Text(available_stock.toString())
          ])),
    ]);
  }
}

class BodyTable {
  String tanggal;
  int stock_in;
  int stock_out;
  int available_stock;

  BodyTable(
      {required this.tanggal,
      required this.stock_out,
      required this.stock_in,
      required this.available_stock});
}

List<dynamic> chunkLength(int length, dynamic array) {
  var chunks = [];
  int chunkSize = length;
  for (var i = 0; i < array.length; i += chunkSize) {
    chunks.add(array.sublist(
        i, i + chunkSize > array.length ? array.length : i + chunkSize));
  }
  return chunks;
}
