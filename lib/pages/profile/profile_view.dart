import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:solitary_meet/components/components.dart';
import 'package:solitary_meet/global.dart';
import 'package:solitary_meet/pages/profile/profile_controller.dart';
import 'package:solitary_meet/router/app_pages.dart';
import 'package:solitary_meet/utils/screen_device.dart';
import 'package:timelines_plus/timelines_plus.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../common/values/font.dart';
import '../../../common/values/image.dart';
import '../../../components/pull_up_header.dart';
import '../../../config.dart';
import '../../../model/community.dart';
import '../../../services/community.dart';
import '../../../utils/conts.dart';
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
    getProfile();
    onRefresh();
    super.initState();
  }

  void getProfile() {
    controller.searchProfile().then((v) => setState(() {}));
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

  void toChat() {
    //todo 当前用户要登录
    var ids = [controller.userInfo.userId, Global.userProfile!.userId];
    ids.sort();

    Get.toNamed(AppRoutes.Chat, arguments: {
      "conversation_id": "${ids[0]}-${ids[1]}",
      'user_id': controller.userInfo.userId,
      'title': controller.userInfo.nickName,
      'avatar': controller.userInfo.avatar,
    });
  }

  void updateBackground() {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        SizedBox(
          height: getDeviceHeight(context) * 0.3,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () async {
                  if (controller.userInfo.userId ==
                      Global.userProfile?.userId) {
                    List<AssetEntity>? fileList = await AssetPicker.pickAssets(
                      context,
                      pickerConfig: const AssetPickerConfig(
                          selectedAssets: [],
                          maxAssets: 1,
                          themeColor: Color(0xff478384),
                          textDelegate: AssetPickerTextDelegate()),
                    );
                    if (fileList != null && fileList.isNotEmpty) {
                      await controller.pickPic(fileList[0]);
                      setState(() {});
                    }
                  }
                },
                onLongPress: updateBackground,
                child: LayoutBuilder(builder: (ctx, sc) {
                  if ((controller.userInfo.background ?? '') == '') {
                    return Container(
                      width: sc.maxWidth,
                      height: sc.maxHeight - defaultWidth,
                      color: Colors.white,
                    );
                  }
                  return ImageView(
                    "$STATIC_ASSETS_URL${controller.userInfo.background ?? ''}",
                    width: sc.maxWidth,
                    isRadius: false,
                    height: sc.maxHeight - defaultWidth,
                  );
                }),
              ),
              Positioned(
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      size: 24.0, color: Color(0xFF222222)),
                ),
              ),
              Positioned(
                right: 2,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert_rounded,
                      size: 24.0, color: Color(0xFF222222)),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    ImageView(
                      controller.userInfo.avatar!,
                      width: AppImage.ImageSize56,
                      height: AppImage.ImageSize56,
                      circular: true,
                    ),
                    Text(controller.userInfo.nickName!),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ///关注
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(16)),
                          width: 56,
                          height: 24,
                          child: Center(
                            child: Text(
                              '关注',
                              style: TextStyle(
                                  fontSize: AppFont.FontSize12,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),

                        ///聊天
                        if (controller.userInfo.userId !=
                            Global.userProfile!.userId)
                          GestureDetector(
                            onTap: toChat,
                            child: ImageView(
                              'assets/icons/message_line.webp',
                              width: AppImage.ImageSize20,
                              height: AppImage.ImageSize20,
                            ),
                          )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: TimelineTheme(
            data: TimelineThemeData(
                //指示器位置
                indicatorPosition: 0),
            child: SmartRefresher(
              enablePullDown: false,
              enablePullUp: true,
              onLoading: loadMore,
              footer: const PullUpHeader(),
              controller: _refreshController,
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                itemBuilder: (ctx, index) {
                  /* return LayoutBuilder(
                      builder: (BuildContext ctx, BoxConstraints cs) {
                    return TimelineTile(
                      direction: Axis.vertical,
                      mainAxisExtent: cs.maxWidth,
                      // crossAxisExtent: cs.maxWidth,
                      nodeAlign: TimelineNodeAlign.start,
                      // nodePosition: 0.2,
                      // oppositeContents:  ImageView(
                      //   controller.userInfo.avatar!,
                      //   width: defaultWidth,
                      //   height: defaultWidth,
                      // ),
                      node: const TimelineNode(
                        startConnector: SolidLineConnector(),
                        endConnector: SolidLineConnector(),
                        indicator: DotIndicator(
                          color: Colors.cyan,
                        ),
                      ),
                      contents: momentView(ctx, index),
                    );
                  });*/
                  return Container(
                    padding:
                        EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                    child: momentView(context, index),
                  );
                },
                itemCount: dataList.length,
              ),
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
