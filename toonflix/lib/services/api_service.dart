import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:toonflix/Widgets/webtoon_widget.dart';
import 'package:toonflix/models/webtoon_detail_model.dart';
import 'package:toonflix/models/webtoon_episode_model.dart';
import 'package:toonflix/models/webtoon_model.dart';

class ApiService {
  static const String baseUrl =
      "https://webtoon-crawler.nomadcoders.workers.dev";
  static const String today = "today";

  static Future<List<WebtoonModel>> getTodaysToons() async {
    List<WebtoonModel> webtoonInstances = [];
    final url = Uri.parse('$baseUrl/$today');
    // 해당 함수가 완전히 실행될 때까지(데이터가 다 올 때까지) 기다렸다가 넘어가라는 명령어 await(async함수 내에서 써야 함)
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> webtoons = jsonDecode(response.body);
      for (var webtoon in webtoons) {
        webtoonInstances.add(WebtoonModel.fromJson(webtoon));
      }
      return webtoonInstances;
    }
    throw Error();
  }

  // ID로 webtoon을 한개 받아오는 method(함수). 서버로부터 받은 제이슨을 가지고 WebtoonDetailModel 모델을 만듦
  static Future<WebtoonDetailModel> getToonById(String id) async {
    // url주소와 거기에 '/id번호'를 연결해서 해당 웹툰의 상세페이지ㅣ로 가도록 함
    final url = Uri.parse(
      "$baseUrl/$id",
    );
    // 위에서 만든 url로 get요청을 보내고 응답은 response에 저장함
    final response = await http.get(
      url,
    );
    // response 코드의 상태가 200이면 성공했다는 뜻
    if (response.statusCode == 200) {
      // json코드를 dart에서 사용할 수 있는 언어로 디코딩 함
      final webtoon = jsonDecode(
        response.body,
      );
      // 최종적으로 WebtoonDetailModel 객체로 변환해서 돌려줌
      return WebtoonDetailModel.fromJson(
        webtoon,
      );
    }
    throw Error();
  }

  // ID값에 따른 최신 에피소드 리스트를 받아옴.
  // 리스트를 통째로 디코드하고 하나씩 모두 WebtoonEpisodeModel을 생성하고 모두 episodesInstances에 담아 반환함
  static Future<List<WebtoonEpisodeModel>> getLatestEpisodesById(
    String id,
  ) async {
    List<WebtoonEpisodeModel> episodesInstances = [];
    final url = Uri.parse(
      "$baseUrl/$id/episodes",
    );
    final response = await http.get(
      url,
    );
    if (response.statusCode == 200) {
      final episodes = jsonDecode(
        response.body,
      );
      for (var episode in episodes) {
        WebtoonEpisodeModel.fromJson(episode);
        episodesInstances.add(WebtoonEpisodeModel.fromJson(episode));
      }
      return episodesInstances;
    }
    throw Error();
  }
}
