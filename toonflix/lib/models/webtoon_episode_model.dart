class WebtoonEpisodeModel {
  final String id, title, rating, date;

  // json형식으로 된 데이터를 dart의 Map<String, dynamic> 형태로 받은 뒤 모델 객체로 바꿈
  WebtoonEpisodeModel.fromJson(
    Map<String, dynamic> json,
  ) : id = json['id'],
      title = json['title'],
      rating = json['rating'],
      date = json['date'];
}
