import 'package:logger/logger.dart';

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

class ResponseShort {
  final Header header;
  final BodyShort body;

  const ResponseShort({
    required this.header,
    required this.body,
  });

  factory ResponseShort.fromJson(Map<String, dynamic> json) {
    return ResponseShort(
      header: Header.fromJson(json['header']),
      body: BodyShort.fromJson(json['body']),
    );
  }
}

class BodyShort {
  final int numOfRows;
  final int pageNo;
  final int totalCount;
  final String dataType;
  final List<ItemShort> items;

  const BodyShort({
    required this.numOfRows,
    required this.pageNo,
    required this.totalCount,
    required this.dataType,
    required this.items,
  });

  factory BodyShort.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return const BodyShort(
        numOfRows: 0,
        pageNo: 0,
        totalCount: 0,
        dataType: "",
        items: [],
      );
    }

    var list = json['items']['item'] as List;
    List<ItemShort> itemList = list.map((i) => ItemShort.fromJson(i)).toList();

    return BodyShort(
      numOfRows: json['numOfRows'],
      pageNo: json['pageNo'],
      totalCount: json['totalCount'],
      dataType: json['dataType'],
      items: itemList,
    );
  }
}

class ItemShort {
  final String baseDate;
  final String baseTime;
  final String fcstDate;
  final String fcstTime;
  final String category;
  final String fcstValue;
  final int nx;
  final int ny;

  const ItemShort({
    required this.baseDate,
    required this.baseTime,
    required this.fcstDate,
    required this.fcstTime,
    required this.category,
    required this.fcstValue,
    required this.nx,
    required this.ny,
  });

  factory ItemShort.fromJson(Map<String, dynamic> json) {
    return ItemShort(
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

class ResponseMid {
  final Header header;
  final BodyMid body;

  const ResponseMid({
    required this.header,
    required this.body,
  });

  factory ResponseMid.fromJson(Map<String, dynamic> json) {
    return ResponseMid(
      header: Header.fromJson(json['header']),
      body: BodyMid.fromJson(json['body']),
    );
  }
}

class BodyMid {
  final int numOfRows;
  final int pageNo;
  final int totalCount;
  final String dataType;
  final List<ItemMid> items;

  const BodyMid({
    required this.numOfRows,
    required this.pageNo,
    required this.totalCount,
    required this.dataType,
    required this.items,
  });

  factory BodyMid.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return const BodyMid(
        numOfRows: 0,
        pageNo: 0,
        totalCount: 0,
        dataType: "",
        items: [],
      );
    }

    var list = json['items']['item'] as List;
    List<ItemMid> itemList = list.map((i) => ItemMid.fromJson(i)).toList();

    return BodyMid(
      numOfRows: json['numOfRows'],
      pageNo: json['pageNo'],
      totalCount: json['totalCount'],
      dataType: json['dataType'],
      items: itemList,
    );
  }
}

class ItemMid {
  final String regId;
  final int taMin3;
  final int taMax3;
  final int taMin4;
  final int taMax4;
  final int taMin5;
  final int taMax5;
  final int taMin6;
  final int taMax6;
  final int taMin7;
  final int taMax7;
  final int taMin8;
  final int taMax8;
  final int taMin9;
  final int taMax9;
  final int taMin10;
  final int taMax10;

  const ItemMid({
    required this.regId,
    required this.taMin3,
    required this.taMax3,
    required this.taMin4,
    required this.taMax4,
    required this.taMin5,
    required this.taMax5,
    required this.taMin6,
    required this.taMax6,
    required this.taMin7,
    required this.taMax7,
    required this.taMin8,
    required this.taMax8,
    required this.taMin9,
    required this.taMax9,
    required this.taMin10,
    required this.taMax10,
  });

  factory ItemMid.fromJson(Map<String, dynamic> json) {
    return ItemMid(
      regId: json['regId'],
      taMin3: json['taMin3'],
      taMax3: json['taMax3'],
      taMin4: json['taMin4'],
      taMax4: json['taMax4'],
      taMin5: json['taMin5'],
      taMax5: json['taMax5'],
      taMin6: json['taMin6'],
      taMax6: json['taMax6'],
      taMin7: json['taMin7'],
      taMax7: json['taMax7'],
      taMin8: json['taMin8'],
      taMax8: json['taMax8'],
      taMin9: json['taMin9'],
      taMax9: json['taMax9'],
      taMin10: json['taMin10'],
      taMax10: json['taMax10'],
    );
  }
}
