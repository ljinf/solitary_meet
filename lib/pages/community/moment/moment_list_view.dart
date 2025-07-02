import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:solitary_meet/components/pull_up_header.dart';
import 'package:solitary_meet/model/community.dart';
import 'package:solitary_meet/pages/community/moment/moment_item.dart';
import 'package:solitary_meet/router/app_pages.dart';
import 'package:solitary_meet/services/community.dart';

import '../../../utils/conts.dart';

class MomentPage extends StatefulWidget {
  const MomentPage({super.key});

  @override
  State<MomentPage> createState() => _MomentPageState();
}

class _MomentPageState extends State<MomentPage>
    with AutomaticKeepAliveClientMixin {
  late RefreshController _refreshController;
  var dataList = <MomentModel>[];
  var pageSize = 30;

  //页面缓存
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: false);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // UI渲染完成，调用requestRefresh()
      _refreshController.requestRefresh();
    });
    super.initState();
  }

  void onRefresh() async {
    var index = 0;
    if (dataList.isNotEmpty) {
      index = dataList[0].createdAt ?? 0;
    }
    var result = await CommunityAPI.getMomentList(
        {"created_at": index, "direct": "gt", "page_size": pageSize},
        loading: false);
    if (result.isNotEmpty) {
      setState(() {
        dataList.insertAll(0, result);
      });
    }
    _refreshController.refreshCompleted();
  }

  void loadMore() async {
    var index = 0;
    if (dataList.isNotEmpty) {
      index = dataList.last.createdAt ?? 0;
    }
    var result = await CommunityAPI.getMomentList(
        {"created_at": index, "direct": "lt", "page_size": pageSize},
        loading: false);
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
    return Scaffold(
      backgroundColor: appBarColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [IconButton(onPressed: () {
          Get.toNamed(AppRoutes.AddMoment);
        }, icon: Icon(Icons.signpost_outlined))],
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: onRefresh,
        onLoading: loadMore,
        header: const WaterDropHeader(
          waterDropColor: Colors.blue,
        ),
        footer: const PullUpHeader(),
        controller: _refreshController,
        child: ListView.builder(
          physics: const ClampingScrollPhysics(),
          itemBuilder: (ctx, index) {
            return MomentItemView(dataList[index]);
          },
          itemCount: dataList.length,
        ),
      ),
    );
  }
}
