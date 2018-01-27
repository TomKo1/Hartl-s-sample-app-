class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
def hello
	render html: "hello, world!"
end
include SessionsHelper # we arrange to make
# sessions helpers available on all our controllers
end
