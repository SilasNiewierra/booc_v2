import 'package:booc/models/analytics_model.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';

class AnalyticsScreen extends StatefulWidget {
  final bool animate;

  AnalyticsScreen({this.animate});

  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context, size),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [],
        backgroundColor: Colors.transparent);
  }

  Widget _buildBody(BuildContext context, Size size) {
    final analyticsModel = Provider.of<AnalyticsModel>(context, listen: false);
    return Consumer<AnalyticsModel>(
        builder: (_, list, __) => Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Analytics,",
                            style: Theme.of(context).textTheme.headline3),
                        Text("a visual representation of your read categories.",
                            style: Theme.of(context).textTheme.headline5),
                      ],
                    ),
                  ),
                  analyticsModel.categoryData.data.length > 0
                      ? _buildAnalytics(analyticsModel.categoryData, size)
                      : Expanded(
                          child: Center(
                            child: Image.asset(
                              'assets/images/no_books.png',
                              width: size.width - 100,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                ],
              ),
            ));
  }

  Widget _buildAnalytics(charts.Series<ChartSegment, String> chart, Size size) {
    List<charts.Series<ChartSegment, String>> list = [chart];
    return Container(
      height: size.height / 1.2,
      child: Stack(
        children: [
          Center(
            child: charts.PieChart(
              list,
              animate: widget.animate,
              defaultRenderer: new charts.ArcRendererConfig(arcWidth: 50),
              behaviors: [
                new charts.DatumLegend(
                  position: charts.BehaviorPosition.bottom,
                  horizontalFirst: false,
                  outsideJustification:
                      charts.OutsideJustification.middleDrawArea,
                  cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
                  entryTextStyle: charts.TextStyleSpec(
                      fontSize: Theme.of(context)
                          .textTheme
                          .headline5
                          .fontSize
                          .floor()),
                ),
              ],
            ),
          ),
          // Center(
          //   child: Container(
          //     padding: EdgeInsets.only(bottom: 10.0),
          //     child: Text(
          //       "Categories",
          //       style: Theme.of(context)
          //           .textTheme
          //           .headline4
          //           .copyWith(fontWeight: FontWeight.w100),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
