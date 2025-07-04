import 'package:solitary_meet/env.dart';

// 开发环境

const BASE_IP_DEV = "192.168.1.245:8000";

const SERVER_HOST_DEV = 'http://$BASE_IP_DEV';

const SOCKET_HOST_DEV = 'ws://$BASE_IP_DEV/ws';

const STATIC_HOST_DEV = 'http://$BASE_IP_DEV/v1/static';

// 生产环境
// 生产环境地址禁止随意修改！！！
const BASE_IP_PROD = "";

const SERVER_HOST_PROD = 'https://$BASE_IP_PROD';

const SOCKET_HOST_PROD = 'wss://$BASE_IP_PROD/ws';

const STATIC_HOST_PROD = 'https://$BASE_IP_PROD/v1/static';

///api
const SERVER_API_URL = ENV_IS_DEV ? SERVER_HOST_DEV : SERVER_HOST_PROD;

///socket
const SOCKET_URL = ENV_IS_DEV ? SOCKET_HOST_DEV : SOCKET_HOST_PROD;

///静态资源
const STATIC_ASSETS_URL = ENV_IS_DEV ? STATIC_HOST_DEV : STATIC_HOST_PROD;

const ENV_IS_DEV = ENV == "DEV";

const PUSH_PREFIX = ENV_IS_DEV ? "test_" : "prod_";
