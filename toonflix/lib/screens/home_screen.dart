import 'dart:io';

import 'package:flutter/material.dart';
import 'package:toonflix/services/api_service.dart';
import 'package:toonflix/models/webtoon_model.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        title: const Text(
          "오늘의 웹툰",
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400),
        ),
      ),
      body: FutureBuilder(
        future: webtoons,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Expanded(
                  child: makeList(snapshot),
                ),
              ],
            );
          }
          return const Center(
            // 로딩 표시가 뜬다
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  ListView makeList(AsyncSnapshot<List<WebtoonModel>> snapshot) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data!.length,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      itemBuilder: (context, index) {
        // 플러터에서는 출력 명령어는 debugprint이고 기본이 문자열이라서 정수를 쓰려면 아래와 같이 만들어 줘야 함
        //debugPrint('$index');
        var webtoon = snapshot.data![index];
        return Column(
          children: [
            Container(
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
                webtoon.thumb,
                // headers는 서버에 무언가 요청할 때 어떤 프로그램이,어느 페이지에서 요청했고 추가 인증 정보가 있는지 말해줌
                headers: const {
                  //아래 코드는 일반 크롬 브라우저 처럼 보이게 속이는 값 /우회접근
                  'User-Agent':
                      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36',
                  'Referer': 'https://comic.naver.com',
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // 요거는 요 주소의 파일 주세요~ 하는거
            Text(
              webtoon.title,
              style: TextStyle(fontSize: 22),
            ),
          ],
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        width: 40,
      ),
    );
  }
}
