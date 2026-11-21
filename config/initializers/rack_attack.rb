# frozen_string_literal: true

# Rate limiting / brute-force & abuse protection.
# Uses the Rails cache store for counters (memory store by default in dev/test).
class Rack::Attack
  # Dedicated counter store so throttling works even when the app's cache is the
  # null store (Rails dev default). For multi-process production, point this at a
  # shared store (Redis/Memcached) so counters are shared across workers.
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  ### Allow-list ###
  # Never throttle local traffic (dev, health checks).
  safelist("allow-localhost") do |req|
    ["127.0.0.1", "::1"].include?(req.ip)
  end

  ### Throttles ###
  # All requests by IP: a wide backstop against scraping/floods.
  throttle("req/ip", limit: 300, period: 5.minutes, &:ip)

  # Login attempts by IP (brute force).
  throttle("logins/ip", limit: 10, period: 20.seconds) do |req|
    req.ip if req.path == "/users/sign_in" && req.post?
  end

  # Login attempts by email (credential stuffing against one account).
  throttle("logins/email", limit: 10, period: 1.minute) do |req|
    if req.path == "/users/sign_in" && req.post?
      req.params.dig("user", "email").to_s.downcase.strip.presence
    end
  end

  # Sign-ups by IP (spam account creation).
  throttle("signups/ip", limit: 5, period: 1.minute) do |req|
    req.ip if req.path == "/users" && req.post?
  end

  # Password-reset requests by IP (enumeration / mail-bomb).
  throttle("password-resets/ip", limit: 5, period: 1.minute) do |req|
    req.ip if req.path == "/users/password" && req.post?
  end

  ### Response for throttled requests ###
  self.throttled_responder = lambda do |_request|
    [429, { "Content-Type" => "text/plain" }, ["Too many requests. Please retry later.\n"]]
  end
end
