module Timewarp
  def self.freeze(frozen_time, &block)
    control_timeline proc {frozen_time}, &block
  end

  def self.control_timeline(timeline_proc)
    (class <<Time; self; end).class_eval do
      alias original_now now
      define_method(:now) { timeline_proc.call }
    end
    yield
  ensure
    (class <<Time; self; end).class_eval do
      alias now original_now
      remove_method :original_now
    end
  end
end
