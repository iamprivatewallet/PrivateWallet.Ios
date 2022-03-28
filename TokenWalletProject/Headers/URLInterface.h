//
//  URLInterface.h
//  MPay
//
//  Created by MM on 2020/5/20.
//  Copyright © 2020 MM. All rights reserved.
//

#ifndef URLInterface_h
#define URLInterface_h


#define BASEURL @"http://hc-app-api.ap-southeast-1.elasticbeanstalk.com"

#define APPProgramURL @"http://149.129.114.6:8002/mpay/"
#define HTML_BASEURL @"http://149.129.114.6:9002"



//#define BASEURL @"https://app-api.bi.cc/mpay/"
//#define APPProgramURL @"https://open-auth.mpays.io/mpay/"
//#define HTML_BASEURL @"https://app-h5.mpays.io"




//公告列表查询
#define SYS_PBACM_DO @"sys/pbacm.do"
//发送短信验证码
#define PCM_PBSSC_DO @"pcm/pbssc.do"
//发送邮箱验证码
#define PCM_PBESC_DO @"pcm/pbesc.do"
//登录
#define SSM_PBOIN_DO @"ssm/pboin.do"
//添加设备信息
#define SYS_PBALD_DO @"sys/pbald.do"
//获取用户信息
#define UIM_PBBIG_DO @"uim/pbbig.do"
//获取用户余额
#define UIM_PBAIS_DO @"uim/pbais.do"
//获取付款码
#define PAY_PBQRPG_DO @"pay/pbqrpg.do"
//获取收款码
#define PAY_PBQRCG_DO @"pay/pbqrcg.do"
//解析收款码
#define PAY_PBQRCP_DO @"pay/pbqrcp.do"
//往来转账账号获取
#define BIZ_PBPTU_DO @"biz/pbptu.do"
//图片上传
#define OSS_PBIUP_DO @"oss/pbiup.do"
//个人信息设置
#define UIM_PBBIS_DO @"uim/pbbis.do"
//登录账号验证码发送
#define PCM_PBLSC_DO @"pcm/pblsc.do"
//绑定手机号
#define UIM_PBMBS_DO @"uim/pbmbs.do"
//绑定邮箱
#define UIM_PBEBS_DO @"uim/pbebs.do"
//校验验证码
#define SYS_PBVER_DO @"sys/pbver.do"
//解绑手机号邮箱
#define UIM_PBLUS_DO @"uim/pblus.do"
//系统参数查询
#define COM_PBCSQ_DO @"com/pbcsq.do"
//人民币充值方式
#define BIZ_PBCRT_DO @"biz/pbcrt.do"
//人民币充值申请
#define BIZ_PBCRA_DO @"biz/pbcra.do"
//CNY充值确认
#define BIZ_PBCRC_DO @"biz/pbcrc.do"
//修改支付密码
#define UIM_PBTPU_DO @"uim/pbtpu.do"
//首次设置交易密码
#define UIM_PBTPS_DO @"uim/pbtps.do"
//重置支付密码
#define UIM_PBTPR_DO @"uim/pbtpr.do"
//收款方式查询
#define UIM_PBPGS_DO @"uim/pbpgs.do"
//添加收款方式
#define UIM_PBPAS_DO @"uim/pbpas.do"
//身份认证
#define UIM_PBIDS_DO @"uim/pbids.do"
//收款方式状态修改
#define UIM_PBPSS_DO @"uim/pbpss.do"
//收款方式内容修改
#define UIM_PBPUS_DO @"uim/pbpus.do"
//查看登录设备
#define SYS_PBULD_DO @"sys/pbuld.do"
//app版本查询
#define PCM_PBCVS_DO @"pcm/pbcvs.do"
//app业务开关查询
#define PCM_PBCIS_DO @"pcm/pbcis.do"
//获取首页banner
#define PCM_PBIDX_DO @"pcm/pbidx.do"
//消息查询 --》服务提醒
#define PCM_PBNGS_DO @"pcm/pbngs.do"
//系统公告查询
#define SYS_PBACM_DO @"sys/pbacm.do"
//充币地址查询
#define ABM_PBRAG_DO @"abm/pbrag.do"
//生成充币地址
#define RWA_PBAAC_DO @"rwa/pbaac.do"
//充提币信息查询
#define SYS_PBBCC_DO @"sys/pbbcc.do"
//提现申请
#define BIZ_PBLWA_DO @"biz/pblwa.do"
//提币地址查询
#define ABM_PBGWA_DO @"abm/pbgwa.do"
//添加提币地址
#define ABM_PBCWA_DO @"abm/pbcwa.do"
//删除提币地址
#define ABM_PBDWA_DO @"abm/pbdwa.do"
//提币申请
#define ABM_PBWDS_DO @"abm/pbwds.do"
//支付转账
#define PAY_PBTSF_DO @"pay/pbtsf.do"
//扫码转账
#define PAY_PBTQR_DO @"pay/pbtqr.do"
//发现应用列表
#define PCM_PBAGS_DO @"pcm/pbags.do"
//CNY充值记录
#define BIZ_PBCRR_DO @"biz/pbcrr.do"
//小程序根据key获取name
#define APPAUTH_PBAPPINFO_DO @"appauth/pbappinfo.do"
//小程序授权
#define APPAUTH_PBCODE_DO @"appauth/pbcode.do"
//小程序查订单
#define PAY_PBSO_DO @"pay/pbso.do"
//小程序支付
#define PAY_PBOLPAY_DO @"pay/pbolpay.do"
//邀请码验证
#define UIM_PBIRS_DO @"uim/pbirs.do"
//app注册
#define UIM_PBAREG_DO @"uim/pbareg.do"

//支付方式查询
#define UIM_PBGBP_DO @"uim/pbgbp.do"

//支付方式绑定校验支付密码
#define UIM_PBCPS_DO @"uim/pbcps.do"

//支付方式发送验证码
#define UIM_PBSPS_DO @"uim/pbsps.do"

//绑定支付方式
#define UIM_PBBPW_DO @"uim/pbbpw.do"

//解除绑定
#define UIM_PBUPW_DO @"uim/pbupw.do"

//查询monies账户平台
#define UIM_PBQMA_DO @"uim/pbqma.do"


//转出
#define BIZ_PBCTO_DO @"biz/pbcto.do"

//转入
#define BIZ_PBCTI_DO @"biz/pbcti.do"

//支付方式币种配置
#define PCM_PBCCG_DO @"pcm/pbccg.do"

//根据hash获取交易详情
#define TCT_PBGTH_DO @"tct/pbgth.do"

#endif /* URLInterface_h */
