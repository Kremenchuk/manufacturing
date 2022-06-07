class Api::V1::JobsController < Api::V1::ApplicationApiController


  def index
    render json: Job.all.as_json
  end


end