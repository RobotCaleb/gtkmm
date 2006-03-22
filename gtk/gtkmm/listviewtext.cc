/* Copyright(C) 2006 The gtkmm Development Team
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or(at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the Free
 * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#include <gtkmm/listviewtext.h>
#include <sstream>

ListViewText::TextModelColumns::TextModelColumns(guint columns_count)
: m_columns_count(columns_count)
{
  m_data = new Gtk::TreeModelColumn<Glib::ustring>[m_columns_count];

  if(m_data)
  {
    for(guint i = 0; i < m_columns_count; ++i)
    {
      add(m_data[i]);
    }
  }
}

ListViewText::TextModelColumns::~TextModelColumns()
{
  if(m_data)
    delete[] m_data;
}

guint ListViewText::TextModelColumns::get_num_columns() const
{
  return m_columns_count;
}

ListViewText::ListViewText(guint columns_count, bool editable, Gtk::SelectionMode mode)
{
  std::ostringstream columnTitle;

  // Create model
  m_model_columns = new TextModelColumns(columns_count); 

  m_model = Gtk::ListStore::create( *m_model_columns );	
  set_model(m_model);

  // Append columns
  for(guint i = 0; i < columns_count; ++i)
  {
    columnTitle.str( Glib::ustring() );
    columnTitle << "column#" << i;		

    if(editable)
      append_column_editable(columnTitle.str(), m_model_columns->m_data[i]);
    else
      append_column( columnTitle.str(), m_model_columns->m_data[i] );
  }

  // Set multiple or simple selection
  get_selection()->set_mode(mode);
}

ListViewText::~ListViewText()
{
  if(m_model_columns)
    delete m_model_columns;
}

void ListViewText::set_column_title(guint column, const Glib::ustring& title)
{
  g_return_if_fail( column < get_columns().size() );

  get_column(column)->set_title(title);
}

Glib::ustring ListViewText::get_column_title(guint column) const
{
  g_return_val_if_fail( column < get_columns().size(), Glib::ustring() );

  return get_column(column)->get_title();
}

guint ListViewText::append_text(const Glib::ustring& column_one_value)
{
  Gtk::TreeModel::Row newRow = *(m_model->append());

  newRow[m_model_columns->m_data[0]] = column_one_value;

  return size() -1;
}

void ListViewText::prepend_text(const Glib::ustring& column_one_value)
{
  Gtk::TreeModel::Row newRow = *( m_model->prepend() );

  newRow[m_model_columns->m_data[0]] = column_one_value;
}

void ListViewText::insert_text(guint row, const Glib::ustring& column_one_value)
{
  g_return_if_fail( row < size() );

  Gtk::ListStore::const_iterator iter = m_model->children()[row];
  Gtk::TreeModel::Row newRow = *(m_model->insert(iter));

  if(!column_one_value.empty())
  {
    newRow[m_model_columns->m_data[0]] = column_one_value;
  }
}

void ListViewText::clear_items()
{
  m_model->clear();
}

Glib::ustring ListViewText::get_text(guint row, guint column) const
{
  Glib::ustring result;

  g_return_val_if_fail( row < size(), result );

  Gtk::TreeModel::iterator iter = m_model->children()[row];	 
  iter->get_value(column, result);

  return result;
}

void ListViewText::set_text(guint row, guint column, const Glib::ustring& value)
{
  g_return_if_fail( row < size() );

  Gtk::TreeModel::iterator iter = m_model->children()[row];
  (*iter)->set_value(column, value);
}

void ListViewText::set_text(guint row, const Glib::ustring& value)
{
  g_return_if_fail( row < size() );

  Gtk::TreeModel::iterator iter = m_model->children()[ row ];
  (*iter)->set_value(0, value);
}

guint ListViewText::size() const
{
  return (guint)m_model->children().size();
}

guint ListViewText::get_num_columns() const
{
  return m_model_columns->get_num_columns();
}

ListViewText::SelectionList ListViewText::get_selected()
{
  Glib::RefPtr<Gtk::TreeSelection> selected = get_selection();
  Gtk::TreeSelection::ListHandle_Path selectedRows = selected->get_selected_rows();

  // Reserve space
  SelectionList selectionList;
  selectionList.reserve( selected->count_selected_rows() );

  // Save selected rows

  for(Gtk::TreeSelection::ListHandle_Path::const_iterator iter = selectedRows.begin(); iter != selectedRows.end(); ++iter)
  {
    selectionList.push_back( *((*iter).begin()) );
  }

  return selectionList;
}
