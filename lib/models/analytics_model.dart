import 'package:booc/models/variables.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';

class AnalyticsModel with ChangeNotifier {
  charts.Series<ChartSegment, String> categoryData;
  var categoryMap = {};

  void addBookToAnalytics(BookCategories category) {
    if (!categoryMap.containsKey(category)) {
      categoryMap[category] = 0;
    }
    categoryMap[category]++;
    print(categoryMap);
  }

  void createAnalyticsData() {
    List<ChartSegment> data = [];
    print("create Chart data: ");
    print(categoryMap);
    categoryMap.forEach((key, v) {
      String title = enumToTitle(key);
      data.add(new ChartSegment(title, v));
    });

    categoryData = new charts.Series<ChartSegment, String>(
      id: 'Segments',
      domainFn: (ChartSegment segment, _) => segment.category,
      measureFn: (ChartSegment segment, _) => segment.amount,
      colorFn: (_, index) {
        return charts.MaterialPalette.gray
            .makeShades(categoryMap.keys.length)[index];
      },
      data: data,
      labelAccessorFn: (ChartSegment row, _) =>
          '${row.category}: ${row.amount}',
    );
  }
}

// Sample data type.
class ChartSegment {
  final String category;
  final int amount;

  ChartSegment(this.category, this.amount);
}
