class HomesController < ApplicationController
  def top
    # @randm = Post.order("RANDOM()").limit(6)
    @random = Post.find(Post.pluck(:id).shuffle[0..5])
    # pp "ここ", @random
  end
end
