require "systemd/journal"
require "date"


def send(aa)
  message = {
    :message => "[Missing message] (configure logstash-output-journal plugin)",
    :priority => 5,
  }
  Systemd::Journal.message(message.merge(aa))
end


# LOG_ERR     = 3
# LOG_WARNING = 4
# LOG_NOTICE  = 5
# LOG_INFO    = 6
# LOG_DEBUG   = 7

def to_priority(priority)

end

message = {
  message: "uhu"
}

send message
