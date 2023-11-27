import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// figure out how to sync chart
// do the calendar page
class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  // Build is rerun every time setState is called
  late List<GraphData> _chartData;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _chartData = getGraphData(1);
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('fashion stats',
              style: TextStyle(fontFamily: 'Ubuntu Mono Bold')),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            titleBox('viewing stats for'),
            infoBox('wardrobe', const Color.fromARGB(255, 139, 224, 190), 1),
            infoBox('most worn colours',
                const Color.fromARGB(255, 255, 255, 255), 3),
            infoBox('brands', const Color.fromARGB(255, 190, 162, 245), 2)
          ],
        ),
      ),
    );
  }

  Widget titleBox(String title) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 24, 21, 39),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 12.0,
            ),
          ),
          const SizedBox(width: 8.0), // Add spacing
          Center(
            child: dropDown(),
          ),
        ],
      ),
    );
  }

  Widget infoBox(String title, Color hue, int num) {
    String numItems = '';
    double sum = 0;
    if (num == 1) {
      for (var items in _chartData) {
        sum += items.val;
      }
      numItems = 'total: $sum';
    }
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 24, 21, 39),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: TextStyle(
              color: hue,
              fontSize: 20.0,
              fontFamily: 'Ubuntu Mono',
            ),
            textAlign: TextAlign.center,
          ),
          chartStat(hue, num), // Add your chart widget here
          Text('total: $numItems'),
        ],
      ),
    );
  }

  Widget dropDown() {
    const List<String> list = <String>['all time', '2023', '2022'];
    String dropdownValue = list.first;
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      style: const TextStyle(
          fontFamily: 'Ubuntu Mono', color: Color.fromARGB(255, 128, 84, 203)),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget chartStat(Color hue, int num) {
    late List<Color> palChoice;
    List<Color> colorPal1 = const [
      Color.fromARGB(255, 103, 197, 135),
      Color.fromARGB(255, 201, 234, 212),
      Color.fromARGB(255, 169, 222, 186),
      Color.fromARGB(255, 136, 209, 161),
      Color.fromARGB(255, 89, 170, 118),
      Color.fromARGB(255, 75, 143, 100),
    ];
    List<Color> colorPal2 = const [
      Color.fromARGB(255, 111, 78, 207),
      Color.fromARGB(255, 236, 229, 251),
      Color.fromARGB(255, 221, 207, 249),
      Color.fromARGB(255, 202, 180, 250),
      Color.fromARGB(255, 168, 141, 235),
      Color.fromARGB(255, 136, 107, 216),
      Color.fromARGB(255, 124, 90, 217),
    ];
    List<Color> colorPal3 = const [
      Color.fromARGB(220, 235, 55, 28),
      Color.fromARGB(255, 223, 93, 15),
      Color.fromARGB(255, 213, 142, 26),
      Color.fromARGB(255, 107, 145, 84),
      Color.fromARGB(255, 78, 127, 154),
      Color.fromARGB(255, 145, 83, 159),
      Color.fromARGB(255, 92, 92, 92),
      Color.fromARGB(255, 34, 34, 34),
    ];
    if (num == 1) {
      palChoice = colorPal1;
      _chartData = getGraphData(1);
    } else if (num == 2) {
      palChoice = colorPal2;
      _chartData = getGraphData(2);
    } else if (num == 3) {
      palChoice = colorPal3;
      _chartData = getGraphData(3);
    }
    return SfCircularChart(
      backgroundColor: const Color.fromARGB(255, 24, 21, 39),
      palette: palChoice,
      legend: Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode.scroll,
          textStyle: const TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 16,
            fontFamily: 'Ubuntu Mono',
          )),
      tooltipBehavior: _tooltipBehavior,
      series: <CircularSeries>[
        PieSeries<GraphData, String>(
          dataSource: _chartData,
          xValueMapper: (GraphData data, _) => data.content,
          yValueMapper: (GraphData data, _) => data.val,
          animationDuration: 1000,
          enableTooltip: true,
        )
      ],
    );
  }

  List<GraphData> getGraphData(int num) {
    late List<GraphData> chartData;
    List<GraphData> items = [
      // insert database data here? keep placeholders for items not scanned, i.e. bags, footwear, etc.
      GraphData('tops', 22),
      GraphData('bottoms', 14),
      GraphData('footwear', 3),
      GraphData('bags', 2),
      GraphData('full body', 7),
      GraphData('outerwear', 4),
    ];
    List<GraphData> brands = [
      GraphData('uniqlo', 5),
      GraphData('nike', 4),
      GraphData('h&m', 3),
      GraphData('under armour', 2),
      GraphData('adidas', 2),
      GraphData('polo', 1),
      GraphData('eddie bauer', 1),
    ];
    List<GraphData> colours = [
      GraphData('red', 1),
      GraphData('orange', 1),
      GraphData('yellow', 1),
      GraphData('green', 1),
      GraphData('blue', 3),
      GraphData('purple', 1),
      GraphData('grey', 12),
      GraphData('black', 17),
    ];
    if (num == 1) {
      chartData = items;
    } else if (num == 2) {
      chartData = brands;
    } else if (num == 3) {
      chartData = colours;
    }
    return chartData;
  }
}

class GraphData {
  GraphData(this.content, this.val);
  final String content;
  final int val;
}
