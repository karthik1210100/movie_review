# Security Review & VAPT Report — Movie Review

**Date:** 2026-11-21
**Scope:** Full application (Rails app code, configuration, dependencies).
**Methodology:** Manual code review (authN/authZ, injection, access control, config)
+ automated SAST (Brakeman) + dependency CVE scanning (bundler-audit) + a browser
smoke test for CSP/asset regressions.

## Summary

| Area | Before | After |
|------|--------|-------|
| Broken access control (IDOR) | Any logged-in user could edit/delete **any** movie, review or comment | Ownership enforced via CanCanCan + `authorize!` in every mutating action |
| CSRF | Sign-out and email-sending exposed over **GET** | Removed; state changes are POST/DELETE with CSRF tokens |
| Stored iframe/XSS (trailer) | Arbitrary URL rendered in an `<iframe src>` | Only a validated, canonical YouTube embed URL is stored/rendered |
| Rating integrity | Any integer accepted; averages could be poisoned | Validated `1..5`, one rating per user (DB unique index) |
| Transport/headers | No HSTS, CSP disabled | `force_ssl`, nonce-based CSP, `frame_ancestors` anti-clickjacking |
| Dependencies | Rails 7.0.4 + many **Critical/High** CVEs | Rails 8.1.4, **0** known CVEs (bundler-audit clean) |
| Brakeman | n/a | **0** warnings |

## Findings

### 1. Broken Access Control / IDOR — **Critical** — Fixed
Controllers performed **no** authorization (only `reviews#edit` called `authorize!`).
`Ability` granted `can :manage, :all` but it was never enforced, so any authenticated
user could `PATCH`/`DELETE` another user's movies, reviews and comments by guessing IDs.

**Fix:** Rewrote `Ability` with least-privilege, ownership-scoped rules
(`app/models/ability.rb`); added `authorize!` before every `edit/update/destroy` in
`MoviesController`, `ReviewsController`, `UserReviewCommentsController`; nested lookups
are scoped through the parent (`@movie.reviews.find`) as defense-in-depth;
`CanCan::AccessDenied` is rescued to a safe redirect (fail-closed).
**Regression test:** `spec/requests/movies_authorization_spec.rb`.

### 2. CSRF via state-changing GET routes — **High** — Fixed
`get 'users/sign_out'`, `get 'send_welcome_email'`, `get 'account_cancelled_email'`
allowed logout and **email sending** to be triggered by a simple `<img>`/link (CSRF,
mail-bombing; one route targeted a non-existent action → 500). The logout link rendered
as a GET under Turbo, which is why the insecure route existed.

**Fix:** Removed all three routes; logout is now a Turbo-safe `button_to` DELETE form
with a CSRF token; welcome email is sent automatically on sign-up only.

### 3. Trailer `iframe` injection — **High** — Fixed
`trailer_url` accepted any string and was interpolated into an `<iframe src>`. Non-YouTube
input (including `javascript:`/`data:` URIs and arbitrary origins) was rendered verbatim.

**Fix:** `Movie` now canonicalizes and validates the trailer to
`https://www.youtube.com/embed/<id>` only (`http(s)` + strict host + 11-char id);
anything else fails validation. The view uses `safe_trailer_embed_url` (re-checks the
pattern) and adds `sandbox`/`referrerpolicy` on the iframe.
**Tests:** `spec/models/movie_spec.rb`.

### 4. Rating integrity — **Medium** — Fixed
`MovieRating` had no validation; any integer was accepted and the denormalized
`average_rating` could be skewed. The post-save notice logic was also buggy
(`new_record?` after `save` is always false) with no failure branch.

**Fix:** `validates :rating, inclusion: 1..5, numericality: integer`; uniqueness per
`(user, movie)` backed by a DB unique index; controller captures `new_record?` before
save and handles failure. **Tests:** `spec/models/movie_rating_spec.rb`.

### 5. LIKE-wildcard handling in search — **Low** — Fixed
`name_search` interpolated the query into `LIKE` without escaping `%`/`_`.

**Fix:** `sanitize_sql_like` + an explicit `ESCAPE '\'` clause (required for SQLite/PG).

### 6. Transport & headers — **Medium** — Fixed
No HSTS/SSL enforcement; CSP initializer fully commented out; production used runtime
asset compilation.

**Fix:** `config.force_ssl` (+ `assume_ssl`) in production; a nonce-based Content Security
Policy with `object-src 'none'`, `frame-ancestors 'self'` (anti-clickjacking),
`form-action 'self'`, and an allow-list limited to the CDNs actually used;
`config.assets.compile = false`. **Note:** the CSP nonce generator uses `SecureRandom`
(not `request.session.id`, which is empty under the cookie store and would silently
disable every inline script — caught by the browser smoke test).

### 7. Weak password policy / account enumeration — **Medium** — Fixed
Devise minimum password length was 6 and recoverable responses were not paranoid.

**Fix:** `password_length = 8..128`, `config.paranoid = true`.

### 8. Secrets / IDE files in VCS — **Low** — Fixed
`.idea/` (including `dataSources.xml` with a local DB path) was committed.

**Fix:** Removed from VCS and git-ignored.

### 9. Vulnerable & EOL dependencies — **Critical/High** — Fixed
Rails 7.0.4 and its stack carried many unpatched CVEs (incl. Critical ActiveStorage/
ActionPack issues), on an **EOL** Ruby 3.1 and EOL Rails line.

**Fix:** Upgraded to **Rails 8.1.4**, **Ruby 3.3.14**, `puma 7`, `json 2.x`, patched
`sqlite3 2.x`, `addressable`, `msgpack`, `ruby-vips`, etc. `bundler-audit` now reports
**0 vulnerabilities**. Added `brakeman` + `bundler-audit` + `rubocop` as CI gates.

## Later additions (security-relevant)
- **Rate limiting (Rack::Attack):** throttles on login (by IP and by email), sign-up,
  and password-reset, plus a wide per-IP backstop, returning `429`. Localhost is
  safelisted. `config/initializers/rack_attack.rb`; tested in
  `spec/requests/rate_limiting_spec.rb`.
- **Email privacy:** user-facing pages (reviews, comments, rating breakdown,
  profiles) now show a `display_name` and link to a public profile instead of
  rendering the account email address.
- **Report-a-review:** users can flag reviews (reason from a fixed list, one per
  user per review) for moderation.

## Residual items / recommended follow-ups
- **Framework defaults:** the app runs Rails 8.1 with `config.load_defaults 7.0` (the safe
  incremental-upgrade posture). Bumping defaults to `8.1` should be done as a separate,
  test-backed change.
- **CDN assets without SRI:** Bootstrap/jQuery/Popper load from CDNs without Subresource
  Integrity. The CSP restricts their origins; adding SRI hashes (or vendoring) would
  further harden the supply chain.
- **Broaden test coverage:** request specs now cover authorization and the security
  invariants; review/comment ownership and the full rating flow could be expanded.

## How to reproduce the scans
```bash
bundle exec brakeman --no-pager        # SAST — expect 0 warnings
bundle exec bundle-audit check --update # CVE scan — expect 0 vulnerabilities
bundle exec rubocop                    # lint — expect 0 offenses
bundle exec rspec                      # tests — expect all green
```
