require 'helper'

class TestAttrtastic < TestCase

  context "Attrtastic" do

    setup do
      setup_fixtures
    end

    should "work with verbose syntax version" do
      expected = html <<-EOHTML
        <div class="attrtastic user">
          <div class="attributes">
          <div class="legend"><span>User</span></div>
            <ol>
              <li class="attribute strong">
                <span class="label">First Name:</span>
                <span class="value">John</span>
              </li>
              <li class="attribute">
                <span class="label">Last Name:</span>
                <span class="value">Doe</span>
              </li>
            </ol>
          </div>

          <div class="attributes">
            <div class="legend"><span>Contact</span></div>
            <ol>
              <li class="attribute">
                <span class="label">Email:</span>
                <span class="value">john@doe.com</span>
              </li>
            </ol>
          </div>
        </div>
      EOHTML

      actual = @template.semantic_attributes_for(@user) do |attr|
        @template.output_buffer << attr.attributes("User") do
          @template.output_buffer << (attr.attribute :first_name, :html => {:class => :strong}).to_s
          @template.output_buffer << (attr.attribute :last_name)
          @template.output_buffer << (attr.attribute :title).to_s
        end
        @template.output_buffer << attr.attributes(:name => "Contact") do
          @template.output_buffer << (attr.attribute :email)
        end
      end

      assert_equal expected, actual
    end

    should "work with compact syntax version" do
      expected = html <<-EOHTML
        <div class="attrtastic user">
          <div class="attributes">
            <div class="legend"><span>User</span></div>
            <ol>
              <li class="attribute">
                <span class="label">First Name:</span>
                <span class="value">John</span>
              </li>
              <li class="attribute">
                <span class="label">Last Name:</span>
                <span class="value">Doe</span>
              </li>
            </ol>
          </div>

          <div class="attributes">
            <div class="legend"><span>Contact</span></div>
            <ol>
              <li class="attribute">
                <span class="label">Email:</span>
                <span class="value">john@doe.com</span>
              </li>
            </ol>
          </div>
        </div>
      EOHTML

      actual = @template.semantic_attributes_for(@user) do |attr|
        @template.output_buffer << attr.attributes("User", :first_name, :last_name, :title)
        @template.output_buffer << attr.attributes("Contact", :email)
      end

      assert_equal expected, actual
    end

    context "Default Options" do
      should "setup default options" do
        assert Attrtastic.default_options.is_a?(Hash)
      end

      should "set default options" do
        Attrtastic.default_options[:display_empty] = true
        expected = {:display_empty => true}

        assert_equal expected, Attrtastic.default_options
      end

      should "reset default options" do
        Attrtastic.default_options[:display_empty] = true
        Attrtastic.reset_default_options
        assert_equal Hash.new, Attrtastic.default_options

      end
    end

  end

end
