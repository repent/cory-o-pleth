require 'logger'

# Add "include Logging" to classes whenever you want to log from them
# Then access as log.warn etc

module Cory
  module Logging
    # This is the magical bit that gets mixed into your classes
    def log
      Logging.log
    end
  
    # Global, memoized, lazy initialized instance of a logger
    def self.log
      @log ||= Logger.new(STDOUT)
    end
  end
end

# Because the Logging#logger method can access the instance that the module is mixed into, it is trivial to extend your logging module to record the classname with log messages:
# 
# module Logging
#   def logger
#     @logger ||= Logging.logger_for(self.class.name)
#   end
# 
#   # Use a hash class-ivar to cache a unique Logger per class:
#   @loggers = {}
# 
#   class << self
#     def logger_for(classname)
#       @loggers[classname] ||= configure_logger_for(classname)
#     end
# 
#     def configure_logger_for(classname)
#       logger = Logger.new(STDOUT)
#       logger.progname = classname
#       logger
#     end
#   end
# end
# 
# Your Widget now logs messages with its classname, and didn't need to change one bit :)