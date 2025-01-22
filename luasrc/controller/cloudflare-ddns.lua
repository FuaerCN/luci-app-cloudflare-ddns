module("luci.controller.cloudflare-ddns", package.seeall)

function index()
    if not nixio.fs.access("/etc/config/cloudflare-ddns") then
        return
    end

    entry({"admin", "services", "cloudflare-ddns"}, cbi("cloudflare-ddns"), _("Cloudflare DDNS"), 60)
end 
