class RedisUtility
  def self.redis_delete_keys_with_pattern(pattern)
    k = $redis.keys("#{pattern}*")
    $redis.del(*k) if k.present?
  end
end