require "./spec_helper"

# class FooException < Exception
# end

# class Foo
#   def foo
#     raise FooException.new("#{ {dir: __DIR__, file: __FILE__, line: __LINE__, class: self.class.name, method: {{@def.name.stringify}}, message: "some message" }.pretty_inspect }")
#   end
# end

describe ExampleAppKemal do
  # TODO: Write tests

  # You can use get,post,put,patch,delete to call the corresponding route.
  it "renders /" do
    get "/"
    response.body.should eq "Hello World!"
  end

  # it "raises an error" do
  #   expect_raises(FooException, "bar") { Foo.new.foo }
  # end
end
