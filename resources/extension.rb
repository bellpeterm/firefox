actions :install, :remove

attribute :name, :name_attr => true, :kind_of => String
attribute :id, :required => true, :kind_of => String
attribute :uri, :required => true, :kind_of => String

default_action :install