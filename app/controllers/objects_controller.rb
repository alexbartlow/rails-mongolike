class ObjectsController < ApplicationController
  respond_to :json
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def index
    render json: ObjectLink.limit(50).map(&:payload)
  end

  def show
    @object = ObjectLink.find(params[:id])
    render_object
  end

  def create
    render json: ObjectLink.new_object(params[:id], params[:uuid], params[:payload]), status: 201
  end

  def update
    @object = object_conditional_fetch
    if @object
      @object.update(params[:payload], params[:uuid])
      render_object
    else
      render_locked
    end
  end

  def destroy
    @object = object_conditional_fetch
    if @object
      @object.update({_deleted: true})
      render_object status: 204
    else
      render_locked
    end
  end

  private
  def render_object(opts = {})
    render(opts.merge(json: @object.payload))
  end

  def not_found
    render json: {error: "not_found"}, status: :not_found
  end

  def render_locked
    render json: {error: "locked"}, status: :locked
  end
 
  def object_conditional_fetch
    @object = ObjectLink.unscoped.where(db_object_id: params[:old_id], name: params[:id]).lock(true).first
  end
end
