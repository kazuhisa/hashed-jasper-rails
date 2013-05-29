# -*- coding: utf-8 -*-
require "rexml/document"

class JasperSourceBuilder
  def initialize(data_source, model, record)
    @out_doc = REXML::Document.new()
    @out_doc.add(REXML::XMLDecl.new(version="1.0", encoding="UTF-8"))
    elem = REXML::Element.new(model)
    elem.add_attribute("type","array")

    data_source.each do |data|
      row = REXML::Element.new(record)
      data.each_pair do |k,v|
        cell = REXML::Element.new(k.to_s)
        cell.add_text(v.to_s)
        row.add_element(cell)
      end
      elem.add_element(row)
    end
    @out_doc.add(elem)
  end

  def to_xml(dummy)
    @out_doc.to_s
  end
end

class ActionController::Base
  private
  def jasper_pdf(arg)
    model_name = arg[:model] || "jasper"
    record_name = arg[:record] || "record"
    unless arg[:template].nil?
      jasper_file = File.join("app/views",arg[:template])
      jasper_file += ".jasper" unless jasper_file =~ /.jasper$/
    else
      jasper_file = File.join("app/views",params[:controller],params[:action]) + ".jasper"
    end
    if arg[:resource].size > 0 && arg[:resource][0].kind_of?(Hash)
      resource = JasperSourceBuilder.new(arg[:resource], model_name, record_name)
    else
      resource = arg[:resource]
    end
	params = arg[:params] || {}
    options = arg[:options] || {}
    send_data JasperRails::Jasper::Rails.render_pdf(jasper_file, resource, params, options), :type => Mime::PDF
  end
end
