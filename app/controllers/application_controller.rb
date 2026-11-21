# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Fail closed: any authorization failure is turned into a safe redirect
  # instead of leaking a 500 or, worse, performing the action.
  rescue_from CanCan::AccessDenied do |_exception|
    respond_to do |format|
      format.html { redirect_to(root_path, alert: 'You are not authorized to perform that action.') }
      format.json { render(json: { error: 'forbidden' }, status: :forbidden) }
      format.any  { head(:forbidden) }
    end
  end

  # Surface missing records as 404s rather than unhandled 500s.
  rescue_from ActiveRecord::RecordNotFound do
    respond_to do |format|
      format.html { redirect_to(root_path, alert: 'The requested resource could not be found.') }
      format.json { render(json: { error: 'not_found' }, status: :not_found) }
      format.any  { head(:not_found) }
    end
  end
end
