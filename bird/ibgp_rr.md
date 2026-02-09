# ibgp RR 模板的说明

参考拓扑

```text
        R1---------R2---------O
         |\       /|
         | \     / |
         |  \   /  |
         |   \ /   |
         |    X    |
         |   / \   |
         |  /   \  |
         | /     \ |
        C1---------C2
```

在上图中，R1 和 R2 是两个 iBGP 路由反射器（RR），C1 和 C2 是它们的客户端，O 是一个非客户端的 iBGP 对等体。

- C1 - C2 `最基本的 iBGP 对等体`
  - 模板：`ibgp_peers`
  - 效果：互相交换 `EBGP` 路由。
- Rx - Cx
  - 模板：`ibgp_rr` - `ibgp_rr_client`
  - 效果：client 会给 RR 发送路由，RR 会反射其他 client 的路由给 client。
  - 注意：多级 rr 或者多个 rr 集群请根据实际情况调整 cluster id。
- R1 - R2
  - 模板：`ibgp_rrs`
  - 效果：RR 之间互相交换所有路由，形成互为备份的效果。
  - 注意：会导致 rr_client 接收路由增加，内存占用增加。
  - 变体：如果不需要互为备份则需要加上 `rr cluster id`，但会导致 `C1 - R1 - R2 - C2` 的情况下 `C1` 和 `C2` 之间无法互相学习路由。
- Rx - O `非 client 的 iBGP 对等体`
  - 模板：`ibgp_peers`
  - 效果：RR 会接受 O 的路由，并反射给 client；O 会接受 RR 反射的来自 client 的路由。
