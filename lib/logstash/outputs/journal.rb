# encoding: utf-8
require "logstash/outputs/base"
require "logstash/namespace"
require "systemd/journal"

# TODO: Codec

def save_log(message, priority, extra={})
  message = {
    :message => message,
    :priority => priority,
  }
  
  final_message = extra.merge message
  Systemd::Journal.message final_message
end


# An journal output that does nothing.
class LogStash::Outputs::Journal < LogStash::Outputs::Base
  config_name "journal"
  concurrency :single

  config :priority, :validate => :string, :required => true

  public
  def register
  end # def register

  public
  def receive(event)
    message = event.get("[message]")
    journal = event.get("[journal]")
    journal ||= {}
    unless journal.is_a? Hash
      @logger.warn("[journal] must be hash, or empty") 
      journal = {}
    end

    # If priorty is not ok, log error and set it to 3 = syslog error
    priority = Integer @priority rescue 
    begin 
      @logger.warn "Wrong format of priority, expected number, got #{@priority} "
      3 # Value of error log in journal
    end
    unless priority.between?(0, 8)  # TODO: Check this range
      @logger.warn "Priority must be in range 0-8, got #{priority}"
      priority = 3
    end

    save_log(message, priority, journal)
    return "Event received"
  end # def event


end # class LogStash::Outputs::Journal
