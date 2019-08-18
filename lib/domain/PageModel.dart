
class PageModel {
  static const ROUTE_RECORD = 'route-record';
  static const ROUTE_CALENDAR = 'route-calendar';
  static const ROUTE_STATISTICS = 'route-statistics';
  static const ROUTE_SETTINGS = 'route-settings';
  static const ROUTE_ABOUT = 'route-about';
  static const ROUTE_REPORT_BUG = 'route-report-bug';

  final String title;
  final String route;
  final bool isEnabled;

  // todo: const constructor랑 그냥 constructor랑 차이가 무엇이냐
  const PageModel(this.title, this.route, this.isEnabled);
}
