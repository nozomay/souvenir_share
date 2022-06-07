class HomesController < ApplicationController
  def top
    # @random = Post.order("RANDOM()").limit(6)
    @random = Post.find(Post.pluck(:id).shuffle[0..5])
    pp @random
  end
end
