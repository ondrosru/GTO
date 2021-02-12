enum Tabs {
  Main,
  Calculator,
  Profile,
}

extension TabsEx on Tabs {
  static Tabs fromInt(int value) {
    return {
      0: Tabs.Main,
      1: Tabs.Calculator,
      2: Tabs.Profile,
    }[value];
  }

  int toInt() {
    return {
      Tabs.Main: 0,
      Tabs.Calculator: 1,
      Tabs.Profile: 2,
    }[this];
  }
}
