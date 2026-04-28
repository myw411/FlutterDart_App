import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toonflix/Widgets/episode_widget.dart';
import 'package:toonflix/models/webtoon_detail_model.dart';
import 'package:toonflix/services/api_service.dart';
import 'package:toonflix/models/webtoon_episode_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DetailScreen extends StatefulWidget {
  final String title, thumb, id;

  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  State<DetailScreen> createState() => DetailScreenState();
}

class DetailScreenState extends State<DetailScreen> {
  late Future<WebtoonDetailModel> webtoon;
  late Future<List<WebtoonEpisodeModel>> episodes;
  late SharedPreferences prefs;
  bool isLiked = false;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final likedToons = prefs.getStringList('likedToons');
    if (likedToons != null) {
      if (likedToons.contains(widget.id) == true) {
        setState(() {
          isLiked = true;
        });
      } else {
        await prefs.setStringList('likedToons', []);
      }
    }
  }

  @override
  // initState는 처음 한번만 실행되는 함수. 처음 실행 시 API에서 정보 가져오라는 얘기
  void initState() {
    super.initState();
    webtoon = ApiService.getToonById(widget.id);
    episodes = ApiService.getLatestEpisodesById(widget.id);
    initPrefs();
  }

  Future<void> onHeartTap() async {
    final likedToons = prefs.getStringList('likedToons') ?? [];
    if (isLiked) {
      likedToons.remove(widget.id);
    } else {
      likedToons.add(widget.id);
    }
    await prefs.setStringList('likedToons', likedToons);
    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: onHeartTap,
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border_outlined,
            ),
          ),
        ],

        // 이미지 눌러서 화면이 넘어가면 네비게이션 바에 해당 제목을 띄워줌
        title: Text(
          widget.title, // wodget 붙은건 맨 위에 DetailScreen에서 title을 찾으라는 얘기
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: widget.id,
                  child: Container(
                    width: 250,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          offset: Offset(10, 10),
                          color: Colors.black.withValues(alpha: 0.5),
                        ),
                      ],
                    ),
                    child: Image.network(
                      widget.thumb,
                      // headers는 서버에 무언가 요청할 때 어떤 프로그램이,어느 페이지에서 요청했고 추가 인증 정보가 있는지 말해줌
                      headers: const {
                        //아래 코드는 일반 크롬 브라우저 처럼 보이게 속이는 값 /우회접근
                        'User-Agent':
                            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36',
                        'Referer': 'https://comic.naver.com',
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            FutureBuilder(
              future: webtoon,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data!.about,
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        '${snapshot.data!.genre} / ${snapshot.data!.age}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  );
                }
                return Text("...");
              },
            ),
            SizedBox(
              height: 20,
            ),
            FutureBuilder(
              future: episodes,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      for (var episode
                          in snapshot.data!.length > 10
                              ? snapshot.data!.sublist(0, 10)
                              : snapshot.data!)
                        Episode(episode: episode, webtoonId: widget.id),
                    ],
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
