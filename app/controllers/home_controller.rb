class HomeController < ApplicationController
  before_action :authorize_request, only:[:version_manager]

  def version_manager
      data = VersionManager.find_by(device_type: params["device_type"])
      if data.app_version != params['version']
        data_hash = {
          "message" => data.message,
          "isForceUpdate" => data.is_soft_update,
          "isSoftUpdate" => data.is_soft_update
        }
        render json: data_hash, status: :ok
      else
        render json: {message: "Already up to date"}
      end
  end

private

  def version_manager_params
    params.require(:version_manager).permit(:device_type, :app_version, :is_hard_update, :is_soft_update, :message )
  end

end