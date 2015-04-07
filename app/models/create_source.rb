class CreateSource #< ActiveRecord::Base
  def initialize(source)
    @source = source
  end
  
  def status
    if @source[:identifier] == nil || @source[:root_url] == nil
      400
    elsif @source.save
      200
    else
      403
    end
  end
  
  def body
    if @source.save
      "{'identifier':'#{@source[:identifier]}'}"
    else
      @source.errors.full_messages
    end
  end
end