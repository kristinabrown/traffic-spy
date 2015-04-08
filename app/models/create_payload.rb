class CreatePayload
  def initialize(payload)
    @payload = payload
  end

  def status
    if @payload == {}
      400
    elsif @payload.save
      200
    else
      403
    end
  end

  def body
    if @payload.save
      #"{'identifier':'#{@payload[:identifier]}'}"
    else
      @payload.errors.full_messages
    end
  end
end

# Missing Payload - 400 Bad Request
#
# If the payload is missing return status 400 Bad Request with a descriptive error message.
#
# Already Received Request - 403 Forbidden
#
# If the request payload has already been received return status 403 Forbidden with a descriptive error message.
#
# Application Not Registered - 403 Forbidden
#
# When data is submitted to an application URL that does not exist, return a 403 Forbidden with a descriptive error message.
#
# Success - 200 OK
#
# When the request contains a unique payload return status 200 OK
