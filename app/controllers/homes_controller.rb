class HomesController < ApplicationController
  def top
    @random = Post.order("RANDOM()").limit(6)
  end
end
