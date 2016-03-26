#= require utils/device

if device.desktop()
  location.href = 'desktop/'
else
  location.href = 'mobile/'
