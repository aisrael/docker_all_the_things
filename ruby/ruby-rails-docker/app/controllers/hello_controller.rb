class HelloController < ApplicationController
  def hello
    @who = params['who'] || 'world'
  end
end
