module VideoPlayerHelper

  def insert_player
    if is_allowable_ip?(request.remote_ip)
      unless @document[:access_file_s].nil?
        render :partial => "player/flowplayer"
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
    elsif ip.match(/^207\.206\.49/)
      return true
    else
      return false
    end
  end

  def flowplayer_playlist
    results = Array.new
    count = 1
    @document[:access_file_s].each do |video|
      path = File.join(@document[:id].gsub(/:/,"_"),"data",video)
      results << "{title: 'Part #{count.to_s}', url: 'mp4:#{path}'}"
      count = count + 1
    end
    return results.join(",").to_s
  end

end