import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String title, thumb, id;

  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        // 이미지 눌러서 화면이 넘어가면 네비게이션 바에 해당 제목을 띄워줌
        title: Text(
          title,
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
            ],
          ),
        ],
      ),
    );
  }
}
