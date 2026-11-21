# frozen_string_literal: true

# Application-wide Content Security Policy (defense-in-depth against XSS /
# data-injection). Inline <script> blocks are allowed only via a per-request
# nonce; inline event handlers are disallowed. See:
# https://guides.rubyonrails.org/security.html#content-security-policy-header
Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self
    policy.base_uri    :self
    policy.object_src  :none
    policy.frame_ancestors :self                       # anti-clickjacking (modern X-Frame-Options)
    policy.form_action :self

    policy.font_src  :self, :data, "https://cdn.jsdelivr.net"
    policy.img_src   :self, :data,
                     "https://via.placeholder.com",
                     "https://ui-avatars.com"
    policy.style_src :self, :unsafe_inline,            # many view-level <style> blocks
                     "https://stackpath.bootstrapcdn.com",
                     "https://cdn.jsdelivr.net"
    policy.script_src :self,
                      "https://code.jquery.com",
                      "https://cdnjs.cloudflare.com",
                      "https://stackpath.bootstrapcdn.com"
    policy.frame_src  "https://www.youtube.com"        # movie trailers only
    policy.connect_src :self
  end

  # Inline <script> blocks must carry this nonce to execute (blocks injected JS).
  # A fresh random nonce per request — NOT request.session.id, which is empty
  # under the cookie session store and would silently disable every inline
  # script. Rails memoizes the value so the header and view helper agree.
  config.content_security_policy_nonce_generator = ->(_request) { SecureRandom.base64(16) }
  config.content_security_policy_nonce_directives = %w[script-src]
end
