# -*- coding: utf-8 -*-

require 'rubygems'
require 'action_dispatch'
Mime::Type.unregister :pdf
require 'jasper-rails'
require 'hashed-jasper-rails/jasper_source_builder'
