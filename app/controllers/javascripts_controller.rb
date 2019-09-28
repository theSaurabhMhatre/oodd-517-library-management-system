class JavascriptsController < ApplicationController
  def dynamic_libraries
    @libraries = Library.all
  end
end
