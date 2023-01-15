class BioSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :biography, :artist_statement, :photo

  def photo
    url_for(object.photo)
  end
end
