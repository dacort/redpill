require 'rubygems'
require 'download'
require 'apps'

%w{Chrome Echofon Adium OnePassword GitX Viscosity IStatMenus IStatPro RVM}.each do |app_name|
  app = "Apps::#{app_name}".split('::').inject(Object) { |k,n| k.const_get n }.new
  app.install
  app.post_install
end