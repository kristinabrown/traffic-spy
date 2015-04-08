class CreatePayload
  def initialize(payload)
    @payload = payload
  end

  def status
    if Payload.where(url_id: @payload.url_id, requested_at: @payload.requested_at, user_agent_id: @payload.user_agent_id) == [] 
      @payload.save
      200
    else
      403
    end
  end

  def body
    if  Payload.where(url_id: @payload.url_id, requested_at: @payload.requested_at, user_agent_id: @payload.user_agent_id) == [] 
      "success"
    else
      "Duplicate payload request"
    end
  end
  
  def missing_identifier_status
    403
  end
  
  def missing_identifier_body
    "Identifier doesn't exist"
  end
end
