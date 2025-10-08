# Mikrotik RouterOS Implement for DN11 Standard Large Communities

RouterOS 没法使用变量，这里以 ASN 4220080300 为例实现 filter

请在使用前将

- 4220080300 替换为你的 ASN
- 52 替换为你的 World Code （共2处）
- 156 替换为你的 Country Code （共2处）
- 42 替换为你的 Region Code （共2处）
- 33 替换为你的 Province Code （共2处）

替换时注意不要误伤其他配置，请人工校验

特别注意，`cross.rsc` 中用于匹配 community 的四个形如 `^(422008|421111)[0-9]+:11000:([^1][0-9]|[0-9][^2]|[0-9]|[0-9][0-9][0-9]+)$` 的正则也需要替换，由于较为复杂，可以使用提供的 `gen_re.py` 输入自己的地区码生成。

最后请将 `cross.rsc` 和 `pref.rsc` 的内容按顺序放在 import filter 中任何 accept 前的位置，将 `geo.rsc` 的内容放在 export filter 任何 accept 前的位置。

## Other Notices

1. 这套规则和 bird 版本实现方法完全不一样，效果相近。已知在 bird 版本会认为 as_path 中未设置 geocode 的是跨省，而在该规则中，只有 path 上所有 as 都未设置时才回落到跨省，且无法对齐。
2. 目前 ros 的 `if (bgp-large-communities xxx) {xxx} else {xxx}` 语句在 bgp-large-communites 为空时既不会走 if 也不会走 else，而会跳过整个 if-else 语句，已 work around。
