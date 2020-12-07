import 'package:booc/models/variables.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AnalyticsModel {
  List<BookCategories> categories;
  charts.Series<ChartSegment, String> categoryData;

  // Create one series with sample hard coded data.
  // Replace all categories with only the read ones.
  void createAnalyticsData() {
    var categoryMap = {};
    BookCategories.values.forEach((category) {
      String categoryTitle = category?.toString()?.split('.')?.elementAt(1);
      if (!categoryMap.containsKey(categoryTitle)) {
        categoryMap[categoryTitle] = 0;
      }
      categoryMap[categoryTitle]++;
    });

    List<ChartSegment> data = [];
    categoryMap.forEach((k, v) {
      data.add(new ChartSegment(k, v));
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
