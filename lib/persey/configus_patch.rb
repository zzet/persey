# frozen_string_literal: true

class Configus::Config
  def method_missing(meth, *args, &blk)
    if Persey.config.to_hash.has_key?(meth)
      Persey.config.send(meth)
    else
      raise "'#{meth}' key does not exist in your config"
    end
  end
end
