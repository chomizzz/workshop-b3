class CommunityController < ApplicationController
  def index
    @my_community = current_user.community
    unless @my_community.nil?
      @communities = Community.all.where.not(name: @my_community.name)
      @locations = @communities.map do |c|
        {
          community: c.name,
          community_id: c.id,
          distance: Geocoder::Calculations.distance_between([ @my_community.location.latitude, @my_community.location.longitude ], [  c.location.latitude, c.location.longitude ], units: :km).round(2)
        }
      end
    end

    @items = @my_community.items
  end

  def community_show
    @community = Community.find(params[:id])
    @items = @community.items
  end

  def take_items
    @item = Item.find(params[:item_id])
    quantity_taken = params[:quantity].to_i

    if quantity_taken > 0 && quantity_taken <= @item.quantity
      # Diminue la quantité de l'item original
      @item.update(quantity: @item.quantity - quantity_taken)

      # Vérifie si la communauté de l'utilisateur a déjà cet item
      target_item = current_user.community.items.find_by(name: @item.name)

      if target_item
        # Ajoute la quantité prise à l'item existant
        target_item.update(quantity: target_item.quantity + quantity_taken)
      else
        # Crée un nouvel item pour la communauté de l'utilisateur
        Item.create!(
          name: @item.name,
          quantity: quantity_taken,
          unit: @item.unit,
          community: current_user.community
        )
      end

      flash[:notice] = "You have taken #{quantity_taken} #{@item.unit} of #{@item.name}."
    else
      flash[:alert] = "Invalid quantity."
    end

      redirect_to community_show_path(params[:community_id])
  end
end
