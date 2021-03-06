# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      if user.role == 'admin'
        can :manage, :all
      else
        can [:read, :destroy], User, id: user.id
        can [:read, :create], Tool
      end
    else
      can :create, User
    end
  end
end
