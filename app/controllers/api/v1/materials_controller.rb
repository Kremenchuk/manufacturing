class Api::V1::MaterialsController < Api::V1::ApplicationApiController


  def index
    render json: Material.all.as_json
  end

end