module VideoPlayerHelper

  def insert_player
    if is_allowable_ip?(request.remote_ip)
      unless @document[:access_file_s].nil?
        render :partial => "player/jw_player"
      end
    end
  end


  def is_allowable_ip?(ip)
    if ip.match(/^127\.0\.0\.1$/)
      return true
    elsif ip.match(/^192\.168\.250/)
      return true
    elsif ip.match(/^192\.168\.251/)
      return true
    elsif ip.match(/^192\.168\.252/)
      return true
    else
      return false
    end
  end

end