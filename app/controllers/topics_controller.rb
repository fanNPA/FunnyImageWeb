class TopicsController < ApplicationController
	def index
		@topic = Topic.paginate(:page => params[:page], :per_page => 2).order(created_at: :desc)
		@newTopic = Topic.new
	end

	def show
		@newTopic = Topic.new
		@topic = Topic.find(params[:id])
		@topic.view+=1
		@topic.save
		
		@comments = Comment.where("topic_id = ?", params[:id]).order(created_at: :desc)
	end

	def new
		@newTopic = Topic.new
	end

	def create
		@newTopic = Topic.new(title: topic_params[:title],image: topic_params_post[:image],user_id: current_user.id)
		@newTopic.view = @newTopic.like = 0
		if @newTopic.save
			redirect_to @newTopic
		else
			render 'new'
		end
	end

	def edit	
	
	end

	def update
		@topic = Topic.find(params[:id])
		@topic.title = topic_params[:title]
		@topic.save
		redirect_to @topic
	end

	def destroy
		@topic = Topic.find(params[:id])
		@topic.destroy
		redirect_to topics_path
	end
	private
	def topic_params
		params.require(:topic)
	end
	def topic_params_post
		params.require(:topic).permit(:image, :title)
	end
end
