$redis = Redis::Namespace.new('ai_pay', :redis => Redis.new) unless $redis