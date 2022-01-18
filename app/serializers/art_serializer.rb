class ArtSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :title, :description, :price, :status_id, :photo
  belongs_to :status

  def photo
    rails_blob_path(object.photo, only_path: true)
  end
end
