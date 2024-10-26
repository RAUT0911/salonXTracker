import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ServiceBarChart extends StatelessWidget {
  final Map<String, double> serviceAmounts;

  ServiceBarChart({required this.serviceAmounts});

  @override
  Widget build(BuildContext context) {
    List<String> serviceNames = serviceAmounts.keys.toList();
    List<double> amounts = serviceAmounts.values.toList();

    return AspectRatio(
      aspectRatio: 1.5,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 38,
                getTitlesWidget: (value, meta) {
                  return Text(
                    serviceNames[value.toInt()],
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: amounts.asMap().entries.map((entry) {
            int index = entry.key;
            double amount = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: amount,
                  color: _getColorForIndex(index),
                  width: 30,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            );
          }).toList(),
          gridData: FlGridData(show: true),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${serviceNames[groupIndex]}\n',
                  TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: rod.toY.toString(),
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Color _getColorForIndex(int index) {
    switch (index % 4) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }
}