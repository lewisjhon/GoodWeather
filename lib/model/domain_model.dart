import 'package:logger/logger.dart';

class Response {
  final Header header;
  final Body body;

  const Response({
    required this.header,
    required this.body,
  });

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      header: Header.fromJson(json['header']),
      body: Body.fromJson(json['body']),
    );
  }
}

class Header {
  final String resultCode;
  final String resultMsg;

  const Header({
    required this.resultCode,
    required this.resultMsg,
  });

  factory Header.fromJson(Map<String, dynamic> json) {
    return Header(
      resultCode: json['resultCode'],
      resultMsg: json['resultMsg'],
    );
  }
}

class Body {
  final int numOfRows;
  final int pageNo;
  final int totalCount;
  final String dataType;
  final List<Item> items;

  const Body({
    required this.numOfRows,
    required this.pageNo,
    required this.totalCount,
    required this.dataType,
    required this.items,
  });

  factory Body.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return const Body(
        numOfRows: 0,
        pageNo: 0,
        totalCount: 0,
        dataType: "",
        items: [],
      );
    }

    var list = json['items']['item'] as List;
    List<Item> itemList = list.map((i) => Item.fromJson(i)).toList();
    return Body(
      numOfRows: json['numOfRows'],
      pageNo: json['pageNo'],
      totalCount: json['totalCount'],
      dataType: json['dataType'],
      items: itemList,
    );
  }
}

class Item {
  final String baseDate;
  final String baseTime;
  final String fcstDate;
  final String fcstTime;
  final String category;
  final String fcstValue;
  final int nx;
  final int ny;

  const Item({
    required this.baseDate,
    required this.baseTime,
    required this.fcstDate,
    required this.fcstTime,
    required this.category,
    required this.fcstValue,
    required this.nx,
    required this.ny,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      baseDate: json['baseDate'],
      baseTime: json['baseTime'],
      fcstDate: json['fcstDate'],
      fcstTime: json['fcstTime'],
      category: json['category'],
      fcstValue: json['fcstValue'],
      nx: json['nx'],
      ny: json['ny'],
    );
  }
}
