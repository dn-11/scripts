# Mikrotik RouterOS Implement for DN11 Standard Large Communities

RouterOS 没法使用变量，这里以 ASN 4220080300 为例实现 filter

请在使用前将

- 4220080300 替换为你的 ASN
- 52 替换为你的 World Code （共3处）
- 156 替换为你的 Country Code （共3处）
- 42 替换为你的 Region Code （共3处）
- 33 替换为你的 Province Code （共3处）

替换时注意不要误伤其他配置，请人工校验
