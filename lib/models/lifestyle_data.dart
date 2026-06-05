class LifestyleData {
  final String primaryActivity;
  final int screenTimeHours;
  final bool outdoorActivity;
  final String workEnvironment;

  const LifestyleData({
    required this.primaryActivity,
    required this.screenTimeHours,
    required this.outdoorActivity,
    required this.workEnvironment,
  });

  static LifestyleData get defaultData => const LifestyleData(
        primaryActivity: 'Mixed / General',
        screenTimeHours: 4,
        outdoorActivity: false,
        workEnvironment: 'Indoor',
      );
}
