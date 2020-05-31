class MLResponse {
  final double percentageCases, meanSqrErr, stanDev;
  
  MLResponse({this.percentageCases,this.meanSqrErr,this.stanDev});
  factory MLResponse.fromJson(Map<String,dynamic> json) {
    return MLResponse(
      percentageCases: json['Value'],
      meanSqrErr: json['MeanSquaredError'],
      stanDev: json['StandardDeviation']
    );
  }
}