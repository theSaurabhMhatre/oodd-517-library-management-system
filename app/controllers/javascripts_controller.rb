class JavascriptsController < ApplicationController
  before_action :authorize

  def dynamic_libraries
    @libraries = Library.all
  end
end
