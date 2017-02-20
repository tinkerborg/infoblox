# Taken from https://github.com/IMPIMBA/infoblox
# Credit where credit is due.
#
module Infoblox
  class Grid < Resource
    remote_attr_reader   :audit_to_syslog_enable,
                         :external_syslog_server_enable,
                         :password_setting,
                         :security_banner_setting,
                         :security_setting,
                         :snmp_setting,
                         :syslog_facility,
                         :syslog_servers,
                         :syslog_size

    wapi_object "grid"

    def delete
      raise "Not supported"
    end

    def create
      raise "Not supported"
    end

    def modify
      raise "Not supported"
    end

    def self.get(connection)
      JSON.parse(connection.get(resource_uri).body).map do |jobj|
        klass = resource_map[jobj["_ref"].split("/").first]
        if klass.nil?
          puts jobj['_ref']
          warn "umapped resource: #{jobj["_ref"]}"
        else
          klass.new(jobj.merge({:connection => connection}))
        end
      end.compact
    end

    # Example of a working post for restartservices
    # POST /wapi/v1.4/grid/b25lLmNsdXN0ZXIkMA:DNSone?_function=restartservices
    # &member_order=SEQUENTIALLY
    # &restart_option=RESTART_IF_NEEDED
    # &sequential_delay=15
    # &service_option=DHCP
    def restartservices(*args)
      post_body = args.length == 1 && args[0].is_a?(Hash) ? args[0] : {
        # support old method signature
          :member_order       => args[0] || "SEQUENTIALLY",
          :restart_option     => args[1] || "RESTART_IF_NEEDED",
          :sequential_delay   => args[2] || 15,
          :service_option     => args[3] || "DHCP"
      } 
      JSON.parse(connection.post(resource_uri + "?_function=restartservices", post_body).body);
    end

  end
end
