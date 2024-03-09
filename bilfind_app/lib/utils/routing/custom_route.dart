class CustomRoute {
  final String route;

  CustomRoute({required this.route});

  bool matches(String name) {
    List<String> routeParts = route.split("/");
    List<String> nameParts = name.split("/");

    if (routeParts.length > 0 && routeParts.last.isEmpty) {
      routeParts.removeAt(routeParts.length - 1);
    }

    if (nameParts.length > 0 && nameParts.last.isEmpty) {
      nameParts.removeAt(nameParts.length - 1);
    }

    if (routeParts.length != nameParts.length) {
      return false;
    }

    for (int i = 0; i < routeParts.length; i++) {
      String routePart = routeParts[i];
      String namePart = nameParts[i].split("?")[0];

      if (routePart.startsWith(":")) {
        if (namePart.isEmpty) {
          return false;
        }
      } else {
        if (namePart != routePart) {
          return false;
        }
      }
    }

    return true;
  }

  RouteData getRouteData(String? name) {
    Map<String, Object> queries = {};
    Map<String, Object> params = {};

    if (name == null) {
      return RouteData();
    }

    if (!matches(name)) {
      return RouteData();
    }

    List<String> routeParts = route.split("/");
    List<String> nameParts = name.split("/");

    if (routeParts.length > 0 && routeParts.last.isEmpty) {
      routeParts.removeAt(routeParts.length - 1);
    }

    if (nameParts.length > 0 && nameParts.last.isEmpty) {
      nameParts.removeAt(nameParts.length - 1);
    }

    for (int i = 0; i < routeParts.length; i++) {
      String routePart = routeParts[i];
      var queryParts = nameParts[i].split("?");
      String namePart = queryParts[0];

      if (routePart.startsWith(":")) {
        if (namePart.isNotEmpty) {
          params.putIfAbsent(routePart.substring(1), () => namePart);
        }
      }

      if (queryParts.length > 1) {
        String queryString = queryParts[1];
        List<String> queryStrings = queryString.split("&");
        for (String query in queryStrings) {
          List<String> values = query.split("=");
          if (values.length != 2) {
            continue;
          }

          queries.putIfAbsent(values[0], () => values[1]);
        }
      }
    }

    return RouteData(queries: queries, params: params);
  }
}

class RouteData {
  final Map<String, Object> queries;
  final Map<String, Object> params;

  RouteData({this.queries = const {}, this.params = const {}});

  @override
  String toString() {
    return "queries:${queries} params:${params}";
  }
}
