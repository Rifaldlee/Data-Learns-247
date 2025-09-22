class AnalyticReelsPayload {
  int reelId;
  int watchTime;
  int duration;
  String deviceType;


  AnalyticReelsPayload({
    required this.reelId,
    required this.watchTime,
    required this.duration,
    this.deviceType = 'mobile',
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reel_id'] = reelId;
    map['watch_time'] = watchTime;
    map['duration'] = duration;
    map['device_type'] = deviceType;
    return map;
  }
}