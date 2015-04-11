module V0
  class DevicesController < ApplicationController

    before_action :check_if_authorized!, only: [:create, :update]
    after_action :verify_authorized, except: [:index, :world_map]

    # caches_action :world_map, expires_in: 2.minutes

    def world_map
      render json: ActiveModel::ArraySerializer.new(
          Device.includes(:owner,:kit),
          each_serializer: WorldMapDevicesSerializer
        )
      # json = Rails.cache.fetch("devices/world_map/1", expires_in: 5.seconds) do end
      # render_cached_json("devices:world_map", expires_in: 6.minutes, serializer: WorldMapDevicesSerializer) do
      #   @devices = Device.all#select(:id,:name,:description,:latitude,:longitude)
      # end
    end

    def index
      if params[:near]
        if params[:near] =~ /\A(\-?\d+(\.\d+)?),\s*(\-?\d+(\.\d+)?)\z/
          @devices = Device.includes(:sensors, :owner).near(params[:near].split(','), (params[:within] || 1000))
        else
          return render json: "error", status: :bad_request
        end
      else
        @devices = Device.includes(:sensors, :owner)
      end
      if ['created_at'].include?(params[:order])
        if ['asc', 'desc'].include?(params[:direction])
          @devices = @devices.order([params[:order],params[:direction]].join(' '))
        else
          @devices = @devices.order(params[:order])
        end
      else
        @devices = @devices.order(:id)
      end
      paginate json: @devices
    end

    def show
      @device = Device.find(params[:id])
      authorize @device
      render json: @device, serializer: DetailedDeviceSerializer
    end

    def update
      @device = current_user.devices.find(params[:id])
      authorize @device
      if @device.update_attributes(device_params)
        render json: @device, status: :ok
      else
        render json: { errors: @device.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def create
      @device = current_user.devices.build(device_params)
      authorize @device
      if @device.save
        render json: @device, status: :created
      else
        render json: { errors: @device.errors.full_messages }, status: :unprocessable_entity
      end
    end

private

    def device_params
      params.permit(
        :name,
        :description,
        :mac_address,
        :latitude,
        :longitude
      )
    end

  end
end
