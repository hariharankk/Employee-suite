import 'package:mark/models/history.dart';
import 'package:flutter/material.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';
import 'package:mark/services/history_socket.dart';
import 'package:mark/services/history socket exit.dart';
import 'package:mark/services/employee3_stop_thread.dart';

class AttendanceHistory extends StatefulWidget {
  final String userId;
  final bool appBarNeeded;

  AttendanceHistory({@required this.userId, this.appBarNeeded = false});

  @override
  _AttendanceHistoryState createState() => _AttendanceHistoryState();
}

class _AttendanceHistoryState extends State<AttendanceHistory> {
  List<List<String>> data;
  history_StreamSocket history_soc = history_StreamSocket();
  HistoryExitSocket history = HistoryExitSocket();
  employee3ExitSocket empexit = employee3ExitSocket();

  List<String> columnNames = ['Check In Time', 'Check Out Time', 'Hours Spent'];
  List<String> rowNames;

  @override
  void initState() {
    columnNames = ['Check In Time', 'Check Out Time', 'Hours Spent'];
    super.initState();
    empexit.Stopthread();
    history_soc.openingapprovalconnectAndListen(widget.userId);
  }

  void dispose() {
    history.Stopthread();
    print('dispose page one');
    super.dispose();
  }

  /// Make a 2-d array of the data
  _makeData(List<dynamic> snapshots) {
    var temp = new List<List<String>>();
    var rows = new List<String>();

    int i = 0;
    for (var snapshot in snapshots) {
      List<String> row = _makeDataItem(snapshot);
      rows.add(row[0]);
      temp.add(new List<String>());
      temp[i].add(row[1]);
      temp[i].add(row[2]);
      temp[i].add(row[3]);
      ++i;
    }
    rowNames = rows;

    return temp;
  }

  //// Extract Data from snapshot and convert it into a LIST
  List<String> _makeDataItem(Map<dynamic,dynamic> data) {
    final history = History.fromMap(data);

    DateTime checkIn = DateTime.parse(history.checkIn);
    DateTime checkOut;
    if (history.checkOut != "-") checkOut = DateTime.parse(history.checkOut);
    String hrs = history.hrsSpent;

    String date = checkIn.day.toString() +
        "/" +
        checkIn.month.toString() +
        "/" +
        checkIn.year.toString();
    String inTime = checkIn.hour.toString() + ":" + checkIn.minute.toString();
    String outTime = history.checkOut == "-"
        ? "-"
        : checkOut.hour.toString() + ":" + checkOut.minute.toString();

    List<String> dateData = new List<String>(4);
    dateData[0] = date;
    dateData[1] = inTime;
    dateData[2] = outTime;
    dateData[3] = hrs;
    return dateData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBarNeeded
          ? AppBar(title: Text("Attendance History"))
          : null,
      body: StreamBuilder(
        stream: history_soc.getResponse,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          data = _makeData(snapshot.data);

          return StickyHeadersTable(
            columnsLength: 3,
            rowsLength: snapshot.data.length,
            columnsTitleBuilder: (i) => TableCell.stickyRow(
              columnNames[i],
              textStyle: TextStyle(fontSize: 18.0),
            ),
            rowsTitleBuilder: (i) => TableCell.stickyColumn(
              rowNames[i],
              textStyle: TextStyle(fontSize: 18.0),
            ),
            contentCellBuilder: (i, j) => TableCell.content(
              data[j][i],
              textStyle: TextStyle(fontSize: 16.0),
            ),
            legendCell: TableCell.legend(
              'Date',
              textStyle: TextStyle(fontSize: 20.0),
            ),
            cellFit: BoxFit.cover,
            cellDimensions: CellDimensions(
              contentCellHeight: 74.0,
              contentCellWidth: 100.0,
              stickyLegendHeight: 72.0,
              stickyLegendWidth: 104.0,
            ),
          );
        },
      ),
    );
  }
}

/// Class for Defining decoration in [Sticky Table Headers ]
class TableCell extends StatelessWidget {
  TableCell.content(
    this.text, {
    this.textStyle,
    this.cellDimensions = const CellDimensions(
      contentCellHeight: 74.0,
      contentCellWidth: 100.0,
      stickyLegendHeight: 72.0,
      stickyLegendWidth: 104.0,
    ),
    this.colorBg = Colors.white,
    this.onTap,
  })  : cellWidth = cellDimensions.contentCellWidth,
        cellHeight = cellDimensions.contentCellHeight,
        _colorHorizontalBorder = Colors.amber,
        _colorVerticalBorder = Colors.black38,
        _textAlign = TextAlign.center,
        _padding = EdgeInsets.zero;

  TableCell.legend(
    this.text, {
    this.textStyle,
    this.cellDimensions = const CellDimensions(
      contentCellHeight: 74.0,
      contentCellWidth: 100.0,
      stickyLegendHeight: 72.0,
      stickyLegendWidth: 104.0,
    ),
    this.colorBg = Colors.amber,
    this.onTap,
  })  : cellWidth = cellDimensions.stickyLegendWidth,
        cellHeight = cellDimensions.stickyLegendHeight,
        _colorHorizontalBorder = Colors.white,
        _colorVerticalBorder = Colors.amber,
        _textAlign = TextAlign.start,
        _padding = EdgeInsets.zero;

  TableCell.stickyRow(
    this.text, {
    this.textStyle,
    this.cellDimensions = const CellDimensions(
      contentCellHeight: 74.0,
      contentCellWidth: 100.0,
      stickyLegendHeight: 72.0,
      stickyLegendWidth: 104.0,
    ),
    this.colorBg = Colors.amber,
    this.onTap,
  })  : cellWidth = cellDimensions.contentCellWidth,
        cellHeight = cellDimensions.stickyLegendHeight,
        _colorHorizontalBorder = Colors.white,
        _colorVerticalBorder = Colors.amber,
        _textAlign = TextAlign.center,
        _padding = EdgeInsets.all(10.0);

  TableCell.stickyColumn(
    this.text, {
    this.textStyle,
    this.cellDimensions = const CellDimensions(
      contentCellHeight: 74.0,
      contentCellWidth: 100.0,
      stickyLegendHeight: 72.0,
      stickyLegendWidth: 104.0,
    ),
    this.colorBg = Colors.white,
    this.onTap,
  })  : cellWidth = cellDimensions.stickyLegendWidth,
        cellHeight = cellDimensions.contentCellHeight,
        _colorHorizontalBorder = Colors.amber,
        _colorVerticalBorder = Colors.black38,
        _textAlign = TextAlign.start,
        _padding = EdgeInsets.zero;

  final CellDimensions cellDimensions;

  final String text;
  final Function onTap;

  final double cellWidth;
  final double cellHeight;

  final Color colorBg;
  final Color _colorHorizontalBorder;
  final Color _colorVerticalBorder;

  final TextAlign _textAlign;
  final EdgeInsets _padding;

  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cellWidth,
        height: cellHeight,
        padding: _padding,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                width: 80.0,
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: textStyle,
                  maxLines: 2,
                  textAlign: _textAlign,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 1.1,
              color: _colorVerticalBorder,
            ),
          ],
        ),
        decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: _colorHorizontalBorder),
              right: BorderSide(color: _colorHorizontalBorder),
            ),
            color: colorBg),
      ),
    );
  }
}
