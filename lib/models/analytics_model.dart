class AnalyticsModel {
  final int totalUsers;
  final int activeUsers;
  final int totalCities;
  final int totalAttractions;
  final int totalReviews;
  final int pendingReviews;
  final double averageRating;
  final Map<String, int> userGrowth; // date -> count
  final Map<String, int> popularCities; // cityId -> viewCount

  AnalyticsModel({
    required this.totalUsers,
    required this.activeUsers,
    required this.totalCities,
    required this.totalAttractions,
    required this.totalReviews,
    required this.pendingReviews,
    required this.averageRating,
    required this.userGrowth,
    required this.popularCities,
  });

  factory AnalyticsModel.empty() {
    return AnalyticsModel(
      totalUsers: 0,
      activeUsers: 0,
      totalCities: 0,
      totalAttractions: 0,
      totalReviews: 0,
      pendingReviews: 0,
      averageRating: 0.0,
      userGrowth: {},
      popularCities: {},
    );
  }
}
