class ScriptPolicy < ApplicationPolicy
  def show?
    true
  end

  def edit?
    owner?
  end

  def update?
  end

  def serve?
    true
  end

  private
    def owner?
      record.user == account_user.user
    end
end