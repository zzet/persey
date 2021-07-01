class Configus::Config
  def method_missing(meth, *args, &blk)
    if Persey.config.to_hash.has_key?(meth)
      Persey.config.send(meth)
    elsif meth == :to_hash
      Persey.config.to_hash
    else
      raise "'#{meth}' key does not exist in your config"
    end
  end
end
