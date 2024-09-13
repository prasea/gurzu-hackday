module ApplicationHelper
  def link_to_add_association(name, form, association, html_options = {})
    new_object = form.object.send(association).klass.new
    id = new_object.object_id
    fields = form.fields_for(association, new_object, child_index: id) do |builder|
      render("#{association.to_s.singularize}_fields", f: builder)
    end
    link_to(name, "#", class: html_options[:class], id: html_options[:id], data: { fields: fields.gsub("\n", ""), association_insertion_node: html_options[:data][:association_insertion_node], association_insertion_method: html_options[:data][:association_insertion_method] }.merge(html_options))
  end

  def link_to_add_fields(name, f, association)
    # Buld an instance of association record.  For ParkSpace instance (f), calling association instance (:vehicles),  klass is the Vehcile model, calling new to build Vehicle instance 
    new_object = f.object.send(association).klass.new 
    # To generate unique random value
    id = new_object.object_id 
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + '_fields', f:builder)
    end
    link_to(name, '#', class: 'add_fields btn btn-outline-secondary mb-3', data: {id: id, fields: fields.gsub("\n", "")} )
  end
end
