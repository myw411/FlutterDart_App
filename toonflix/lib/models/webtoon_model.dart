class WebtoonModel {
  final String title, thumb, id;

  WebtoonModel.fromJson(Map<String, dynamic> json)
    : title = json['title'],
      thumb = json['thum'],
      id = json['id'];
}
