class FooRequiredParamResource < ActiveResource::Base
  self.site = "http://fake-foo-api.dev/"
  self.element_name = 'foo'
end
