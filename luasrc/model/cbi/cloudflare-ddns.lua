local m, s, o

m = Map("cloudflare-ddns", translate("Cloudflare DDNS"),
    translate("动态更新您的Cloudflare DNS记录"))

s = m:section(TypedSection, "cloudflare", translate("基本设置"))
s.anonymous = true
s.addremove = false

o = s:option(Flag, "enabled", translate("启用"))
o.rmempty = false

o = s:option(Value, "api_token", translate("API Token"))
o.password = true
o.rmempty = false

o = s:option(Value, "domain", translate("域名"))
o.description = translate("完整域名，例如: test.example.com")
o.rmempty = false

o = s:option(Value, "record_type", translate("记录类型"))
o:value("A", "A")
o:value("AAAA", "AAAA")
o.default = "A"
o.rmempty = false

o = s:option(ListValue, "ip_source", translate("IP获取方式"))
o:value("web", translate("从网络获取"))
o:value("interface", translate("从网卡获取"))
o.default = "web"
o.rmempty = false

o = s:option(ListValue, "interface", translate("网卡"))
for _, iface in ipairs(nixio.getifaddrs()) do
    if iface.addr and iface.name ~= "lo" then
        o:value(iface.name)
    end
end
o:depends("ip_source", "interface")

o = s:option(Flag, "proxied", translate("开启Cloudflare代理"))
o.default = false
o.rmempty = false

o = s:option(Value, "update_interval", translate("更新间隔(秒)"))
o.datatype = "uinteger"
o.default = 300
o.rmempty = false

return m 
