module V0
  class DevicesController < ApplicationController

    before_action :check_if_authorized!, only: [:create]
    after_action :verify_authorized,
      except: [:index, :world_map, :fresh_world_map]

    def show
      @device = Device.includes(
        :kit, :owner, :sensors,:tags).find(params[:id])
      authorize @device
      @device
    end

    def index
      @q = Device.includes(
        :kit, :sensors, :components, :owner, :tags).ransack(params[:q])

      if params[:with_tags]
        @q = Device.with_user_tags(
          params[:with_tags]).includes(
            :kit, :sensors, :components, :owner,:tags).ransack(params[:q])
      end

      @devices = @q.result(distinct: true)

      if params[:near]
        if params[:near] =~ /\A(\-?\d+(\.\d+)?),\s*(\-?\d+(\.\d+)?)\z/
          @devices = @devices.near(
            params[:near].split(','), (params[:within] || 1000))
        else
          return render json: { id: "bad_request",
            message: "Malformed near parameter",
            url: 'https://developer.smartcitizen.me/#get-all-devices',
            errors: nil }, status: :bad_request
        end
      end

      @devices = paginate(@devices)
    end

    def update
      @device = Device.find(params[:id])
      authorize @device
      if @device.update_attributes(device_params)
        render :show, status: :ok
      else
        raise Smartcitizen::UnprocessableEntity.new @device.errors
      end
    end

    def create
      @device = current_user.devices.build(device_params)
      authorize @device
      if @device.save
        render :show, status: :created
      else
        raise Smartcitizen::UnprocessableEntity.new @device.errors
      end
    end

    def destroy
      @device = Device.find(params[:id])
      authorize @device
      if @device.archive!
        render json: {message: 'OK'}, status: :ok
      else
        raise Smartcitizen::UnprocessableEntity.new @device.errors
      end
    end

    # debug method, must be refactored
    def fresh_world_map
      @devices = Device.where.not(latitude: nil).where.not(data: nil).includes(:owner,:tags).map do |device|
        {
          id: device.id,
          name: device.name,
          description: (device.description.present? ? device.description : nil),
          owner_id: device.owner_id,
          owner_username: device.owner_id ? device.owner_username : nil,
          latitude: device.latitude,
          longitude: device.longitude,
          city: device.city,
          country_code: device.country_code,
          kit_id: device.kit_id,
          state: device.state,
          system_tags: device.system_tags,
          user_tags: device.user_tags,
          added_at: device.added_at,
          updated_at: device.updated_at,
          last_reading_at: (device.last_reading_at.present? ? device.last_reading_at : nil)
        }
      end
      render json: @devices
    end

    def world_map
      unless params[:cachebuster]
        expires_in 30.seconds, public: true # CRON cURL every 60 seconds to cache
      end
      @devices = Device.where.not(latitude: nil).where.not(data: nil).includes(:owner,:tags).map do |device|
        {
          id: device.id,
          name: device.name,
          description: (device.description.present? ? device.description : nil),
          owner_id: device.owner_id,
          owner_username: device.owner_id ? device.owner_username : nil,
          latitude: device.latitude,
          longitude: device.longitude,
          city: device.city,
          country_code: device.country_code,
          kit_id: device.kit_id,
          state: device.state,
          system_tags: device.system_tags,
          user_tags: device.user_tags,
          added_at: device.added_at,
          updated_at: device.updated_at,
          last_reading_at: (device.last_reading_at.present? ? device.last_reading_at : nil)
        }
      end
      render json: @devices
    end

private

    def device_params
      params.permit(
        :name,
        :description,
        :mac_address,
        :latitude,
        :longitude,
        :elevation,
        :device_token,
        :exposure,
        :meta,
        :kit_id,
        :user_tags
      )
    end

  end
end
