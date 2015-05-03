module V0
  class StaticController < ApplicationController

    skip_after_action :verify_authorized

    def home
      render json: {
        current_user_url: v0_me_index_url,
        # components_url: v0_components_url,
        devices_url: v0_devices_url,
        kits_url: v0_kits_url,
        sensors_url: v0_sensors_url,
        users_url: v0_users_url
      }
    end

    def search
      paginate json: PgSearch.multisearch(params[:q])
    end

  end
end
