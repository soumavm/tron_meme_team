class MLResponse {
  final double hotspot;
  
  MLResponse({this.hotspot});
  factory MLResponse.fromJson(Map<String,dynamic> json) {
    return MLResponse(
      hotspot: json['Value'],
    );
  }
}