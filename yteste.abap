*&---------------------------------------------------------------------*
*& Report YTESTE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT yteste.

* Sample XML contents.
*  <?xml version="1.0"?>
*  <Company>
*   <CompanyName>SAP</CompanyName>
*   <Employee Type="FT">
*    <EmployeeName>James</EmployeeName>
*    <EmployeeNumber>007</EmployeeNumber>
*   </Employee>
*  </Company>

DATA:
    i_tab_converted_data  TYPE truxs_xml_table .

DATA(lv_matnr) = '000000000031000012' .

SELECT *
  FROM makt
  INTO TABLE @DATA(lt_makt)
 WHERE matnr EQ @lv_matnr .

*IF ( sy-subrc EQ 0 ) .
*
*  DATA : lr_ixml       TYPE REF TO if_ixml,
*         lr_doc        TYPE REF TO if_ixml_document,
*         lr_root_elem  TYPE REF TO if_ixml_element,
*         lr_node1_elem TYPE REF TO if_ixml_element,
*         lr_stream     TYPE REF TO if_ixml_stream_factory,
*         lr_ostream    TYPE REF TO if_ixml_ostream,
*         lr_render     TYPE REF TO if_ixml_renderer,
*         xml_string    TYPE string.
*
*  lr_ixml = cl_ixml=>create( 0 ).
** Get reference of the document
*  lr_doc = lr_ixml->create_document( ).
** get reference of the root
*  lr_root_elem = lr_doc->create_simple_element_ns( "prefix = 'asx'
*                                                   name = 'test'
*                                                   parent = lr_doc ).
*
*** Add root element attributes
**  lr_root_elem->set_attribute_ns( name =  'asx'
**  prefix = 'xmlns'
**  value = 'http://www.sap.com/testxml' ).
**  lr_root_elem->set_attribute_ns( name =  'version'
**  value = '1.0' ).
*
** Get reference of the first node of teh root
*  lr_node1_elem  = lr_doc->create_simple_element_ns( "prefix = 'asx'
*                                                     name = 'names'
*                                                     parent = lr_root_elem ).
*
** add node 1 to the document
*  lr_doc->create_simple_element_ns( name = 'name'
*                                    value = 'sap'
*                                    parent = lr_node1_elem  ) .
*
*  lr_doc->create_simple_element_ns( name = 'name'
*                                    value = 'OtherSAP'
*                                    parent = lr_node1_elem  ) .
*
*  lr_stream = lr_ixml->create_stream_factory( ).
*
*  lr_ostream = lr_stream->create_ostream_cstring( xml_string ).
*  lr_render = lr_ixml->create_renderer( document = lr_doc
*  ostream  = lr_ostream ).
*
*  lr_render->render( ).
*
*  cl_abap_browser=>show_xml(
*  EXPORTING
*  xml_string  =  xml_string
*  title       =  'test xml'
*  size        = cl_abap_browser=>medium ).    " size (s,M.l,xl)
*
*  ENDIF .

  BREAK-POINT .


  CLASS ixml_demo DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS main.
ENDCLASS.

CLASS ixml_demo IMPLEMENTATION.
  METHOD main.
    DATA(ixml)     = cl_ixml=>create( ).
    DATA(document) = ixml->create_document( ).

    DATA(root) = document->create_simple_element_ns(
                   prefix = 'asx'
                   name = 'abap'
                   parent = document ).
    root->set_attribute_ns( prefix = 'xmlns'
                            name = 'asx'
                            value = 'http://www.sap.com/abapxml' ).
    root->set_attribute_ns( name =  'version'
                            value = '1.0' ).

    DATA(node1) = document->create_simple_element_ns(
                    prefix = 'asx'
                    name = 'values'
                    parent = root ).

    document->create_simple_element_ns(
                name = 'TEXT'
                value = 'Hello XML'
                parent = node1 ).

    DATA xml_string TYPE string.
    ixml->create_renderer( document = document
                           ostream  = ixml->create_stream_factory(
                                        )->create_ostream_cstring(
                                             string = xml_string )
                                               )->render( ).
    cl_demo_output=>write_xml( xml_string ).

    DATA result TYPE string.
    CALL TRANSFORMATION id SOURCE XML xml_string
                           RESULT  text = result.
    cl_demo_output=>write_data( result ).

    cl_demo_output=>display( ).
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  ixml_demo=>main( ).
