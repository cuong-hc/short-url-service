module Api
  module ErrorFormatter
    def error_format errors, code, messages
      msg = ""
      
      #if messages is a custom string message
      if messages.is_a? String 
        msg = messages
      end
      
      #if messages is a array message from model
      if  messages.is_a? Array
        messages.each do |i|
          msg = msg + i + " - "
        end
        msg = msg.chomp(" - ")
      end
      
      {:error => {:errors => errors, :code => code, :message => msg }}
    end
  end
end
