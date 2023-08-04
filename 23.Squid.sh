https://cloud.tencent.com/developer/article/1647151

https://juejin.cn/post/7110119350543056903
一、Squid 是什么？

Squid：是一个高性能的代理缓存服务器，Squid 支持 FTP、gopher、HTTPS 和 HTTP协议。和一般的代理缓存软件不同，Squid用一个单独的、非模块化的、I/O驱动的进程来处理所有的客户端请求，作为应用层的代理服务软件，Squid 主要提供缓存加速、应用层过滤控制的功能。

二、为什么要用 Squid？
Squid是最初的内容分发和缓存工作之后产生的项目之一。它已经成长为包括额外的功能，例如强大的访问控制，授权，日志记录，内容分发/复制，流量管理和整形等等。具有许多新旧的解决方法，可以处理不完整和不正确的HTTP实现。

主要分为如下三点：

1）对于ISP：节省带宽，改善用户体验

Squid 允许 Internet 提供商通过内容缓存节省带宽，缓存的内容意味着数据是在本地提供的，用户可通过经常使用的内容以更快的下载速度看到。调整良好的代理服务器，即使没有缓存，也可以通过优化 TCP 流来提高用户速度。易于调整服务器，以处理互联网上各种延迟，而台式机环境根本不适合这种延迟。

Squid 使 ISP 无需为升级核心设备和传输链路而花费大量资金，以应对不断增长的内容需求，还允许 ISP 根据技术或经济原因决定优先级和控制某些 Web 内容类型。

2）对于网站：在不花费大量硬件和开发时间的情况下扩展应用程序

很多网站使用 Squid 来减轻服务器负载，常见内容由 Squid 缓存并提供给客户端，而通常只需要应用程序服务器负载的一小部分。在现有网站前设置加速器几乎总是一项快速而简单的任务，并具有直接的好处。

3）对于内容交付提供商：在全球范围内分发您的内容

Squid 使内容分发者和开发者可轻松的在全球范围内分发内容，CDN 提供商可以购买运行 Squid 的廉价 PC 硬件，然后将其部署在 Internet 上的战略位置，以廉价，高效地提供大量数据。

三、Squid 代理的工作机制
当客户机通过代理来请求 Web 页面时，指定的代理服务器会先检查自己的缓存，如缓存中已经有客户机需要的页面，则直接将缓存中的页面内容反馈给客户机；

如果缓存中没有客户机要访问的页面，则由代理服务器向 Internet 发送访问请求，当获得返回的 Web 页面后，将网页数据保存到缓存中并发送给客户机。



简要的描述流程图如下：




在 HTTP 代理的缓存加速对象主要是文字、图像等静态 Web 元素。使用缓存机制后，当客户机在不同的时候访问同一个网页时，或者不同的客户机访问相同的网页时，可直接从代理服务器的缓存中取得结果，同时也大大减少了向 Internet 提交重复性的网页请求的过程，提高客户机的网页访问的响应速度。

客户机的网页访问请求是由代理服务器来代替完成的，可隐藏用户的真实 IP 地址，并起到一定的保护作用。同时，也会针对要访问的目标、客户机的地址、访问时间段等等进行过滤控制。

四、Squid 代理的基本类型
传统代理：也可以理解为：普通代理服务，需在客户端的浏览器等程序中手动设置代理服务器的地址和端口，才可以使用代理来进行访问网络，对于浏览器访问网站时的域名解析请求会发给指定的代理服务器。
透明代理：提供与传统代理相同的功能和服务，区别在于客户机不需要指定代理服务器的地址和端口，而是通过默认路由、防火墙策略将网页访问重定向，实际上来说，还是交给代理服务器来进行处理。
五、Squid 的源码包
在 Linux 操作系统下，Squid rpm 包在Packages中。这也是快速启动并运行Squid最简单的方法，也是支持的Squid 版本保持最新的好方法。特殊情况下，也可以下载Squid的二进制软件包，可用于多种平台，包括 Windows 等；

地址：
https://wiki.squid-cache.org/SquidFaq/BinaryPackages

源码包，下载后可在编译时自定义Squid安装。最新的发行版：squid-4.10。

squid-4.10下载地址：
http://www.squid-cache.org/Versions/v4/

也可以参阅编译Squid以获得编译源代码的帮助。

地址：
https://wiki.squid-cache.org/SquidFaq/CompilingSquid

更多软件包版本，可通过官网进行查看。

地址：http://www.squid-cache.org/Versions/

六、搭建 Squid 代理服务器
首先，先把环境及设备搭建好，配置好 IP 地址。

1）一台 客户端（Windows Server / Windows）
2）一台 Web 网站服务器（需启动 HTTPD 服务）
3）一台 Squid 代理服务器（需配置两块网卡：一块为内网 IP 地址，一块为公网 IP 地址）

客户端配置
首先，将客户端的 IP 地址配置为：192.168.3.1（内网 IP 地址），网卡选择：VMnet8，配置好后并检查 IP 是否配置正确，且正确关闭防火墙。



网站服务器配置
# ip a                                                               // 查看 IP 地址

# service iptables stop                                              // 关闭防火墙 和 SElinux
# setenforce 0

# rpm -q httpd                                                       // 查看系统中是否有 HTTPD rpm 包
httpd-2.2.15-29.el6.centos.x86_64

# service httpd start                                                // 启动 HTTPD 服务

# echo "Welcome jack to this website." > /var/www/html/index.html    //将 Welcome jack to this website.写入网站目录下的 html 文件下

# curl http://202.100.0.100                                          // 测试访问本机 IP 地址是否能够正常输出
Welcome jack to this website.
复制
Squid 代理服务器端配置
解压 Squid 源码包，配置 Squid 的编译选项，并将安装目录设为/usr/local/squid，其他具体选项可根据实际需求来配置，或可以参考./configure --help的说明。

# tar xf squid-3.4.6.tar.gz
# ./configure --prefix=/usr/local/squid --sysconfdir=/etc --enable-arp-acl --enable-linux-netfilter --enable-linxu-tproxy --enable-async-io=100 --enable-poll --enable-err-language="Simplify_Chinese" --enable-undersxcore --enable-poll --enable-gnuregex
# make && make install
复制
上述编译选项的含义：

--prefix=/usr/local/squid：安装目录
--sysconfdir=/etc：单独给配置文件修改到其他目录
--enable-arp-acl：可在规则中设置直接通过客户端 MAC 进行管理，防止客户端使用 IP 欺骗
--enable-linux-netfilter：使用内核过滤
--enable-linxu-tproxy：支持透明模式
--enable-async-io=100：异步 I/O，提升存储性能
--enable-poll：使用 poll() 模式，提升性能
--enable-err-language="Simplify_Chinese"：错误信息的显示语言
--enable-undersxcore：允许 URL 中有下划线
--enable-gnuregex：使用 GNU 正则表达式
创建链接文件、用户、组。

# ln -s /usr/local/squid/sbin/* /usr/local/sbin/
# useradd -M -s /sbin/nologin squid
# chown -R squid:squid /usr/local/squid/var
复制
修改 Squid 配置文件

Squid 服务的配置文件位于：/etc/squid.conf，了解配置行有助于管理员根据实际情况灵活配置代理服务。

# vim /etc/squid.conf
59 http_port 3128                                // 用于指定代理服务监听的地址和端口，默认端口号为：3128
60 cache_effective_user squid                    // 指定 Squid 的程序用户，用于设置初始化、运行时缓存的账号，否则启动不成功。
61 cache_effective_group squid                   // 默认为 cache_effective_user 指定账号的基本组
76 visible_hostname squid.packet-pushers.net     // 在配置文件文末最后一行添加 visible_hostname 配置，否则无法启动 Squid 服务。
复制
Squid 的运行控制，检查配置文件语法是否正确；

# squid -k parse
复制
启动、停止 Squid

第一次启动 Squid 服务时，会自动初始化缓存目录。在没有可用的 Squid 服务脚本的情况下，可调用 Squid 程序来启动服务，需先初始化。

# squid -z                                        // -z 选项用来初始化缓存目录
# squid                                           // 启动 Squid 服务
复制
查看 Squid 服务监听状态是否已经监听到 3128 端口号；

# netstat -anpt | grep "squid"
tcp        0      0 :::3128                     :::*                        LISTEN      19068/(squid-1)
复制
除了上述，使用源码包的方式进行安装以外，还可以通过编写Squid 服务脚本来进行操作，并使用chkconfig和service工具来进行管理，这样我们就可以通过Squid 服务脚本来启动、停止、重启 Squid 服务了，在执行时，添加相应的参数即可。

#!/bin/bash
# chkconfig:  2345 90 25
# config: /etc/squid.conf
# pidfile: /usr/local/squid/var/run/squid.pid
# Description: Squid 脚本

PID="/usr/local/squid/var/run/squid.pid"
CONF="/etc/squid.conf"
CMD="/usr/local/squid/sbin/squid"

case "$1" in
    start)
        netstat -anpt | grep squid &> /dev/null
        if [ $? -eq 0 ]
        then
            echo "Squid is running"
           else 
          echo "正在启动 Squid..."
          $CMD
        fi 
    ;;
    stop)
          $CMD  -k kill &> /dev/null
         rm -rf $PID &> /dev/null
    ;;
    restart)
        $0 stop &> /dev/null
         echo "正在关闭 Squid..."
                 $0 start &> /dev/null
         echo "正在启动 Squid..."
    ;;
    reload)
        $CMD -k reconfigure
    ;;
    check)
        $CMD -k parse
    ;;
    status)
        [ -f $PID ] &> /dev/null
           if [ $? -eq 0 ]
             then
        netstat -anpt | grep squid
           else
             echo "Squid 没有运行"
           fi
    ;; 
    *)
        echo "用法 $0 {start|stop|restart|check|status}"
    ;;
    esac
# chmod +x /etc/init.d/squid                              // 授权该脚本文件
# chkconfig --add squid                                   // 添加为系统服务
# chkconfig squid on
复制
七、搭建代理服务器
传统代理：主要在于客户机的相关程序，必须指定代理服务器的地址、端口等信息。
需求描述：

1）在Squid 代理服务器上为客户机访问各种网站提供代理服务，但禁止通过代理下载超过 10MB 大小的文件；

2）客户端上需指定 Squid 代理服务器来作为 Web 访问代理，并隐藏客户端的真实 IP 地址。

Squid 作为代理服务器，必须搭建好 Squid 服务，并允许客户机使用代理；当客户机通过代理以 IP地址的形式来访问。客户端需要为浏览器等程序指定所使用的代理服务器地址、端口号等，Web 服务器需启用 HTTPD 服务。

Squid 代理服务器的配置

配置 Squid 实现传统代理服务时，需添加http_access allow all访问策略，便允许任意客户机使用代理服务，限制下载文件大小，需配置reply_body_max_size选项。

修改 Squid.conf 配置文件

# vim /etc/squid.conf
59 http_port 3128                                  
60 reply_body_max_size 10 MB                       // 允许下载的最大文件大小
61 http_access allow all                           // 放在 http_access allow all 之前
复制
防火墙需添加允许策略并进行保存

# iptables -I -INPUT -p tcp --dport 3128 -j ACCEPT
# service iptables save
复制
重启 Squid 服务

# service squid reload
复制
客户机的代理配置

在浏览器中，选择工具—Internet选项，弹出的Internet选项对话框，在连接选项卡中的局域网(LAN)设置选项中点击局域网设置按钮，进行配置代理服务器的IP 地址和端口。



代理服务的验证方法

在客户机中192.168.3.100中通过浏览器访问目标网站http://202.100.0.100/,并通过Squid 代理服务器、Web 网站服务器的访问日志，来验证代理服务是否发挥作用。

查看Squid访问日志的记录

在Squid代理服务器上，通过跟踪Squid服务的访问日志文件，可以看到客户机 192.168.3.1访问网站服务器的 202.100.0.100记录。

# tail /usr/local/squid/var/logs/access.log
1582563190.161  9372 192.168.3.1 TCP_MISS/200 366 GET http://202.100.0.100/ - HIER_DIRECT/202.100.0.100 text/html
1582634544.842  2584 192.168.3.1 TCP_CLIENT_REFRESH_MISS/304 218 GET http://202.100.0.100/ - HIER_DIRECT/202.100.0.100 - 
1582634545.836   340 192.168.3.1 TCP_MISS/404 537 GET http://202.100.0.100/favicon.ico - HIER_DIRECT/202.100.0.100 text/html
1582635089.249   344 192.168.3.1 TCP_CLIENT_REFRESH_MISS/304 218 GET http://202.100.0.100/ - HIER_DIRECT/202.100.0.100 - 
复制
查看Web访问日志的记录

在Web网站服务器上，通过跟踪HTTPD 服务的访问日志文件，可以发现代理服务器的 IP 地址：202.100.0.1的访问记录，这里其实并没有看到从Squid访问日志的客户机 IP 地址：192.168.3.1的记录，实际上来说，是由代理服务器替它在访问Web网站服务器。

当客户端再次访问该Web网站时，Squid 访问日志中会增加新纪录，Web 访问日志 中的记录不会变化，实际上是由代理服务器通过缓存进行提供。除非是Web网站页面有调整或强制刷新等操作

# tail /var/log/httpd/access_log 
202.100.0.100 - - [23/Feb/2020:21:19:37 +0800] "GET / HTTP/1.1" 200 30 "-" "curl/7.19.7 (x86_64-redhat-linux-gnu) libcurl/7.19.7 NSS/3.14.0.0 zlib/1.2.3 libidn/1.18 libssh2/1.4.2"
202.100.0.100 - - [24/Feb/2020:00:35:09 +0800] "GET / HTTP/1.1" 200 30 "-" "curl/7.19.7 (x86_64-redhat-linux-gnu) libcurl/7.19.7 NSS/3.14.0.0 zlib/1.2.3 libidn/1.18 libssh2/1.4.2"
202.100.0.1 - - [25/Feb/2020:00:53:09 +0800] "GET / HTTP/1.1" 200 30 "-" "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0)"
202.100.0.100 - - [25/Feb/2020:01:21:09 +0800] "GET / HTTP/1.1" 200 30 "-" "curl/7.19.7 (x86_64-redhat-linux-gnu) libcurl/7.19.7 NSS/3.14.0.0 zlib/1.2.3 libidn/1.18 libssh2/1.4.2"
202.100.0.1 - - [25/Feb/2020:20:42:22 +0800] "GET / HTTP/1.1" 304 - "-" "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0)"
202.100.0.1 - - [25/Feb/2020:20:42:25 +0800] "GET /favicon.ico HTTP/1.1" 404 288 "-" "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0)"
202.100.0.1 - - [25/Feb/2020:20:51:29 +0800] "GET / HTTP/1.1" 304 - "-" "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0)"
复制
透明代理：依赖于默认路由和防火墙的重定向策略，适用于局域网主机服务。
需求描述：

1）Squid 为客户机访问 Internet 提供代理服务；

2）局域网的设备，需正确设置 IP 地址、默认网关、不需手动指定代理服务器的地址、端口等；

配置 Squid 支持透明代理

Squid 服务的默认配置是并不支持透明代理的，需调整相关设置。2.6 以上版本，只需在http_port配置行加上transparent透明选项即可支持透明代理了。

# vi /etc/squid.conf
http_port 192.168.3.100:3128 transparent                     // 在其中一个 IP 地址上提供服务
# service squid reload                                       // 重启 squid 服务
复制
设置防火墙的重定向策略

透明代理中 Squid 服务是在Linux 网关主机上构建的，需正确配置防火墙策略，就可以将局域网主机访问 Internet 的数据包交给 Squid 进行处理，需用到IPTABLES的REDIRECT重定向策略，其主要实现本机端口的重定向将访问的网站协议HTTP（80）、HTTPS（443）的外发数据包交给Squid 代理服务器（3128端口）

REDIRECT重定向策略也是一种数据包控制类型，在nat表的PREROUTING或OUTPUT链以及被其调用的链中使用，通过--to-ports 端口号的形式指定映射的目标端口。

# iptables -t nat -A PREROUTING -i eth0 -s 192.168.3.0/24 -p tcp --dport 80 -j REDIRECT --to-ports 3128
# iptables -t nat -A PREROUTING -i eth0 -s 192.168.3.0/24 -p tcp --dport 443 -j REDIRECT --to-ports 3128
# service iptables save
复制
验证透明代理的使用

验证透明代理的效果，如存在手动指定的代理服务器设置应在客户机中去除。如果是在Windows操作系统上，需通过浏览器的连接设置中不要勾选使用代理服务器，如果是在Linux操作系统上，需通过Unset命令清除HTTP_PROXY、HTTPS_PROXY等变量

# unset HTTP_PROXY HTTPS_PROXY
复制
然后在客户机通过浏览器访问目标网站，观察Squid代理服务器、Web服务器的访问日志，进行验证透明代理是否有发挥作用。

八、 ACL 访问控制
Squid通过访问控制，可以保证自己所管理的资源不被非法使用和非法访问，同时也会根据特定的时间间隔访问，缓存指定的网站进行限制，针对源地址、目标地址、访问的 URL 路径、访问的时间等各种条件进行过滤。

Squid用于访问控制的配置选项主要有两个：第一：ACL（Squid 访问控制的基础，用于命名一些网络资源或网络对象，使用ACL配置项定义需要控制的条件）；第二：http_access（它对ACL命名的对象进行权限控制，允许或拒绝访问的控制）；

定义访问控制列表
每一行ACL配置可以定义一条访问控制列表，语法格式：

acl 列表名称 列表类型 列表内容 ···
复制
列表名称（name）：是对象的名称，可自行指定，用来识别控制条件；

列表类型（type）：是网络对象的类型，可以是IP 地址、域名、用户名、网络端口号、协议、请求方法以及正则表达式等，必须使用Squid预定义的值，对应不同类别的控制条件；

列表内容（value）：是指某种类型的网络对象的值，不同类型的列表所对应的内容也不一样，可以有多个值（以空格分隔，为或的关系）；

常见的访问控制列表类型
类型

含义

src

源 IP 地址，可以是单个IP，也可以是地址范围或子网地址

dst

目的 IP 地址，可以是单个IP，也可以是地址范围或子网地址

myip

本机网络接口的 IP 地址

srcdomain

客户所属的域，Squid 将根据客户 IP 地址进行方向 DNS 查询

dstdomain

服务器所属的域，与客户请求的 URL 匹配

time

表示一个时间段

port

指向其他计算机的网络端口

myport

指向 squid 服务器自己的网络端口

proto

客户端请求所使用的协议

method

HTTP 请求方法

proxy_auth

由 squid 自己认证的用户名

url_regex

有关 URL 的正则表达式

定义和使用 acl 对象时，需注意：

1、某种 acl 类型的值可以是同种类型的 acl 对象；

2、不同类型的对象其名称不能重复；

3、acl 对象的值可以为多个，但在使用过程中，当任意一个值被匹配时，则整个 acl 对象被认为是匹配的；

4、同种类型的复习其名称重复使用时，Squid 会把所有的值组合到这个名称的对象中；

5、对象的值如果是文件名，则该文件所包含的内容做为对象的值，文件名需加双引号；

定义访问控制列表时，需结合当前网络环境正确分析用户的访问需求并准确定义使用代理服务的控制条件。不同的客户端地址，需要限制访问的目标网站，特定时间段等等分别进行定义列表。

# vi /etc/squid.conf
acl localhost src 192.168.1.0/255.255.255.0          // 源地址 192.168.1.0
acl MYLAN src 192.168.1.0/24 192.168.3.0/24          // 客户端网段
acl to_localhost dst 127.0.0.0/8                     // 目标地址 127.0.0.0/8 网段
acl MC20 maxconn 20                                  // 最大并发连接 20 
acl WORKTIME time MTWHF 9:00-18:00                   // 时间：周一至周五 9:00-18:00
复制
除上述配置的参数以外，还可以根据上表中的常见的访问控制列表类型根据实际需求进行配置。

限制同一类对象较多时，可使用独立的文件夹进行存放，在 acl 配置航的列表内容处指定对应的文件位置，也可针对目标地址建立黑名单文件。

# mkdir /etc/squid
# cd /etc/squid
# vi heimingdanip.list                                       // 黑名单目标 IP 地址名单
# vi mubiaoyuip.list                                         // 域目标 IP 地址名单
# vi /etc/squid.conf
acl HEIMINGDANIP dst "/etc/squid/heimingdanip.list"          // 调用指定文件中的列表内容
acl MUBIAOYUIP dstdomain “/etc/squid/mubiaoyumingip.list”
复制
设置访问权限
定义ACL对象的目的：为了对与对象匹配的请求进行访问控制，并不是由ACL选项实现的，而是由http_access或icp_access选项实现的。http_access配置行必须放在对应的ACL配置行之后，每一行http_access配置确认一条访问控制规则。

http_access格式：

http_access < allow | deny > [!]ACL对象 1 [!]ACL对象 2 ···
复制
allow：允许  deny：拒绝

ACL 对象：是指由 acl 选项定义的网络对象，可以有多个!符号表示非运算，即与ACL对象相反的那些对象。

http_access规则中，可同时包含多个访问控制列表名，各列表名间以空格进行分隔。

为与的关系，必须满足所有访问控制列表对应的条件才会进行限制。

需取反条件时，可在访问控制列表中前加!符号。

# vi /etc/squid.conf
http_access deny MYLAN MEDIAFILE           // 禁止客户端下载 MP3、MP4 等文件
http_access deny MYLAN HEIMINGDANIP        // 禁止客户端访问黑名单中的 IP 地址
http_access deny MYLAN MUBIAOYUIP          // 禁止客户端访问黑名单中的 域
http_access deny MYLAN MC20                // 客户端的并发连接超过 20 时被中断
http_access allow MYLAN WORKTIME           // 允许客户端在工作时间内进行上网
http_access deny all                       // 默认禁止所有客户端使用代理
复制
Squid处理http_access选项时，要把客户端的请求与http_access选项中的ACL对象匹配，当请求与每一个ACL对象都能匹配时，则执行allow或者deny，只要请求与多个ACL对象中的一个不匹配，则http_access无效，不会执行任何指定的操作。

多个http_access选项，则一个请求与其中一个http_access选项匹配时，将执行http_access指定的操作，如果与所有的http_access选项都不匹配时，则执行与最后一条http_access指定相反的操作。

通常情况下，最常用的控制规则放在最前面，减少Squid的负载。

在访问控制策略上，采用先拒绝后允许或先允许后拒绝的方式，最后一条规则可设为默认策略，表示为http_access allow all或http_access deny all；

在本次Squid环境下，通过如下四条访问控制配置选项进行配置，配置完毕后，重启Squid服务，进行验证。

# vi /etc/squid
acl sorce src 192.168.3.1           // 定义好内网客户机的地址
acl mubiao dst 202.100.0.0/24       // 定好内网要访问的目标地址
http_access deny sorce mubiao       // 拒绝内网地址放问外网地址（用 http_access 引用列表）
http_access allow all                // 定义默认规则为允许所有
# service squid reload
复制
验证结果无非就两种情况，一种是能够正常访问，另一种是禁止访问，客户端的代理访问请求被Squid服务拒绝时，将弹出ERROR报错页面，其具体报错内容也是根据你所限制的条件内容有关。

