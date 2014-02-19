require 'ipaddr'

module VideoPlayerHelper

  def insert_player
    if is_public? || is_allowable_ip? || Rails.env.match("development")
      render :partial => "player/flowplayer"
    else
      render :partial => "player/restricted_access"
    end
  end

  def is_allowable_ip? ip = request.remote_ip, result = false
    Rails.configuration.rockhall_config[:local_networks].each do |network|
      result = true if IPAddr.new(network) === ip
    end
    return result
  end

  def is_public?
    @component[Solrizer.solr_name("hydra_read_access", :displayable)].include?("public") unless @component[Solrizer.solr_name("hydra_read_access", :displayable)].nil?
  end

  def flowplayer_playlist
    results = Array.new
    count = 1
    @component[Solrizer.solr_name("access_file", :displayable)].each do |video|
      path = File.join(@component[:id].gsub(/:/,"_"),"data",video)
      results << "{title: 'Part #{count.to_s}', url: 'mp4:#{path}'}"
      count = count + 1
    end
    return results.join(",").to_s.html_safe
  end

  def rtmp_url
    url = URI(Rails.configuration.rockhall_config[:rtmp_url])
    url.query = @component[:id]
    return url.to_s
  end

end
