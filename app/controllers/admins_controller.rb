class AdminsController < AuthenticatedController
  before_action :require_admin
end
