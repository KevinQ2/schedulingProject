module SessionsHelper
  def log_out
    session.delete(:username)
  end
end
