class ObjectsController < ApplicationController
  respond_to :json
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  def not_found
    render json: {error: "not_found"}, status: :not_found
  end

  def index
    render json: Hash[ObjectLink.limit(50).all.map{|ol|
      [ol.id, ol.payload]
    }]
  end

  def show
    @object = ObjectLink.find(params[:id])
    render_object
  end

  def create
    dbo = DbObject.create(payload: params[:payload], id: params[:uuid])
    @object = ObjectLink.create(db_object_id: dbo.id, name: params[:name])
    render json: @object.payload, status: 201
  end

  def update
    @object = ObjectLink.find(params[:id])
    @object.with_lock do
      if(@object.db_object_id == params[:old_id])
        @dbo = DbObject.create(payload: params[:payload], parent_id: params[:old_id])
        @object.db_object = @dbo ; @object.save!
        render_object
      else
        render json: @object.payload, status: 409
      end
    end
  end

  def destroy
    @object = ObjectLink.find(params[:id])
    @object.with_lock do
      @object.delete
    end
    head 204
  end

  private
  def render_object
    render :json => @object.payload
  end
end
