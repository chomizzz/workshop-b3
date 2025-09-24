class UsersController < ApplicationController
  before_action :load_contacts

  def index
  end

  def find_contacts
  end

  def add_contact_and_create_conversation
    nickname = params[:nickname]
    user_to_add = User.find_by(nickname: nickname)

    if user_to_add.nil?
      flash.now[:error] = "Utilisateur introuvable"
    elsif user_to_add == current_user
      flash.now[:error] = "Vous ne pouvez pas vous ajouter vous-même"
    elsif current_user.contacts.include?(user_to_add)
      flash.now[:error] = "#{user_to_add.nickname} est déjà dans vos contacts"
    else
      current_user.add_contact(user_to_add)
      current_user.create_conversation(user_to_add)
      flash.now[:notice] = "#{user_to_add.nickname} a été ajouté à vos contacts"
    end

    render turbo_stream: [
      turbo_stream.update(
        "contacts_list",
        partial: "contacts_list",
        locals: { contacts: @contacts }
      ),
      turbo_stream.update(
        "flash_messages",
        partial: "shared/flash_messages"
      )
    ]
  end


  def remove_contact
    contact_to_remove = User.find(params[:contact_id])
    current_user.remove_contact(contact_to_remove)
    flash.now[:error] = "#{contact_to_remove.nickname} a été supprimé de vos contacts"

    render turbo_stream: [
      turbo_stream.update(
        "contacts_list",
        partial: "contacts_list",
        locals: { contacts: @contacts }
      ),
      turbo_stream.update(
        "flash_messages",
        partial: "shared/flash_messages"
      )
    ]
  end

  private

  def load_contacts
    @contacts = current_user.contacts
  end
end
