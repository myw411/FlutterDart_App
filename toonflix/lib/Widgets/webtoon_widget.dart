import 'package:flutter/material.dart';
import 'package:toonflix/screens/detail_screen.dart';

class Webtoon extends StatelessWidget {
  final String title, thumb, id;

  const Webtoon({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    // 동작 감지하는 GestureDetector(이미지 클릭을 감지함)
    return GestureDetector(
      onTap: () {
        //화면 전환 효과
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetailScreen(title: title, thumb: thumb, id: id),
            fullscreenDialog: true,
          ),
        );
      },
      child: Column(
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
              thumb,
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
            title,
            style: TextStyle(fontSize: 22),
          ),
        ],
      ),
    );
  }
}
