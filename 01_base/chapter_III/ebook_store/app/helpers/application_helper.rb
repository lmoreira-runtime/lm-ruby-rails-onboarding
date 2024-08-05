# frozen_string_literal: true

# Helper methods for the application.
module ApplicationHelper
  def text_with_label(form, field, options = {})
    label_text = options.delete(:label) || field.to_s.humanize
    field_type = options.delete(:field_type) || :text_field
    additional_classes = options.delete(:class) || 'form-control'
    label_classes = options.delete(:label_class) || 'control-label'

    content_tag :div, class: 'field form-group mb-3' do
      concat form.label(field, label_text, class: label_classes)
      concat form.send(field_type, field, options.merge(class: additional_classes))
    end
  end
end
