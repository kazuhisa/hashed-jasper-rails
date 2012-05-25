require File.join(File.dirname(__FILE__), 'fake_app')
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module RR::Adapters::RRMethods
  def rrsatisfy(&block)
    RR::WildcardMatchers::Satisfy.new(block)
  end
end

describe "JasperSourceBuilder" do
  before "create jasper source" do
    record = [
        {:name => "Izumi Konata", :email => "konata@example.com"},
        {:name => "Hiiragi Tsukasa", :email => "tsukasa@example.com"},
        {:name => "Hiiragi Kagami", :email => "kagami@example.com"}
    ]
    @jasper_source_builder = JasperSourceBuilder.new(record,"jasper","record")
  end
  it "create xml" do
    xml = <<-EOS
          <?xml version='1.0' encoding='UTF-8'?>
          <jasper type='array'>
            <record>
              <name>Izumi Konata</name>
              <email>konata@example.com</email>
            </record>
            <record>
              <name>Hiiragi Tsukasa</name>
              <email>tsukasa@example.com</email>
            </record>
            <record>
              <name>Hiiragi Kagami</name>
              <email>kagami@example.com</email>
            </record>
          </jasper>
    EOS
    @jasper_source_builder.to_xml(nil).should == xml.gsub("\n","").gsub(/ +</,"<")
  end
end

describe "jasper_pdf method" do
  before "output pdf" do
    class Controller < ActionController::Base
      def output(arg)
        jasper_pdf(arg)
      end

      def params
        {:controller => "people",:action => "index"}
      end

      def send_data(*arg)
        # pass
      end
    end
    @controller = Controller.new

  end
  it "args in resource" do
    arg = {:resource => [{:name => "Konata", :age => 16}]}
    mock(JasperRails::Jasper::Rails).render_pdf("app/views/people/index.jasper",
                                                rrsatisfy{|arg| arg.to_xml(0) == "<?xml version='1.0' encoding='UTF-8'?><jasper type='array'><record><name>Konata</name><age>16</age></record></jasper>"},
                                                {:controller=>"people", :action=>"index"},{}){nil}
    @controller.output(arg)
  end

  it "args in resource and model and record" do
    arg = {:resource => [{:name => "Konata", :age => 16}], :model => "model_name", :record => "record_name"}
    mock(JasperRails::Jasper::Rails).render_pdf("app/views/people/index.jasper",
                                                rrsatisfy{|arg| arg.to_xml(0) == "<?xml version='1.0' encoding='UTF-8'?><model_name type='array'><record_name><name>Konata</name><age>16</age></record_name></model_name>"},
                                                {:controller=>"people", :action=>"index"},{}){nil}
    @controller.output(arg)
  end

  it "args in resource and template" do
    arg = {:resource => [{:name => "Konata", :age => 16}],:template => "people/print"}
    mock(JasperRails::Jasper::Rails).render_pdf("app/views/people/print.jasper",
                                                rrsatisfy{|arg| arg.to_xml(0) == "<?xml version='1.0' encoding='UTF-8'?><jasper type='array'><record><name>Konata</name><age>16</age></record></jasper>"},
                                                {:controller=>"people", :action=>"index"},{}){nil}
    @controller.output(arg)
  end

  it "args in resource and template with extention" do
    arg = {:resource => [{:name => "Konata", :age => 16}],:template => "people/print.jasper"}
    mock(JasperRails::Jasper::Rails).render_pdf("app/views/people/print.jasper",
                                                rrsatisfy{|arg| arg.to_xml(0) == "<?xml version='1.0' encoding='UTF-8'?><jasper type='array'><record><name>Konata</name><age>16</age></record></jasper>"},
                                                {:controller=>"people", :action=>"index"},{}){nil}
    @controller.output(arg)
  end
end