# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      if user.role == 'admin'
        can :manage, :all
      else
        can :manage, User, id: user.id
      end
    else
      can :create, User
    end
  end
end
