class ResponsiveBreakpoints {
  const ResponsiveBreakpoints._();

  static const double desktop = 1200;
  static const double tablet = 900;
  static const double mobile = 600;

  static bool isDesktop(double width) => width >= desktop;

  static bool isTablet(double width) => width >= tablet && width < desktop;

  static bool isMobile(double width) => width < tablet;

  static bool isCompactPhone(double width) => width < mobile;
}

