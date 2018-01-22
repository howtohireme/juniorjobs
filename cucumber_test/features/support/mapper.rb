module Routes
  class Mapper
    def self.path_for(route_name)
      mapping[route_name.to_sym][:path]
    end

    def self.page_class_for(route_name)
      mapping[route_name.to_sym][:page_class]
    end

    def self.mapping
      {
          home: {
            path: '/',
            page_class: Pages::Home
          },
          signUp: {
            path: '/signup',
            page_class: Pages::SignUp
          }
      }
    end
  end
end