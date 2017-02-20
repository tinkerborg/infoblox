##
# ZoneAuth is only availabe in WAPI_VERSION >= 2.2
#
module Infoblox 
  module ServiceRestart
    class Request < Resource
      remote_attr_reader :group,
                         :result,
                         :state

      wapi_object "grid:servicerestart:request"
    end
  end
end
