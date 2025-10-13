# sysctl 参考配置及说明

**看好参数或者问下 LLM 在用，别直接复制。特别是探索部分。**

> 完整的 sysctl 配置文件可复制自 [这里](./sysctl.conf)。

全局参考文档：

- `[net.ipv4/ipv6](https://www.kernel.org/doc/html/latest/networking/ip-sysctl.html)` 。
- `[net.core](https://www.kernel.org/doc/html/latest/admin-guide/sysctl/net.html)` 。

## DN11 组网相关

### 1. 开启 IPv4 转发

```conf
net.ipv4.ip_forward = 1
net.ipv4.conf.all.forwarding = 1
net.ipv4.conf.default.forwarding = 1
net.ipv6.conf.all.forwarding = 1
net.ipv6.conf.default.forwarding = 1
```

### 2. 源地址检查

```conf
net.ipv4.conf.all.rp_filter = 0
net.ipv4.conf.default.rp_filter = 0
```

如果在内网中还有使 `anycast` ，则还需要下面这两条。

```conf
net.ipv4.conf.all.accept_local = 1
net.ipv4.conf.default.accept_local = 1
```

### 3. RFC 1323 时间戳

```conf
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_tw_reuse = 1
```

## 联网功能

### 1. Kernel RA

打开特定接口上的 RA 功能，使得内网主机可以通过 Router Advertisement 自动获取 IPv6 地址。

则通常比 `luci` 或者 `NetworkManager` 更加可靠。

```conf
net.ipv6.conf.<iface>.accept_ra = 2
```

但请注意， `Kernel RA` 获取的路由无法被 `luci` 写到其他路由表。

如果需要选择性拒绝 RA 中的某些参数，可以使用 `accept_ra_<param>` 选项。

## 网络调优

### 1. netfilter

参考自 iKuai 的超时时间等配置。

```conf
net.netfilter.nf_conntrack_max = 2097152
net.netfilter.nf_conntrack_acct = 1
net.netfilter.nf_conntrack_checksum = 0
net.netfilter.nf_conntrack_tcp_be_liberal = 1

net.netfilter.nf_conntrack_icmp_timeout = 20
net.netfilter.nf_conntrack_icmpv6_timeout = 30
net.netfilter.nf_conntrack_tcp_timeout_close = 5
net.netfilter.nf_conntrack_tcp_timeout_close_wait = 10
net.netfilter.nf_conntrack_tcp_timeout_established = 1800
net.netfilter.nf_conntrack_tcp_timeout_fin_wait = 10
net.netfilter.nf_conntrack_tcp_timeout_last_ack = 10
net.netfilter.nf_conntrack_tcp_timeout_syn_recv = 5
net.netfilter.nf_conntrack_tcp_timeout_syn_sent = 5
net.netfilter.nf_conntrack_tcp_timeout_time_wait = 10
net.netfilter.nf_conntrack_udp_timeout = 10
net.netfilter.nf_conntrack_udp_timeout_stream = 60
```

### 2. net.core

套接字缓冲区、接口缓冲区、GRO、队列

```conf
net.core.rmem_default = 4194304
net.core.wmem_default = 4194304
net.core.rmem_max = 33554432
net.core.wmem_max = 33554432

net.core.netdev_budget = 600
net.core.netdev_max_backlog = 4096

net.core.gro_normal_batch=16

net.core.default_qdisc = cake
```

### 3. BBR

OpenWRT 上可能需要 `opkg install kmod-tcp-bbr` 。

```conf
net.ipv4.tcp_congestion_control = bbr
```

### 4. net.ipv4.tcp_*

keepalive、关闭 ecn、闲置后不慢启动

```conf
net.ipv4.tcp_keepalive_intvl=10
net.ipv4.tcp_keepalive_probes=6
net.ipv4.tcp_keepalive_time=120

net.ipv4.tcp_ecn = 0
net.ipv4.tcp_slow_start_after_idle = 0
```

### 5. net

缓冲区、邻居表、unix 队列最大长度

```conf
net.ipv4.tcp_rmem = 4096 87380 33554432
net.ipv4.tcp_wmem = 4096 16384 33554432
net.ipv4.udp_rmem_min = 8192
net.ipv4.udp_wmem_min = 8192

net.ipv4.neigh.default.gc_thresh1 = 16384
net.ipv4.neigh.default.gc_thresh2 = 16384
net.ipv4.neigh.default.gc_thresh3 = 32768

net.unix.max_dgram_qlen = 2048
```

## 系统调优

### 1. fs.file-max

全局最大文件句柄数

```conf
fs.file-max = 1048576
```

### 2. vm.swappiness

虚拟内存积极性

```conf
vm.swappiness = 30
```

小内存设备开启超分

```conf
vm.overcommit_memory = 1
```

### 3. kernel.msg*

消息队列

```conf
kernel.msgmnb = 65536
kernel.msgmax = 65536
```

## 探索性功能

### 1. ECMP

主要用于 `OSPF` 内网做负载或者大带宽。

参考配置为 srcip + srcport + dstip + dstport + protool.

```conf
net.ipv4.fib_multipath_hash_policy = 3
net.ipv4.fib_multipath_hash_fields = 55
net.ipv6.fib_multipath_hash_policy = 3
net.ipv6.fib_multipath_hash_fields = 55
```

### 2. TCP Fast Open

需要 `客户端` 和 `服务器` 都支持.

[外部参考](https://blog.csdn.net/wangquan1992/article/details/128533603)

```conf
net.ipv4.tcp_fastopen = 3
```

### 3. MPTCP

（默认）

（暂无人尝试）

[外部参考](https://blog.csdn.net/puhaiyang/article/details/144865112)

```conf
net.mptcp.enabled = 1
```

### 4. ip redirects

```conf
net.ipv4.conf.all.send_redirects = 1
net.ipv4.conf.default.send_redirects = 1
net.ipv4.conf.all.accept_redirects = 1
net.ipv4.conf.default.accept_redirects = 1
```

### 5. route_localnet

```conf
net.ipv4.conf.all.route_localnet = 1
net.ipv4.conf.default.route_localnet = 1
```

### 6. net.ipv4.tcp_*

```conf
net.ipv4.tcp_no_metrics_save = 1 # 不保存 TCP 连接的度量信息
net.ipv4.tcp_frto = 0 # 禁用前向重传优化
net.ipv4.tcp_mtu_probing = 1 # 启用 TCP MTU 探测以避免分片
net.ipv4.tcp_notsent_lowat = 16384 # 设置未发送数据的低水位标记 - 小包等待
```
