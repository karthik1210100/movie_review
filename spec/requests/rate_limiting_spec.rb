# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Rate limiting (Rack::Attack)', type: :request do
  before { Rack::Attack.cache.store.clear }

  it 'throttles repeated sign-up attempts from one IP with a 429' do
    ip = '203.0.113.7' # non-localhost, so the safelist does not apply
    statuses = Array.new(7) do |i|
      post user_registration_path,
           params: { user: { email: "spam#{i}@example.com",
                             password: 'password123', password_confirmation: 'password123' } },
           headers: { 'REMOTE_ADDR' => ip }
      response.status
    end
    expect(statuses).to include(429) # limit is 5/min for sign-ups
  end

  it 'does not throttle localhost traffic' do
    statuses = Array.new(7) do |i|
      post user_registration_path,
           params: { user: { email: "ok#{i}@example.com",
                             password: 'password123', password_confirmation: 'password123' } },
           headers: { 'REMOTE_ADDR' => '127.0.0.1' }
      response.status
    end
    expect(statuses).not_to include(429)
  end
end
