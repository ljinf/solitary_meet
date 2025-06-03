import 'package:solitary_meet/env.dart';

// 开发环境
const SERVER_HOST_DEV = 'http://192.168.31.251:8000';

const SOCKET_HOST_DEV = 'ws://192.168.31.251:8000/ws';

const STATIC_HOST_DEV = 'http://192.168.31.251:8000/v1/static';

// 生产环境
// 生产环境地址禁止随意修改！！！
const SERVER_HOST_PROD = '';

const SERVER_API_URL = ENV_IS_DEV ? SERVER_HOST_DEV : SERVER_HOST_PROD;

const ENV_IS_DEV = ENV == "DEV";

const PUSH_PREFIX = ENV_IS_DEV ? "test_" : "prod_";
