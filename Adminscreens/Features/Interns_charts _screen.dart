import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InternsPerCompanyChart extends StatefulWidget {

  @override
  State<InternsPerCompanyChart> createState() => _InternsPerCompanyChartState();
}

class _InternsPerCompanyChartState extends State<InternsPerCompanyChart> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _errorMessage;

  Future<Map<String, int>> _getInternsPerCompany() async {
    final Map<String, int> result = {};

    try {
      final companies = await _firestore.collection('company').get();

      for (final company in companies.docs) {
        try {
          final companyId = company.id;
          final companyName = company.data()['CompanyName'] ?? 'Unknown Company';

          final internsSnapshot = await _firestore
              .collection('interns')
              .where('companyId', isEqualTo: companyId)
              .get();

          if (internsSnapshot.docs.isNotEmpty) {
            result[companyName] = internsSnapshot.docs.length;
          }
        } catch (e) {
          debugPrint('Error processing company ${company.id}: $e');
          _errorMessage = 'Failed to load some company data';
        }
      }
    } catch (e) {
      debugPrint('Error fetching company list: $e');
      _errorMessage = 'Failed to load company data';
      throw Exception('Failed to load data');
    }

    if (result.isEmpty && _errorMessage == null) {
      _errorMessage = 'No internship data available';
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, int>>(
      future: _getInternsPerCompany(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || _errorMessage != null) {
          return _buildErrorWidget(_errorMessage ?? 'Error loading data');
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildErrorWidget('No internship data available');
        }

        final data = snapshot.data!;
        final chartData = data.entries.toList();

        try {
          final total = chartData.fold<int>(0, (sum, entry) {
            if (entry.value < 0) {
              throw Exception('Negative intern count for ${entry.key}');
            }
            return sum + entry.value;
          });

          if (total <= 0) {
            return _buildErrorWidget('No valid internship data');
          }

          return _buildChartWidget(chartData, total, context);
        } catch (e) {
          debugPrint('Error calculating totals: $e');
          return _buildErrorWidget('Error processing data');
        }
      },
    );
  }

  Widget _buildChartWidget(List<MapEntry<String, int>> chartData, int total, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Interns Distribution by Company',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
                color: Color(0xFF2252A1)            ),
          ),
          const SizedBox(height: 16),

          // Percentage indicators at the top
          _buildPercentageIndicators(chartData, total, context),
          const SizedBox(height: 16),

          // Pie Chart
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 0,
                centerSpaceRadius: 50,
                sections: _generateSections(chartData),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Company names with counts
          _buildCompanyList(chartData, context),
        ],
      ),
    );
  }

  Widget _buildPercentageIndicators(List<MapEntry<String, int>> data, int total, BuildContext context) {
    final colors = _getChartColors();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(data.length, (index) {
          try {
            final entry = data[index];
            final percentage = (entry.value / total * 100).toStringAsFixed(1);
            final color = colors[index % colors.length];

            return Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: color.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$percentage%',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo[900],
                    ),
                  ),
                ],
              ),
            );
          } catch (e) {
            debugPrint('Error building percentage indicator: $e');
            return const SizedBox();
          }
        }),
      ),
    );
  }

  Widget _buildCompanyList(List<MapEntry<String, int>> data, BuildContext context) {
    final colors = _getChartColors();

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: List.generate(data.length, (index) {
        try {
          final entry = data[index];
          final color = colors[index % colors.length];

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    entry.key,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '(${entry.value})',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        } catch (e) {
          debugPrint('Error building company list item: $e');
          return const SizedBox();
        }
      }),
    );
  }

  List<PieChartSectionData> _generateSections(List<MapEntry<String, int>> data) {
    final colors = _getChartColors();

    return List.generate(data.length, (index) {
      final entry = data[index];
      final color = colors[index % colors.length];

      return PieChartSectionData(
        color: color,
        value: entry.value.toDouble(),
        radius: 20,
        showTitle: false,
        badgeWidget: _Badge(
          '${entry.key.substring(0, 1)}',
          color: color,
        ),
        badgePositionPercentageOffset: .98,
      );
    });
  }

  List<Color> _getChartColors() {
    return [
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.orangeAccent,
      Colors.purpleAccent,
      Colors.redAccent,
      Colors.tealAccent,
      Colors.pinkAccent,
      Colors.indigoAccent,
      Colors.amber,
      Colors.lightBlue,
    ];
  }

  Widget _buildErrorWidget(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String symbol;
  final Color color;

  const _Badge(this.symbol, {required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Center(
        child: Text(
          symbol,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}