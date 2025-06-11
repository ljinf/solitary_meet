import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:solitary_meet/components/components.dart';
import 'package:solitary_meet/pages/mine/profile/profile_controller.dart';

import '../../../common/values/font.dart';
import '../../../common/values/image.dart';
import '../../../components/pull_up_header.dart';
import '../../../model/community.dart';
import '../../../services/community.dart';
import '../../../utils/moment_view.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  var controller = Get.find<ProfileController>();

  late RefreshController _refreshController;
  var dataList = <MomentModel>[];
  var pageSize = 30;

  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: false);
    onRefresh();
    super.initState();
  }

  //页面缓存
  @override
  bool get wantKeepAlive => true;

  void onRefresh() async {
    var index = 0;
    if (dataList.isNotEmpty) {
      index = dataList[0].createdAt ?? 0;
    }
    var result = await CommunityAPI.getMomentList({
      "where_user": controller.userInfo.userId,
      "created_at": index,
      "direct": "gt",
      "page_size": pageSize
    }, loading: true);
    if (result.isNotEmpty) {
      setState(() {
        dataList.insertAll(0, result);
      });
    }
  }

  void loadMore() async {
    var index = 0;
    if (dataList.isNotEmpty) {
      index = dataList.last.createdAt ?? 0;
    }
    var result = await CommunityAPI.getMomentList({
      "where_user": controller.userInfo.userId,
      "created_at": index,
      "direct": "lt",
      "page_size": pageSize
    }, loading: false);
    if (result.isNotEmpty) {
      setState(() {
        dataList.addAll(result);
      });
      _refreshController.loadComplete();
    } else {
      _refreshController.loadNoData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        ImageView(
          controller.userInfo.avatar!,
          width: 100,
          height: 100,
        ),
        Text(controller.userInfo.nickName!),
        Container(
          height: 10,
          color: const Color(0x44E5E6EB),
        ),
        Expanded(
          child: SmartRefresher(
            enablePullDown: false,
            enablePullUp: true,
            onLoading: loadMore,
            footer: const PullUpHeader(),
            controller: _refreshController,
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              itemBuilder: (ctx, index) {
                return momentView(context, index);
              },
              itemCount: dataList.length,
            ),
          ),
        )
      ],
    ));
  }

  Widget momentView(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 时刻内容
          if ((dataList[index].content ?? '') != '')
            momentTxtView(dataList[index].content ?? ''),
          if ((dataList[index].attachment ?? []).isNotEmpty)
            momentImgListView(context, dataList[index].attachment ?? []),

          ///评论点赞
          Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  //点赞
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            dataList[index].likeStatus == 1
                                ? 'assets/icons/heart_fill.webp'
                                : 'assets/icons/heart_line.webp',
                            width: AppImage.ImageSize20,
                            height: AppImage.ImageSize20,
                            color: dataList[index].likeStatus == 1
                                ? Color(0xFFfc5531)
                                : Color(0xFFA7A6A7),
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            '${(dataList[index].likeCount ?? 0) - (dataList[index].likeCancelCount ?? 0)}',
                            style: const TextStyle(
                                fontSize: AppFont.FontSize12,
                                color: Colors.black),
                          )
                        ],
                      ),
                    ),
                  ),
                  //评论
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/message_line.webp',
                            width: AppImage.ImageSize20,
                            height: AppImage.ImageSize20,
                            // color: Colors.black,
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            '${dataList[index].commentCount}',
                            style: const TextStyle(
                                fontSize: AppFont.FontSize12,
                                color: Colors.black),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
