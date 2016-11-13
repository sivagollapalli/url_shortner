module Api::V1
  class ShortUrlsController < ApiController
    before_action :authenticate
    before_action :set_short_url, only: [:show, :update, :destroy]

    # GET /api/v1/short_urls
    def index
      @short_urls = ShortUrl.all

      render json: @short_urls.as_json
    end

    # GET /api/v1/short_urls/1
    def show
      geolocate_url
      render json: @short_url
    end

    # POST /api/v1/short_urls
    def create
      @short_url = ShortUrl.new(short_url_params.merge(user: current_user))

      if @short_url.save
        render json: @short_url, status: :created
      else
        render json: @short_url.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/short_urls/1
    def update
      if @short_url.update(short_url_params)
        render json: @short_url
      else
        render json: @short_url.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/short_urls/1
    def destroy
      @short_url.destroy
    end

    private

    def set_short_url
      @short_url = ShortUrl.find(params[:id])
    end

    def short_url_params
      params.require(:short_url).permit(:original_url)
    end

    def geolocate_url
      res = JSON.parse(Curl.get("http://freegeoip.net/json/#{request.remote_ip}").body_str) 
      @short_url.visits.create(visitor_ip: res['ip'], visitor_city: res['city'],
                               visitor_state: res['region_name'], visitor_country_iso2: res['country'])
    end
  end
end
