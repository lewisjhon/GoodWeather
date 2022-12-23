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

  final int rnSt3Am;
  final int rnSt3Pm;
  final int rnSt4Am;
  final int rnSt4Pm;
  final int rnSt5Am;
  final int rnSt5Pm;
  final int rnSt6Am;
  final int rnSt6Pm;
  final int rnSt7Am;
  final int rnSt7Pm;
  final int rnSt8;
  final int rnSt9;
  final int rnSt10;

  final String wf3Am;
  final String wf3Pm;
  final String wf4Am;
  final String wf4Pm;
  final String wf5Am;
  final String wf5Pm;
  final String wf6Am;
  final String wf6Pm;
  final String wf7Am;
  final String wf7Pm;
  final String wf8;
  final String wf9;
  final String wf10;

  const ItemMid({
    required this.rnSt3Am,
    required this.rnSt3Pm,
    required this.rnSt4Am,
    required this.rnSt4Pm,
    required this.rnSt5Am,
    required this.rnSt5Pm,
    required this.rnSt6Am,
    required this.rnSt6Pm,
    required this.rnSt7Am,
    required this.rnSt7Pm,
    required this.rnSt8,
    required this.rnSt9,
    required this.rnSt10,
    required this.wf3Am,
    required this.wf3Pm,
    required this.wf4Am,
    required this.wf4Pm,
    required this.wf5Am,
    required this.wf5Pm,
    required this.wf6Am,
    required this.wf6Pm,
    required this.wf7Am,
    required this.wf7Pm,
    required this.wf8,
    required this.wf9,
    required this.wf10,
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
      taMin3: json['taMin3'] ?? 0,
      taMax3: json['taMax3'] ?? 0,
      taMin4: json['taMin4'] ?? 0,
      taMax4: json['taMax4'] ?? 0,
      taMin5: json['taMin5'] ?? 0,
      taMax5: json['taMax5'] ?? 0,
      taMin6: json['taMin6'] ?? 0,
      taMax6: json['taMax6'] ?? 0,
      taMin7: json['taMin7'] ?? 0,
      taMax7: json['taMax7'] ?? 0,
      taMin8: json['taMin8'] ?? 0,
      taMax8: json['taMax8'] ?? 0,
      taMin9: json['taMin9'] ?? 0,
      taMax9: json['taMax9'] ?? 0,
      taMin10: json['taMin10'] ?? 0,
      taMax10: json['taMax10'] ?? 0,
      rnSt3Am: json['rnSt3Am'] ?? 0,
      rnSt3Pm: json['rnSt3Pm'] ?? 0,
      rnSt4Am: json['rnSt4Am'] ?? 0,
      rnSt4Pm: json['rnSt4Pm'] ?? 0,
      rnSt5Am: json['rnSt5Am'] ?? 0,
      rnSt5Pm: json['rnSt5Pm'] ?? 0,
      rnSt6Am: json['rnSt6Am'] ?? 0,
      rnSt6Pm: json['rnSt6Pm'] ?? 0,
      rnSt7Am: json['rnSt7Am'] ?? 0,
      rnSt7Pm: json['rnSt7Pm'] ?? 0,
      rnSt8: json['rnSt8'] ?? 0,
      rnSt9: json['rnSt9'] ?? 0,
      rnSt10: json['rnSt10'] ?? 0,
      wf3Am: json['wf3Am'] ?? '',
      wf3Pm: json['wf3Pm'] ?? '',
      wf4Am: json['wf4Am'] ?? '',
      wf4Pm: json['wf4Pm'] ?? '',
      wf5Am: json['wf5Am'] ?? '',
      wf5Pm: json['wf5Pm'] ?? '',
      wf6Am: json['wf6Am'] ?? '',
      wf6Pm: json['wf6Pm'] ?? '',
      wf7Am: json['wf7Am'] ?? '',
      wf7Pm: json['wf7Pm'] ?? '',
      wf8: json['wf8'] ?? '',
      wf9: json['wf9'] ?? '',
      wf10: json['wf10'] ?? '',
    );
  }
}
