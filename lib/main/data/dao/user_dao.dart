import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ng_github/main/common/SecretConfig.dart';
import 'package:ng_github/main/common/config.dart';
import 'package:ng_github/main/data/db/provider/user_orgs_db_provider.dart';
import 'package:ng_github/main/data/db/provider/userinfo_db_provider.dart';
import 'package:ng_github/main/data/model/SearchUserQL.dart';
import 'package:ng_github/main/data/model/User.dart';
import 'package:ng_github/main/data/model/UserOrg.dart';
import 'package:ng_github/main/data/net/address.dart';
import 'package:ng_github/main/data/net/api.dart';
import 'package:ng_github/main/data/net/graphql/client.dart';
import 'package:ng_github/main/redux/user_redux.dart';
import 'package:ng_github/main/utils/common_utils.dart';
import 'package:ng_github/main/utils/sp/local_storage.dart';
import 'package:redux/redux.dart';
import 'package:dio/dio.dart';

import 'dao_result.dart';


class UserDao {

  static oauth(code, store) async {

    httpManager.clearAuthorization();

    var res = await httpManager.netFetch(
        "https://github.com/login/oauth/access_token?"
            "client_id=${SecretConfig.CLIENT_ID}"
            "&client_secret=${SecretConfig.CLIENT_SECRET}"
            "&code=${code}",
        null,
        null,
        null);
    var resultData = null;
    if (res != null && res.result) {
      print("#### ${res.data}");
      var result = Uri.parse("gsy://oauth?" + res.data);
      var token = result.queryParameters["access_token"];
      var _token = 'token ' + token;
      await LocalStorage.save(Config.TOKEN_KEY, _token);


      resultData = await getUserInfo(null);
      if (Config.DEBUG ) {
        print("登陆用户结果user result " + resultData.result.toString());
        print(resultData.data);
        print(res.data.toString());
      }
      if(resultData.result == true) {
        store.dispatch(new UpdateUserAction(resultData.data));
      }
    }

    return new DataResult(resultData, res.result);
  }

  static login(userName, password, store) async {
    String type = userName + ":" + password;
    var bytes = utf8.encode(type);
    var base64Str = base64.encode(bytes);
    if (Config.DEBUG) {
      print("base64Str login " + base64Str);
    }

    await LocalStorage.save(Config.USER_NAME_KEY, userName);
    await LocalStorage.save(Config.USER_BASIC_CODE, base64Str);

    Map requestParams = {
      "scopes": ['user', 'repo', 'gist', 'notifications'],
      "note": "admin_script",
      "client_id": SecretConfig.CLIENT_ID,
      "client_secret": SecretConfig.CLIENT_SECRET
    };
    httpManager.clearAuthorization();

    var res = await httpManager.netFetch(Address.getAuthorization(),
        json.encode(requestParams), null, new Options(method: "post"));
    var resultData = null;
    if (res != null && res.result) {
      await LocalStorage.save(Config.PW_KEY, password);
      var resultData = await getUserInfo(null);
      if (Config.DEBUG) {
        print("user result " + resultData.data.toString());
        print(resultData.data);
        print(res.data.toString());
      }
      store.dispatch(new UpdateUserAction(resultData.data));
    }
    return new DataResult(resultData, res.result);
  }

  ///初始化用户信息
  static initUserInfo(Store store) async {
    var token = await LocalStorage.get(Config.TOKEN_KEY);
    var res = await getUserInfoLocal();
    if (res != null && res.result && token != null) {
      store.dispatch(UpdateUserAction(res.data));
    }
    return new DataResult(res.data, (res.result && (token != null)));
  }

  ///获取本地登录用户信息
  static getUserInfoLocal() async {
    var userText = await LocalStorage.get(Config.USER_INFO);
    if (userText != null) {
      var userMap = json.decode(userText);
      User user = User.fromJson(userMap);
      return new DataResult(user, true);
    } else {
      return new DataResult(null, false);
    }
  }

  ///获取用户详细信息
  static getUserInfo(userName, {needDb = false}) async {
    UserInfoDbProvider provider = new UserInfoDbProvider();
    next() async {
      var res;
      if (userName == null) {
        res = await httpManager.netFetch(
            Address.getMyUserInfo(), null, null, null);
      } else {
        res = await httpManager.netFetch(
            Address.getUserInfo(userName), null, null, null);
      }
      if (res != null && res.result) {
        String starred = "---";
        if (res.data["type"] != "Organization") {
          var countRes = await getUserStaredCountNet(res.data["login"]);
          if (countRes.result) {
            starred = countRes.data;
          }
        }
        User user = User.fromJson(res.data);
        print("完整用户信息:" + user.toString());
        user.starred = starred;
        if (userName == null) {
          LocalStorage.save(Config.USER_INFO, json.encode(user.toJson()));
        } else {
          if (needDb) {
            provider.insert(userName, json.encode(user.toJson()));
          }
        }
        return new DataResult(user, true);
      } else {
        return new DataResult(res.data, false);
      }
    }

    if (needDb) {
      User user = await provider.getUserInfo(userName);
      if (user == null) {
        return await next();
      }
      DataResult dataResult = new DataResult(user, true, next: next);
      return dataResult;
    }
    return await next();
  }

  static clearAll(Store store) async {
    httpManager.clearAuthorization();
    LocalStorage.remove(Config.USER_INFO);
    store.dispatch(new UpdateUserAction(User.empty()));
  }

  /**
   * 在header中提起stared count
   */
  static getUserStaredCountNet(userName) async {
    String url = Address.userStar(userName, null) + "&per_page=1";
    var res = await httpManager.netFetch(url, null, null, null);
    if (res != null && res.result && res.headers != null) {
      try {
        List<String> link = res.headers['link'];
        if (link != null) {
          int indexStart = link[0].lastIndexOf("page=") + 5;
          int indexEnd = link[0].lastIndexOf(">");
          if (indexStart >= 0 && indexEnd >= 0) {
            String count = link[0].substring(indexStart, indexEnd);
            return new DataResult(count, true);
          }
        }
      } catch (e) {
        print(e);
      }
    }
    return new DataResult(null, false);
  }

  /**
   * 更新用户信息
   */
  static updateUserDao(params, Store store) async {
    String url = Address.getMyUserInfo();
    var res = await httpManager.netFetch(
        url, params, null, new Options(method: "PATCH"));
    if (res != null && res.result) {
      var localResult = await getUserInfoLocal();
      User newUser = User.fromJson(res.data);
      newUser.starred = localResult.data.starred;
      await LocalStorage.save(Config.USER_INFO, json.encode(newUser.toJson()));
      store.dispatch(new UpdateUserAction(newUser));
      return new DataResult(newUser, true);
    }
    return new DataResult(null, false);
  }

  /**
   * 获取用户组织
   */
  static getUserOrgsDao(userName, page, {needDb = false}) async {
    UserOrgsDbProvider provider = new UserOrgsDbProvider();
    next() async {
      String url =
          Address.getUserOrgs(userName) + Address.getPageParams("?", page);
      var res = await httpManager.netFetch(url, null, null, null);
      if (res != null && res.result) {
        List<UserOrg> list = new List();
        var data = res.data;
        if (data == null || data.length == 0) {
          return new DataResult(null, false);
        }
        for (int i = 0; i < data.length; i++) {
          list.add(new UserOrg.fromJson(data[i]));
        }
        if (needDb) {
          provider.insert(userName, json.encode(data));
        }
        return new DataResult(list, true);
      } else {
        return new DataResult(null, false);
      }
    }

    if (needDb) {
      List<UserOrg> list = await provider.geData(userName);
      if (list == null) {
        return await next();
      }
      DataResult dataResult = new DataResult(list, true, next: next);
      return dataResult;
    }
    return await next();
  }

  static searchTrendUserDao(String location,
      {String cursor, ValueChanged valueChanged}) async {
    var result = await getTrendUser(location, cursor: cursor);
    if (result != null && result.data != null) {
      var endCursor = result.data["search"]["pageInfo"]["endCursor"];
      var dataList = result.data["search"]["user"];
      if (dataList == null || dataList.length == 0) {
        return new DataResult(null, false);
      }
      var dataResult = List();
      valueChanged?.call(endCursor);
      dataList.forEach((item) {
        var userModel = SearchUserQL.fromMap(item["user"]);
        dataResult.add(userModel);
      });
      return new DataResult(dataResult, true);
    } else {
      return new DataResult(null, false);
    }
  }
}
