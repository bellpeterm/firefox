case node[:platform]
when "mac_os_x","mac_os_x_server"
  default["firefox"]["dir"] = "/Applications/Firefox.app/Contents/MacOS"
when "windows"
  default["firefox"]["dir"] = "C:/Program\ Files\ \(x86\)/Mozilla\ Firefox"
else
  default["firefox"]["dir"] = "/usr/lib/firefox"
end

default['firefox']['global_extensions'] = true
default['firefox']['dmg_source'] = "http://releases.mozilla.org/pub/mozilla.org/firefox/releases/latest/mac/en-US/Firefox 26.0.dmg"
