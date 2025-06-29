import 'package:my_portfolio/features/experience/model/position.dart';

class CompanyExperience {
  final DateTime startDate;
  final DateTime endDate;
  final String companyName;
  final String? logoAsset;
  final List<Position> positions;

  CompanyExperience({
    required this.startDate,
    required this.endDate,
    required this.companyName,
    this.logoAsset,
    required this.positions,
  });
}
