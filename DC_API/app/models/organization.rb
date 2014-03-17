class Organization
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  include Grape::Entity::DSL

  has_many :locations, dependent: :destroy
  #embeds_many :locations
  #accepts_nested_attributes_for :locations

  normalize_attributes :name

  field :name
  slug :name, history: true
  field :urls, type: Array

  validates_presence_of :name

  paginates_per Rails.env.test? ? 1 : 30

  after_save :refresh_tire_index
  def refresh_tire_index
    self.locations.each { |loc| loc.update_index }
  end

  def url
    "#{root_url}organizations/#{self.id}"
  end

  def locations_url
    "#{root_url}organizations/#{self.id}/locations"
  end

  def root_url
    Rails.application.routes.url_helpers.root_url
  end

  entity do
    expose :id
    expose :name
    expose :slugs
    expose :url
    expose :locations_url
  end

end
