class CommunityController < ApplicationController
  def index
    @my_community = current_user.community
    unless @my_community.nil?
      @communities = Community.all.where.not(name: @my_community.name)
      @locations = @communities.map do |c|
        {
          community: c,
          distance: Geocoder::Calculations.distance_between([ @my_community.location.latitude, @my_community.location.longitude ], [  c.location.latitude, c.location.longitude ], units: :km)
        }
      end
    end
  end
end
