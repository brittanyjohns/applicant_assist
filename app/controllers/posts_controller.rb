class PostsController < ApplicationController
  def index
  end

  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.turbo_stream { render turbo_stream: turbo_stream.prepend("posts", partial: "post") }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end
end
