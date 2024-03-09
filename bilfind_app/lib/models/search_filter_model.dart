import 'package:bilfind_app/constants/enums.dart';

class SearchFilterModel {
  String? key;
  List<String>? types;
  int? minPrice;
  int? maxPrice;
  Departments? department;

  SearchFilterModel(
      {this.key, this.types, this.minPrice, this.maxPrice, this.department});

  String generateQueryParameters() {
    final List<String> params = [];

    if (key != null) {
      params.add('key=$key');
    }
    if (types != null && types!.isNotEmpty) {
      for (String type in types!) {
        final typesParam = 'types=${type}';
        params.add(typesParam);
      }
    }

    if (minPrice != null) {
      params.add('minPrice=$minPrice');
    }

    if (maxPrice != null) {
      params.add('maxPrice=$maxPrice');
    }

    if (department != null) {
      params.add('department=${department?.name}');
    }

    return params.join('&');
  }
}
